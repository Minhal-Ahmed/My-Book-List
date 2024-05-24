import 'package:flutter/material.dart';
import 'book.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

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
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.network(
                      volumeInfo['imageLinks'] != null
                          ? volumeInfo['imageLinks']['thumbnail']
                          : 'https://via.placeholder.com/150',
                      height: 200,
                    ),
                    SizedBox(height: 20),
                    Text(
                      'Title: ${volumeInfo['title']}',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'Author: ${volumeInfo['authors']?.join(", ") ?? 'N/A'}',
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(height: 10),
                    if (volumeInfo['description'] != null)
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Description: ${volumeInfo['description']}',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 14),
                        ),
                      ),
                    if (volumeInfo['averageRating'] != null)
                      Text(
                        'Rating: ${volumeInfo['averageRating']} / 5',
                        style: TextStyle(fontSize: 16),
                      ),
                    if (volumeInfo['pageCount'] != null)
                      Text(
                        'Number of Pages: ${volumeInfo['pageCount']}',
                        style: TextStyle(fontSize: 16),
                      ),
                    if (volumeInfo['publishedDate'] != null)
                      Text(
                        'Publication Date: ${volumeInfo['publishedDate']}',
                        style: TextStyle(fontSize: 16),
                      ),
                  ],
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
}
