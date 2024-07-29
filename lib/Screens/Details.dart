import 'package:declan/Screens/pdf_viewer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:io';
import '../Model/Model.dart';
import '../Provider/Book_provider.dart';
import 'Add.dart';


class BookDetailScreen extends StatelessWidget {
  final Book book;

  BookDetailScreen({required this.book});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(book.title),
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddEditBookScreen(book: book),
                ),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              Provider.of<BookProvider>(context, listen: false).deleteBook(book.id!);
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            book.imagePath.isNotEmpty ? Image.file(File(book.imagePath)) : Container(),
            SizedBox(height: 8.0),
            Text('Title: ${book.title}', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            Text('Author: ${book.author}', style: TextStyle(fontSize: 16)),
            Text('Rating: ${book.rating}', style: TextStyle(fontSize: 16)),
            SizedBox(height: 8.0),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PDFViewerScreen(pdfPath: book.pdfPath),
                  ),
                );
              },
              child: Text('Open Book'),
            ),
          ],
        ),
      ),
    );
  }
}
