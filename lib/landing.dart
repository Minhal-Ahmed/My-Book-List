import 'package:flutter/material.dart';
import 'package:flutter_application_1/books/book.dart';
import 'package:flutter_application_1/books/details.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Discover',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: BookListScreen(),
    );
  }
}

class BookListScreen extends StatefulWidget {
  @override
  _BookListScreenState createState() => _BookListScreenState();
}

class _BookListScreenState extends State<BookListScreen> {
  late Future<List<Book>> _books;
  final TextEditingController _controller = TextEditingController();
  String _query = 'kite runner';

  @override
  void initState() {
    super.initState();
    _books = fetchBooks(_query);
  }

  Future<List<Book>> fetchBooks(String query) async {
  //final apiKey = 'AIzaSyBYnIUtjwtuYKeVPpHfbUadotvsiExjs4Q';
  final response = await http.get(
    Uri.parse('https://www.googleapis.com/books/v1/volumes?q=$query'),
  );

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      List books = data['items'];
      return books.map((book) => Book.fromJson(book)).toList();
    } else {
      throw Exception('Failed to load books');
    }
  }

  void _search() {
    setState(() {
      _query = _controller.text;
      _books = fetchBooks(_query);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dicover'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: 'Search books',
                suffixIcon: IconButton(
                  icon: Icon(Icons.search),
                  onPressed: _search,
                ),
              ),
              onSubmitted: (text) => _search(),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Book>>(
              future: _books,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      Book book = snapshot.data![index];
                      return ListTile(
                        leading: Image.network(
                          book.imageUrl,
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                        ),
                        title: Text(book.title),
                        subtitle: Text(book.author),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => BookDetailsScreen(book: book),
                            ),
                          );
                        },
                      );
                    },
                  );
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }
                return Center(child: CircularProgressIndicator());
              },
            ),
          ),
        ],
      ),
    );
  }
}