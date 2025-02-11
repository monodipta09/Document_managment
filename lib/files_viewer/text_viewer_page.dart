import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:dio/dio.dart';

class TextFileViewerPage extends StatefulWidget {
  final String filePath;

  final String fileName;

  const TextFileViewerPage({Key? key, required this.filePath, required this.fileName}) : super(key: key);

  @override
  _TextFileViewerPageState createState() => _TextFileViewerPageState();
}

class _TextFileViewerPageState extends State<TextFileViewerPage> {
  String? localFilePath;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _downloadAndSaveFile(widget.filePath);
    if (widget.filePath.contains('http') || widget.filePath.contains('https')) {
      _downloadAndSaveFile(widget.filePath);
    } else {
      // Handle local mobile file path
      setState(() {
        localFilePath = widget.filePath;
        isLoading = false;
      });
    }
  }

  Future<void> _downloadAndSaveFile(String url) async {
    setState(() {
      localFilePath = null;
      isLoading = true;
    });

    try {
      // Get temporary directory
      final tempDir = await getTemporaryDirectory();
      final fileName = 'temp_text_${DateTime.now().millisecondsSinceEpoch}.txt'; // Unique file name
      final filePath = '${tempDir.path}/$fileName';

      // Download the file
      final dio = Dio();
      await dio.download(url, filePath);

      setState(() {
        localFilePath = filePath;
        isLoading = false;
      });
    } catch (e) {
      print("Error downloading file: $e");
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to load file: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.fileName)),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : localFilePath != null
          ? FutureBuilder<String>(
        future: File(localFilePath!).readAsString(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text("Failed to open file"));
          }
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              child: Text(snapshot.data ?? ""),
            ),
          );
        },
      )
          : const Center(child: Text("Failed to load file")),
    );
  }
}

