import 'package:flutter/material.dart';
import 'package:flutter_application_1/Components/color.dart';
import 'package:flutter_application_1/auth.dart';
import 'package:flutter_application_1/Pages/book.dart';
import 'package:flutter_application_1/Pages/details.dart';
import 'package:flutter_application_1/Pages/profile.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_application_1/Pages/firestore_services.dart';
import 'notes.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      //title: 'Discover',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        brightness: Brightness.light,
        colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColor,
        
      ),
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
  String _query = 'world';
  int _currentIndex = 0;
  final PageController _pageController = PageController();

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

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
    _pageController.jumpToPage(index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //title: Text('Discover'),
        //centerTitle: true,
        backgroundColor: primaryColor,
      ),
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        children: [
          buildBookListPage(),
          SavedBooksScreen(),
          BrowseByGenrePage(),
          NotesScreen(),
          SettingsPage(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: onTabTapped,
        selectedItemColor: primaryColor, // Change color of selected icon
        unselectedItemColor: icons, // Change color of unselected icon
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.menu_book),
            label: 'Bookshelf',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.category),
            label: 'Browse By Genre',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notes),
            label: 'Notes',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }

  Widget buildBookListPage() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            controller: _controller,
            decoration: InputDecoration(
              hintText: 'Search books',
              prefixIcon: Icon(Icons.search),
              suffixIcon: IconButton(
                icon: Icon(Icons.clear),
                onPressed: () {
                  _controller.clear();
                },
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(12.0)),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: Colors.grey[200],
              contentPadding:
                  EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
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
                            builder: (context) => BookDetailsScreen(
                              book: book,
                            ),
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
    );
  }
}





class SavedBooksScreen extends StatefulWidget {
  @override
  _SavedBooksScreenState createState() => _SavedBooksScreenState();
}

class _SavedBooksScreenState extends State<SavedBooksScreen> {
  final FirestoreService _firestoreService = FirestoreService();
  List<Book> _savedBooks = [];

  @override
  void initState() {
    super.initState();
    _loadSavedBooks();
  }

  Future<void> _loadSavedBooks() async {
    final books = await _firestoreService.getSavedBooks();
    setState(() {
      _savedBooks = books;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bookshelf'),
        centerTitle: true,
      ),
      body: _savedBooks.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _savedBooks.length,
              itemBuilder: (context, index) {
                final book = _savedBooks[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                  child: Card(
                    elevation: 3,
                    child: ListTile(
                      contentPadding: EdgeInsets.all(8.0),
                      leading: book.imageUrl.isNotEmpty
                          ? Image.network(
                              book.imageUrl,
                              width: 70,
                              height: 100,
                              fit: BoxFit.cover,
                            )
                          : Container(
                              width: 70,
                              height: 100,
                              color: Colors.grey[200],
                              child: Icon(
                                Icons.book,
                                size: 40,
                                color: Colors.grey[400],
                              ),
                            ),
                      title: Text(
                        book.title,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        book.author,
                        style: TextStyle(color: Colors.grey),
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BookDetailsScreen(book: book),
                          ),
                        );
                      },
                    ),
                  ),
                );
              },
            ),
    );
  }
}

class BrowseByGenrePage extends StatefulWidget {
  @override
  _BrowseByGenrePageState createState() => _BrowseByGenrePageState();
}




class _BrowseByGenrePageState extends State<BrowseByGenrePage> {
  String _selectedGenre = "Fiction"; // Default genre
  List<String> _genres = [
    "Fiction",
    "Fantasy",
    "Mystery",
    "Classics",
    "Thrillers",
    "Islamic",
    "Comedy"
  ];

  List<Book> _books = [];

  @override
  void initState() {
    super.initState();
    _fetchBooksByGenre(_selectedGenre);
  }

  Future<void> _fetchBooksByGenre(String genre) async {
    final response = await http.get(
      Uri.parse("https://www.googleapis.com/books/v1/volumes?q=subject:$genre"),
    );

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      setState(() {
        _books = (jsonData['items'] as List)
            .map((itemJson) => Book.fromJson(itemJson))
            .toList();
      });
    } else {
      throw Exception('Failed to load books');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Browse by Genre'),
        centerTitle: true,

      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: DropdownButton<String>(
              value: _selectedGenre,
              onChanged: (newValue) {
                setState(() {
                  _selectedGenre = newValue!;
                });
                _fetchBooksByGenre(newValue!);
              },
              items: _genres.map<DropdownMenuItem<String>>((String genre) {
                return DropdownMenuItem<String>(
                  value: genre,
                  child: Text(genre),
                );
              }).toList(),
            ),
          ),
          Expanded(
            child: ListView.builder(
  itemCount: _books.length,
  itemBuilder: (context, index) {
    Book book = _books[index]; // Define book variable here
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
            builder: (context) => BookDetailsScreen(
              book: book, // Pass the book to the BookDetailsScreen
            ),
          ),
        );
      },
    );
  },
),

          ),
        ],
      ),
    );
  }
}




class NotesScreen extends StatefulWidget {
  @override
  _NotesScreenState createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  final FirestoreService _firestoreService = FirestoreService();
  List<Note> _notes = [];

  @override
  void initState() {
    super.initState();
    _loadNotes();
  }

  Future<void> _loadNotes() async {
    final notes = await _firestoreService.getSavedNotes();
    setState(() {
      _notes = notes;
    });
  }

  Future<void> _addNote() async {
    final TextEditingController titleController = TextEditingController();
    final TextEditingController contentController = TextEditingController();

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add New Note'),
content: SingleChildScrollView(
  child: Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextField(
          controller: titleController,
          decoration: InputDecoration(
            labelText: 'Title',
            border: OutlineInputBorder(),
          ),
        ),
      ),
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextField(
          controller: contentController,
          decoration: InputDecoration(
            labelText: 'Content',
            border: OutlineInputBorder(),
          ),
          maxLines: null,
        ),
      ),
    ],
  ),
),
actions: [
  TextButton(
    onPressed: () {
      Navigator.of(context).pop(); // Close dialog
    },
    child: Text('Cancel'),
  ),
  ElevatedButton(
    onPressed: () async {
      final newNote = Note(
        id: DateTime.now().toIso8601String(), // Unique ID
        title: titleController.text,
        content: contentController.text,
      );
      await _firestoreService.saveNote(newNote);
      _loadNotes();
      Navigator.of(context).pop();
    },
    child: Text('Save'),
  ),
],
        /* title: Text('Add New Note'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: InputDecoration(hintText: 'Title'),
              ),
              SizedBox(height: 10),
              TextField(
                controller: contentController,
                decoration: InputDecoration(hintText: 'Content'),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
              },
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                final newNote = Note(
                  id: DateTime.now().toIso8601String(), // Unique ID
                  title: titleController.text,
                  content: contentController.text,
                );
                await _firestoreService.saveNote(newNote);
                _loadNotes();
                Navigator.of(context).pop();
              },
              child: Text('Save'),
            ),
          ],*/
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notes'),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addNote,
        child: Icon(Icons.add),
      ),
      body: _notes.isEmpty
          ? Center()
          : ListView.builder(
              itemCount: _notes.length,
              itemBuilder: (context, index) {
                final note = _notes[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                  child: Card(
                    elevation: 3,
                    child: ListTile(
                      contentPadding: EdgeInsets.all(8.0),
                      title: Text(
                        note.title,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        note.content,
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}




class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
        centerTitle: true,

      ),
      body: ListView(
        children: <Widget>[
          ListTile(
            leading: Icon(Icons.person),
            title: Text('Profile'),
            onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProfilePage(
            ),
          ),
        );
      },
          ),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text('Sign Out'),
            onTap: () {
              Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => Auth()),
    );
            },
          ),
        ],
      ),
    );
  }
}




