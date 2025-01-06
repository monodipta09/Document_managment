import 'dart:io';
import 'package:flutter/material.dart';

class TextFileViewerPage extends StatelessWidget {
  final String filePath;

  const TextFileViewerPage({Key? key, required this.filePath}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: File(filePath).readAsString(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            appBar: AppBar(title: const Text("Text Viewer")),
            body: const Center(child: CircularProgressIndicator()),
          );
        } else if (snapshot.hasError) {
          return Scaffold(
            appBar: AppBar(title: const Text("Error")),
            body: const Center(child: Text("Failed to open file")),
          );
        }
        return Scaffold(
          appBar: AppBar(title: const Text("Text Viewer")),
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              child: Text(snapshot.data ?? ""),
            ),
          ),
        );
      },
    );
  }
}
