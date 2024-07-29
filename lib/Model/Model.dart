class Book {
  int? id;
  String title;
  String author;
  String imagePath;
  String pdfPath;
  bool isRead;
  double rating;

  Book({
    this.id,
    required this.title,
    required this.author,
    required this.imagePath,
    required this.pdfPath,
    this.isRead = false,
    this.rating = 0.0,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'author': author,
      'imagePath': imagePath,
      'pdfPath': pdfPath,
      'isRead': isRead ? 1 : 0,
      'rating': rating,
    };
  }

  static Book fromMap(Map<String, dynamic> map) {
    return Book(
      id: map['id'],
      title: map['title'],
      author: map['author'],
      imagePath: map['imagePath'],
      pdfPath: map['pdfPath'],
      isRead: map['isRead'] == 1,
      rating: map['rating'],
    );
  }
}
