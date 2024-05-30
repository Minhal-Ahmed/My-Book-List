import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_application_1/Pages/notes.dart';
import 'book.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> saveBook(Book book) async {
    final user = _auth.currentUser;
    if (user == null) {
      return;
    }

    final userDoc = _firestore.collection('users').doc(user.uid);
    final savedBooksCollection = userDoc.collection('savedBooks');

    await savedBooksCollection.doc(book.id.toString()).set(book.toMap());
  }

  Future<void> deleteBook(Book book) async {
    final user = _auth.currentUser;
    if (user == null) {
      return;
    }

    final userDoc = _firestore.collection('users').doc(user.uid);
    final savedBooksCollection = userDoc.collection('savedBooks');

    await savedBooksCollection.doc(book.id.toString()).delete();
  }


  Future<List<Book>> getSavedBooks() async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        // Handle user not logged in
        return [];
      }

      final savedBooksSnapshot = await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('savedBooks')
          .get();

      final savedBooks = savedBooksSnapshot.docs
          .map((doc) => Book.fromMap(doc.data()))
          .toList();

      print('Retrieved saved books: $savedBooks');
      return savedBooks;
    } catch (e) {
      print('Error fetching saved books: $e');
      return [];
    }
  }

  

  Future<void> saveNote(Note note) async {
    final user = _auth.currentUser;
    if (user == null) {
      return;
    }

    final userDoc = _firestore.collection('users').doc(user.uid);
    final notesCollection = userDoc.collection('notes');

    await notesCollection.add(note.toMap());
  }


  Future<List<Note>> getSavedNotes() async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        return [];
      }

      final notesSnapshot = await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('notes')
          .get();

      final savedNotes = notesSnapshot.docs
          .map((doc) => Note.fromMap(doc.data(), doc.id))
          .toList();

      return savedNotes;
    } catch (e) {
      print('Error fetching saved notes: $e');
      return [];
    }
  }


Future<void> deleteNoteById(String noteId) async {
    final user = _auth.currentUser;
    if (user == null) {
      return;
    }

    final userDoc = _firestore.collection('users').doc(user.uid);
    await userDoc.collection('notes').doc(noteId).delete();
  }

}



