import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Image Viewer',
      home: ImageViewer(),
    );
  }
}

class ImageViewer extends StatefulWidget {
  @override
  _ImageViewerState createState() => _ImageViewerState();
}

class _ImageViewerState extends State<ImageViewer> {
  int _imageId = 1;
  String _imageUrl = '';

  @override
  void initState() {
    super.initState();
    _fetchImage();
  }

  Future<void> _fetchImage() async {
    final response = await http.get(
        Uri.parse('https://jsonplaceholder.typicode.com/photos/$_imageId'));

    if (response.statusCode == 200) {
      final imageJson = jsonDecode(response.body);
      setState(() {
        _imageUrl = imageJson['url'];
      });
    } else {
      throw Exception('Failed to load image');
    }
  }

  void _loadNextImage() {
    setState(() {
      _imageId++;
    });
    _fetchImage();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Image Viewer'),
      ),
      body: Center(
        child: _imageUrl.isEmpty
            ? CircularProgressIndicator()
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Image.network(_imageUrl),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _loadNextImage,
                    child: Text('Load Next Image'),
                  ),
                ],
              ),
      ),
    );
  }
}
