import 'dart:io';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';

class ImageViewerPage extends StatefulWidget {
  final String imagePath;

  final String fileName;

  const ImageViewerPage({Key? key, required this.imagePath, required this.fileName}) : super(key: key);

  @override
  _ImageViewerPageState createState() => _ImageViewerPageState();
}

class _ImageViewerPageState extends State<ImageViewerPage> {
  String? localImagePath;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _downloadAndSaveImage(widget.imagePath);
  }

  Future<void> _downloadAndSaveImage(String url) async {
    setState(() {
      localImagePath = null;
      isLoading = true;
    });

    try {
      final tempDir = await getTemporaryDirectory();
      final fileName = 'temp_image_${DateTime.now().millisecondsSinceEpoch}.png'; // Unique file name
      final filePath = '${tempDir.path}/$fileName';

      final dio = Dio();
      await dio.download(url, filePath);

      setState(() {
        localImagePath = filePath;
        isLoading = false;
      });
    } catch (e) {
      print("Error downloading image: $e");
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to load image: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.fileName)),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : localImagePath != null
          ? Center(
        child: Image.file(
          File(localImagePath!),
        ),
      )
          : const Center(child: Text("Failed to load image")),
    );
  }
}

