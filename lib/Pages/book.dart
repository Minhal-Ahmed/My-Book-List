class Book {
  final String id;
  final String title;
  final String author;
  final String imageUrl;

  Book({
    required this.id,
    required this.title,
    required this.author,
    required this.imageUrl,
  });

//here
factory Book.fromMap(Map<String, dynamic> map) {
    return Book(
      id: map['id'],
      title: map['title'],
      author: map['author'],
      imageUrl: map['imageUrl'] ?? '',
    );
  }

  factory Book.fromJson(Map<String, dynamic> json) {
    var volumeInfo = json['volumeInfo'];
    return Book(
      id: json['id'],
      title: volumeInfo['title'],
      author: volumeInfo['authors'] != null ? volumeInfo['authors'][0] : 'Unknown',
      imageUrl: volumeInfo['imageLinks'] != null ? volumeInfo['imageLinks']['thumbnail'] : '',
    );
  }

//here
Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'author': author,
      'imageUrl': imageUrl,
    };
}

}