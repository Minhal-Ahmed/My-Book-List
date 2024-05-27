import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
}
