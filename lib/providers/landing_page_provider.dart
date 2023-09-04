import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:keep_notes_app/repository/crud_repository.dart';
import 'package:keep_notes_app/utils/global_variables.dart';
import 'package:provider/provider.dart';

import '../models/notes.dart';
import 'create_note_provider.dart';

class LandingPageProvider extends ChangeNotifier {
  final crudRepository = CRUDRepository();

  late StreamSubscription<ConnectivityResult> _connectionStream;

  StreamController<List<DocumentSnapshot>> streamController =
      StreamController<List<DocumentSnapshot>>.broadcast();

  bool isNetworkAvailable = false;

  final Box notesBox = Hive.box("notes");

  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;

  List<List<DocumentSnapshot>> notes = [<DocumentSnapshot>[]];

  static const int notesLimit = 10;

  DocumentSnapshot? lastDocument;

  bool hasMoreData = true;

  bool isLoading = true;

  GlobalKey<ScaffoldState> drawerKey = GlobalKey();

  void getNotes() async {
    var query = _fireStore
        .collection('notes')
        .orderBy('lastUpdated', descending: true)
        .limit(notesLimit);

    if (lastDocument != null) {
      query = query.startAfterDocument(lastDocument!);
    }

    if (!hasMoreData) return;

    isLoading = true;
    notifyListeners();

    var currentRequestIndex = notes.length;
    query.snapshots().listen(
      (snapshot) {
        if (snapshot.docs.isNotEmpty) {
          var docsList = snapshot.docs.toList();


          var pageExists = currentRequestIndex < notes.length;

          if (pageExists) {
            notes[currentRequestIndex] = docsList;
          } else {
            notes.add(docsList);
          }

          var allNotes = notes.fold<List<DocumentSnapshot>>(
              <DocumentSnapshot>[],
              (initialValue, pageItems) => initialValue..addAll(pageItems));

          streamController.add(allNotes);

          isLoading = false;
          notifyListeners();

          if (currentRequestIndex == notes.length - 1) {
            lastDocument = snapshot.docs.last;
          }

          hasMoreData = (docsList.length == notesLimit);
        }else{
          isLoading = false;
          notifyListeners();
        }
      },
    );
  }

  Future<void> checkConnectivity(BuildContext context) async {
    _connectionStream = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) async {
      isNetworkAvailable = (result != ConnectivityResult.none);
      if (isNetworkAvailable) {
        await dataSync(context);
        hasMoreData = true;
        lastDocument = null;
        notes = [<DocumentSnapshot>[]];
        notifyListeners();
        getNotes();
      }
      notifyListeners();
    });
  }

  Future<void> dataSync(BuildContext context) async {
    var hiveList = notesBox.values.toList();
    var addNoteProvider = Provider.of<AddNoteProvider>(context, listen: false);

    for (var data in hiveList) {
      if (data["firebaseId"] == null) {
        DocumentReference value = await _fireStore.collection('notes').add({
          'title': data["title"],
          'content': data["content"],
          'lastUpdated': data["lastUpdated"]
        });
        data["firebaseId"] = value.id;
      } else {
        await _fireStore.collection('notes').doc(data["firebaseId"]).set({
          'title': data["title"],
          'content': data["content"],
          'lastUpdated': data["lastUpdated"]
        });
      }
    }

    for (var id in addNoteProvider.deleteKeys) {
      await _fireStore.collection('notes').doc(id).delete();
    }
  }
}
