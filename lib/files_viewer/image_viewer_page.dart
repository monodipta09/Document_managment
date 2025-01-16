import 'dart:io';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';

class ImageViewerPage extends StatefulWidget {
  final String imagePath;

  const ImageViewerPage({Key? key, required this.imagePath}) : super(key: key);

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
    try {
      // Get temporary directory
      final tempDir = await getTemporaryDirectory();
      final filePath = '${tempDir.path}/temp_image.png'; // Change extension if needed

      // Download the image
      final dio = Dio();
      await dio.download(url, filePath);

      // Set the local image path
      setState(() {
        localImagePath = filePath;
        isLoading = false;
      });
    } catch (e) {
      print("Error downloading image: $e");
      setState(() {
        isLoading = false; // Stop loader on error
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to load image: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Image Viewer")),
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
