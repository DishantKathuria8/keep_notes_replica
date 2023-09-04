import 'package:cloud_firestore/cloud_firestore.dart';

class CRUDRepository {
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;

  Future<DocumentReference> addNotes(String title, String content) async {
    DocumentReference value = await _fireStore.collection('notes').add(
        {'title': title, 'content': content, 'lastUpdated': DateTime.now()});

    return value;
  }

  //  Future<Query<Map<String, dynamic>>> getNotes() async{
  //   return _fireStore
  //       .collection('notes').orderBy('lastUpdated', descending: true).limit(10);
  // }
  //
  // Future<DocumentSnapshot> getNotesById(String? id) async {
  //   return await _fireStore.collection('notes').doc(id).get();
  // }

  Future<void> updateNotesById(String? id, String title, String content) async {
    await _fireStore.collection('notes').doc(id).set(
        {'title': title, 'content': content, 'lastUpdated': DateTime.now()});
  }

  Future<void> deleteNotesById(String? id) async {
    await _fireStore.collection('notes').doc(id).delete();
  }
}
