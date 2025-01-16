import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';

class PdfViewerPage extends StatefulWidget {
  final String filePath;

  const PdfViewerPage({Key? key, required this.filePath}) : super(key: key);

  @override
  _PdfViewerPageState createState() => _PdfViewerPageState();
}

class _PdfViewerPageState extends State<PdfViewerPage> {
  String? localFilePath;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _preparePdf(widget.filePath);
  }

  Future<void> _preparePdf(String url) async {
    try {
      // Get temporary directory
      final tempDir = await getTemporaryDirectory();
      final filePath = '${tempDir.path}/temp.pdf';

      // Download the file
      final dio = Dio();
      await dio.download(url, filePath);

      // Set the local file path
      setState(() {
        localFilePath = filePath;
        isLoading = false;
      });
    } catch (e) {
      print("Error downloading PDF: $e");
      setState(() {
        isLoading = false; // Stop loader on error
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to load PDF: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("PDF Viewer")),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : localFilePath != null
          ? PDFView(
        filePath: localFilePath!,
        enableSwipe: true,
        swipeHorizontal: false,
        autoSpacing: false,
        pageFling: false,
      )
          : const Center(child: Text("Failed to load PDF")),
    );
  }
}
