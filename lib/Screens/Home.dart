import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Model/Model.dart';
import '../Provider/Book_provider.dart';
import '../Provider/theme.dart';
import '../widgets/book_search.dart';
import 'Add.dart';
import 'Details.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _searchQuery = '';
  String _sortCriteria = 'title';

  void _sortBooks(List<Book> books) {
    books.sort((a, b) {
      if (_sortCriteria == 'title') {
        return a.title.compareTo(b.title);
      } else if (_sortCriteria == 'author') {
        return a.author.compareTo(b.author);
      } else if (_sortCriteria == 'rating') {
        return b.rating.compareTo(a.rating);
      }
      return 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('MyBooks'),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context,
                delegate: BookSearchDelegate(Provider.of<BookProvider>(context, listen: false)),
              );
            },
          ),
          PopupMenuButton<String>(
            onSelected: (String value) {
              setState(() {
                _sortCriteria = value;
              });
            },
            itemBuilder: (BuildContext context) {
              return [
                PopupMenuItem(
                  value: 'title',
                  child: Text('Sort by Title'),
                ),
                PopupMenuItem(
                  value: 'author',
                  child: Text('Sort by Author'),
                ),
                PopupMenuItem(
                  value: 'rating',
                  child: Text('Sort by Rating'),
                ),
              ];
            },
          ),
          IconButton(
            icon: Icon(Icons.brightness_6),
            onPressed: () {
              Provider.of<ThemeProvider>(context, listen: false).toggleTheme();
            },
          ),
        ],
      ),
      body: Consumer<BookProvider>(
        builder: (context, bookProvider, child) {
          final books = bookProvider.books.where((book) {
            return book.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
                book.author.toLowerCase().contains(_searchQuery.toLowerCase());
          }).toList();

          _sortBooks(books);

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
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddEditBookScreen(),
            ),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
