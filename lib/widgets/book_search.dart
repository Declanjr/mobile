import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Provider/Book_provider.dart';
import '../Screens/Details.dart';

class BookSearchDelegate extends SearchDelegate<String> {
  final BookProvider bookProvider;

  BookSearchDelegate(this.bookProvider);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, '');
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return _buildBookList();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return _buildBookList();
  }

  Widget _buildBookList() {
    final books = bookProvider.books.where((book) {
      return book.title.toLowerCase().contains(query.toLowerCase()) ||
          book.author.toLowerCase().contains(query.toLowerCase());
    }).toList();

    return ListView.builder(
      itemCount: books.length,
      itemBuilder: (context, index) {
        final book = books[index];
        return ListTile(
          leading: book.imagePath.isNotEmpty ? Image.file(File(book.imagePath)) : null,
          title: Text(book.title),
          subtitle: Text(book.author),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => BookDetailScreen(book: book),
              ),
            );
          },
        );
      },
    );
  }
}
