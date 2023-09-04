import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:keep_notes_app/repository/crud_repository.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'landing_page_provider.dart';

class AddNoteProvider extends ChangeNotifier {
  final titleController = TextEditingController();
  final noteController = TextEditingController();
  final crudRepository = CRUDRepository();

  final Box notesBox = Hive.box("notes");

  List<String> deleteKeys = [];

  Future<void> createNotes(BuildContext context) async {
    var provider = Provider.of<LandingPageProvider>(context, listen: false);
    try {
      if (provider.isNetworkAvailable) {
        DocumentReference doc = await crudRepository.addNotes(
            titleController.text, noteController.text);
        await notesBox.add({
          'firebaseId': doc.id,
          'title': titleController.text,
          'content': noteController.text,
          'lastUpdated': DateTime.now()
        });
      } else {
        await notesBox.add({
          'firebaseId': null,
          'title': titleController.text,
          'content': noteController.text,
          'lastUpdated': DateTime.now()
        });
      }
    } catch (e) {
      print("Error creating Notes: $e");
    }
  }

  Future<void> updateNotes(String? id, int? index, BuildContext context) async {
    var provider = Provider.of<LandingPageProvider>(context, listen: false);
    try {
      index ??= notesBox.values
          .toList()
          .indexWhere((note) => note["firebaseId"] == id);
      if (provider.isNetworkAvailable) {
        await crudRepository.updateNotesById(
            id, titleController.text, noteController.text);
        await notesBox.putAt(index!, {
          'firebaseId': id,
          'title': titleController.text,
          'content': noteController.text,
          'lastUpdated': DateTime.now()
        });
      } else {
        await notesBox.putAt(index!, {
          'firebaseId': id,
          'title': titleController.text,
          'content': noteController.text,
          'lastUpdated': DateTime.now()
        });
      }
    } catch (e) {
      print("Error updating Notes: $e");
    }
  }

  Future<void> deleteNote(String? id, int? index, BuildContext context) async {
    var provider = Provider.of<LandingPageProvider>(context, listen: false);
    try {
      index ??= notesBox.values
          .toList()
          .indexWhere((note) => note["firebaseId"] == id);

      if (provider.isNetworkAvailable && id!=null) {
        await crudRepository.deleteNotesById(id);
        if(index!=-1) {
          await notesBox.deleteAt(index!);
        }
      } else if(!provider.isNetworkAvailable){
        var note = notesBox.getAt(index!);
        if(note["firebaseId"]!=null) {
          deleteKeys.add(note["firebaseId"]);
        }
        await notesBox.deleteAt(index!);
      }
    } catch (e) {
      print("Error deleting Notes: $e");
    }
  }
}
