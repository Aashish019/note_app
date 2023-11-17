import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';

class FireStoreService {
  //get collections of notes
  final CollectionReference notes =
      FirebaseFirestore.instance.collection('notes');

  //create add a new note
  Future<void> addNote(String note) {
    return notes.add({
      'note': note,
      'timestamp': Timestamp.now(),
    });
  }

  //read get note database
  Stream<QuerySnapshot> getReadNotes() {
    final noteStream = notes.orderBy('timestamp', descending: true).snapshots();
    return noteStream;
  }

  //update notes given a doc id
  Future<void> updateNote(String docId, String newNote) {
    return notes.doc(docId).update({
      'note': newNote,
      'timestamp': Timestamp.now(),
    });
  }

  //delete a note from the given doc id
  Future<void> deleteNote(String docId) {
    return notes.doc(docId).delete();
  }
}
