import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:provider/provider.dart';
import '../Model/Model.dart';
import '../Provider/Book_provider.dart';

class AddEditBookScreen extends StatefulWidget {
  final Book? book;

  AddEditBookScreen({this.book});

  @override
  _AddEditBookScreenState createState() => _AddEditBookScreenState();
}

class _AddEditBookScreenState extends State<AddEditBookScreen> {
  final _formKey = GlobalKey<FormState>();
  late String _title, _author, _imagePath, _pdfPath;
  late bool _isRead;
  late double _rating;

  @override
  void initState() {
    super.initState();
    if (widget.book != null) {
      _title = widget.book!.title;
      _author = widget.book!.author;
      _imagePath = widget.book!.imagePath;
      _pdfPath = widget.book!.pdfPath;
      _isRead = widget.book!.isRead;
      _rating = widget.book!.rating;
    } else {
      _title = '';
      _author = '';
      _imagePath = '';
      _pdfPath = '';
      _isRead = false;
      _rating = 0.0;
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imagePath = pickedFile.path;
      });
    }
  }

  Future<void> _pickPdf() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.custom, allowedExtensions: ['pdf']);
    if (result != null) {
      setState(() {
        _pdfPath = result.files.single.path!;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.book == null ? 'Add Book' : 'Edit Book'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                initialValue: _title,
                decoration: InputDecoration(labelText: 'Title'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the book title';
                  }
                  return null;
                },
                onSaved: (value) {
                  _title = value!;
                },
              ),
              TextFormField(
                initialValue: _author,
                decoration: InputDecoration(labelText: 'Author'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the author name';
                  }
                  return null;
                },
                onSaved: (value) {
                  _author = value!;
                },
              ),
              SizedBox(height: 16.0),
              Row(
                children: [
                  _imagePath.isNotEmpty ? Image.file(File(_imagePath), width: 50, height: 50) : Container(),
                  TextButton(
                    onPressed: _pickImage,
                    child: Text('Pick Image'),
                  ),
                ],
              ),
              Row(
                children: [
                  Text(_pdfPath.isNotEmpty ? 'PDF Selected' : 'No PDF Selected'),
                  TextButton(
                    onPressed: _pickPdf,
                    child: Text('Pick PDF'),
                  ),
                ],
              ),
              CheckboxListTile(
                title: Text('Mark as Read'),
                value: _isRead,
                onChanged: (value) {
                  setState(() {
                    _isRead = value!;
                  });
                },
              ),
              Slider(
                label: 'Rating',
                min: 0,
                max: 5,
                divisions: 5,
                value: _rating,
                onChanged: (value) {
                  setState(() {
                    _rating = value;
                  });
                },
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    final book = Book(
                      id: widget.book?.id,
                      title: _title,
                      author: _author,
                      imagePath: _imagePath,
                      pdfPath: _pdfPath,
                      isRead: _isRead,
                      rating: _rating,
                    );
                    if (widget.book == null) {
                      Provider.of<BookProvider>(context, listen: false).addBook(book);
                    } else {
                      Provider.of<BookProvider>(context, listen: false).updateBook(book);
                    }
                    Navigator.pop(context);
                  }
                },
                child: Text(widget.book == null ? 'Add Book' : 'Update Book'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
