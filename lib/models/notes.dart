import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class Notes {
  final String id;
  final String title;
  final String content;
  final DateTime time;

  const Notes(
      {required this.id ,required this.title,
        required this.content,required this.time
        });

  static Notes fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return Notes(
      id: snap.id,
      title: snapshot["title"],
      content: snapshot["content"],
      time: (snapshot["lastUpdated"] as Timestamp).toDate()
    );
  }

  static Map<String, dynamic> toJson(Notes notes) => {
    "title": notes.title,
    "content": notes.content
  };
}

