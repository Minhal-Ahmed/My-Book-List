import 'package:flutter/material.dart';
import 'package:flutter_application_1/Components/color.dart';
import 'book.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';

class BookDetailsScreen extends StatefulWidget {
  final Book book;

  BookDetailsScreen({required this.book});

  @override
  _BookDetailsScreenState createState() => _BookDetailsScreenState();
}

class _BookDetailsScreenState extends State<BookDetailsScreen> {
  late Future<Map<String, dynamic>> _bookDetails;

  @override
  void initState() {
    super.initState();
    _bookDetails = fetchBookDetails(widget.book.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.book.title),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _bookDetails,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            var volumeInfo = snapshot.data!['volumeInfo'];
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Card(
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Image.network(
                            volumeInfo['imageLinks'] != null
                                ? volumeInfo['imageLinks']['thumbnail']
                                : 'https://via.placeholder.com/150',
                            height: 200,
                          ),
                        ),
                        SizedBox(height: 20),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Text(
                                volumeInfo['title'],
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            IconButton(
                              icon: Icon(Icons.bookmark_add, size: 30, color:primaryColor),
                              onPressed: () => saveBookDetails(volumeInfo),
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Author: ${volumeInfo['authors']?.join(", ") ?? 'N/A'}',
                          style: TextStyle(fontSize: 18, color: Colors.grey[700]),
                        ),
                        SizedBox(height: 20),
                        if (volumeInfo['description'] != null)
                          Text(
                            volumeInfo['description'],
                            textAlign: TextAlign.justify,
                            style: TextStyle(fontSize: 16, color: Colors.grey[800]),
                          ),
                        SizedBox(height: 20),
                        if (volumeInfo['averageRating'] != null)
                          Text(
                            'Rating: ${volumeInfo['averageRating']} / 5',
                            style: TextStyle(fontSize: 18, color: Colors.grey[700]),
                          ),
                        if (volumeInfo['pageCount'] != null)
                          Text(
                            'Number of Pages: ${volumeInfo['pageCount']}',
                            style: TextStyle(fontSize: 18, color: Colors.grey[700]),
                          ),
                        if (volumeInfo['publishedDate'] != null)
                          Text(
                            'Publication Date: ${volumeInfo['publishedDate']}',
                            style: TextStyle(fontSize: 18, color: Colors.grey[700]),
                          ),
                        SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ),
            );
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  Future<Map<String, dynamic>> fetchBookDetails(String bookId) async {
    final response = await http.get(
      Uri.parse('https://www.googleapis.com/books/v1/volumes/$bookId'),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load book details');
    }
  }

  Future<void> saveBookDetails(Map<String, dynamic> volumeInfo) async {
    CollectionReference books = FirebaseFirestore.instance.collection('books');
    await books.add({
      'title': volumeInfo['title'],
      'authors': volumeInfo['authors']?.join(", "),
      
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Added to List')),
    );
  }
}
