import 'package:flutter/material.dart';
import '../Model/Model.dart';
import 'database.dart';

class BookProvider with ChangeNotifier {
  List<Book> _books = [];
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  List<Book> get books => _books;

  Future<void> fetchBooks() async {
    _books = await _databaseHelper.getBooks();
    notifyListeners();
  }

  Future<void> addBook(Book book) async {
    await _databaseHelper.insertBook(book);
    await fetchBooks();
  }

  Future<void> updateBook(Book book) async {
    await _databaseHelper.updateBook(book);
    await fetchBooks();
  }

  Future<void> deleteBook(int id) async {
    await _databaseHelper.deleteBook(id);
    await fetchBooks();
  }
}
