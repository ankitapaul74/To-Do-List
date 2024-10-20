import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models_note.dart';


class NotesProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance; // Firebase Authentication for current user

  List<Note> _notes = [];
  List<Note> get notes => _notes;


  Future<void> fetchNotes() async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {

        final snapshot = await _firestore
            .collection('notes')
            .where('uid', isEqualTo: user.uid)
            .get();

        _notes = snapshot.docs
            .map((doc) => Note.fromMap(doc.data()))
            .toList();
        notifyListeners();
      }
    } catch (e) {
      print('Error fetching notes: $e');
    }
  }


  Future<void> addNote(Note note) async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {

        final noteData = note.toMap();
        noteData['uid'] = user.uid;

        await _firestore.collection('notes').add(noteData);
        _notes.add(note);
        notifyListeners();
      }
    } catch (e) {
      print('Error adding note: $e');
    }
  }


  Future<void> updateNote(Note note) async {
    try {
      User? user = _auth.currentUser; // Get current user
      if (user != null && note.id != null) {
        final noteRef = _firestore.collection('notes').doc(note.id);


        await noteRef.update(note.toMap());
        final index = _notes.indexWhere((n) => n.id == note.id);
        if (index != -1) {
          _notes[index] = note;
          notifyListeners();
        }
      }
    } catch (e) {
      print('Error updating note: $e');
    }
  }

  // Delete a note from Firestore
  Future<void> deleteNote(Note note) async {
    try {
      User? user = _auth.currentUser;
      if (user != null && note.id != null) {

        await _firestore.collection('notes').doc(note.id).delete();
        _notes.remove(note);
        notifyListeners();
      }
    } catch (e) {
      print('Error deleting note: $e');
    }
  }
}
