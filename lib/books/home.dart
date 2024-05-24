/*import 'package:flutter/material.dart';
import 'package:flutter_application_1/Components/color.dart';

class Home extends StatefulWidget {
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String buttonName = 'Click';
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('HOME'),
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontSize: 25.0,
          color: Color.fromARGB(255, 251, 246, 246),
        ),
      ),
      backgroundColor: Color.fromARGB(255, 251, 249, 249),
      body: Center(
        child: getCurrentPage(),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            label: 'Home',
            icon: Icon(
              Icons.home,
              color: icons,
            ),
          ),
          
          BottomNavigationBarItem(
            label: 'Read List',
            icon: Icon(
              Icons.list,
              color:icons,
            ),
          ),

          BottomNavigationBarItem(
            label: 'Settings',
            icon: Icon(
              Icons.settings,
              color: icons,
            ),
          ),
        ],
        currentIndex: currentIndex,
        onTap: (int index) {
          setState(() {
            currentIndex = index;
          });
        },
      ),
    );
  }

  Widget getCurrentPage() {
    switch (currentIndex) {
      case 0:
        return Container(
          width: double.infinity,
          height: double.infinity,
          color: const Color.fromARGB(255, 255, 255, 255),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                ),
                onPressed: () {
                  setState(() {
                    buttonName = 'Clicked';
                  });
                },
                child: Text(buttonName),
              ),
            ],
          ),
        );
      case 1:
        return ListView(
          children: [
            ListTile(
              leading: Icon(Icons.book),
              title: Text('Item 1'),
            ),
            ListTile(
              leading: Icon(Icons.book),
              title: Text('Item 2'),
            ),
            ListTile(
              leading: Icon(Icons.book),
              title: Text('Item 3'),
            ),
          ],
        );

      case 2:
      return Center(
          child: Text('Settings Page'),
        );

      default:
        return Container();
    }
  }
}
*/

/*
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        appBarTheme: AppBarTheme(
          iconTheme: IconThemeData(color: Colors.black),
          color: Color.fromARGB(255, 0, 0, 0),
        ),
      ),
      home: Home(),
    );
  }
}

class Home extends StatefulWidget {
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int currentIndex = 0;
  List<Book> toReadList = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('HOME'),
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontSize: 25.0,
          color: Color.fromARGB(255, 251, 246, 246),
        ),
      ),
      backgroundColor: Color.fromARGB(255, 251, 249, 249),
      body: getCurrentPage(),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            label: 'Home',
            icon: Icon(
              Icons.home,
              color: Color.fromARGB(255, 16, 16, 16),
            ),
          ),
          BottomNavigationBarItem(
            label: 'To-Read List',
            icon: Icon(
              Icons.list,
              color: Color.fromARGB(255, 11, 11, 11),
            ),
          ),
          BottomNavigationBarItem(
            label: 'Settings',
            icon: Icon(
              Icons.settings,
              color: Color.fromARGB(255, 11, 11, 11),
            ),
          ),
        ],
        currentIndex: currentIndex,
        onTap: (int index) {
          setState(() {
            currentIndex = index;
          });
        },
      ),
    );
  }

  Widget getCurrentPage() {
    switch (currentIndex) {
      case 0:
        return HomePage(onBookAdd: addBookToReadList);
      case 1:
        return ToReadListPage(toReadList: toReadList);
      case 2:
        return SettingsPage();
      default:
        return Container();
    }
  }

  void addBookToReadList(Book book) {
    setState(() {
      toReadList.add(book);
    });
  }
}

class HomePage extends StatefulWidget {
  final Function(Book) onBookAdd;

  HomePage({required this.onBookAdd});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController searchController = TextEditingController();
  List<Book> books = [];

  void searchBooks(String query) async {
    final response = await http.get(Uri.parse(
        'https://www.googleapis.com/books/v1/volumes?q=$query&key=AIzaSyBYnIUtjwtuYKeVPpHfbUadotvsiExjs4Q'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List<Book> fetchedBooks = (data['items'] as List)
          .map((item) => Book.fromJson(item['volumeInfo']))
          .toList();

      setState(() {
        books = fetchedBooks;
      });
    } else {
      throw Exception('Failed to load books');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            controller: searchController,
            decoration: InputDecoration(
              hintText: 'Search for books',
              suffixIcon: IconButton(
                icon: Icon(Icons.search),
                onPressed: () {
                  searchBooks(searchController.text);
                },
              ),
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: books.length,
            itemBuilder: (context, index) {
              final book = books[index];
              return ListTile(
                title: Text(book.title),
                subtitle: Text(book.authors.join(', ')),
                trailing: IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () {
                    widget.onBookAdd(book);
                  },
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BookDetailPage(book: book),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}

class BookDetailPage extends StatelessWidget {
  final Book book;

  BookDetailPage({required this.book});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(book.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              book.title,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'Authors: ${book.authors.join(', ')}',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 10),
            Text(
              'Description: ${book.description}',
              style: TextStyle(fontSize: 14),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Add to to-read list
                Navigator.pop(context, book);
              },
              child: Text('Add to To-Read List'),
            ),
          ],
        ),
      ),
    );
  }
}

class ToReadListPage extends StatelessWidget {
  final List<Book> toReadList;

  ToReadListPage({required this.toReadList});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: toReadList.length,
      itemBuilder: (context, index) {
        final book = toReadList[index];
        return ListTile(
          title: Text(book.title),
          subtitle: Text(book.authors.join(', ')),
        );
      },
    );
  }
}

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: () {
              // Implement logout functionality here
            },
            child: Text('Logout'),
          ),
          ElevatedButton(
            onPressed: () {
              // Navigate to profile page
            },
            child: Text('Profile'),
          ),
          ElevatedButton(
            onPressed: () {
              // Navigate to credits page
            },
            child: Text('Credits'),
          ),
        ],
      ),
    );
  }
}

class Book {
  final String title;
  final List<String> authors;
  final String description;

  Book({required this.title, required this.authors, required this.description});

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      title: json['title'] as String,
      authors: (json['authors'] as List<dynamic>).cast<String>(),
      description: json['description'] as String,
    );
  }
}
*/

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