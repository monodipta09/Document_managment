import 'dart:io';

import 'package:document_management_main/data/create_fileStructure.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class DetailsActivity extends StatelessWidget {
  final FileItemNew item;
  const DetailsActivity({super.key, required this.item});

  // final fileSize = File(item.filePath!).lengthSync();
    Future<int> _getFileSize(String url) async {
    final response = await http.head(Uri.parse(url));
    if (response.headers.containsKey('content-length')) {
      return int.parse(response.headers['content-length']!);
    }
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    final isLight = Theme.of(context).brightness == Brightness.light;
    void calculateFolderSize(){

    }

    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.5, // 40% of screen height
      minChildSize: 0.2, // Minimum size
      maxChildSize: 0.8, // Maximum size
      builder: (context, scrollController) {
        return Theme(
          data: Theme.of(context), // Use the current theme
          child: SingleChildScrollView(
          controller: scrollController,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("File Details",
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: isLight ? Colors.black : Colors.white)),
                const SizedBox(height: 10),
                ListTile(
                  leading: const Icon(Icons.insert_drive_file),
                  title: Text(item.name),
                  subtitle:  item.isFolder
                      ? const Text("")
                      : FutureBuilder<int>(
                          future: _getFileSize(item.filePath!),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return const Text("Calculating size...");
                            } else if (snapshot.hasError) {
                              return const Text("Error calculating size");
                            } else {
                              final sizeInBytes = snapshot.data!;
                              final sizeInKB = sizeInBytes / 1024;
                              final sizeInMB = sizeInKB / 1024;
                              return Text(
                                sizeInMB >= 1
                                    ? "${sizeInMB.toStringAsFixed(2)} MB"
                                    : "${sizeInKB.toStringAsFixed(2)} KB",
                              );
                            }
                          },
                        ),
                ),
                ListTile(
                  leading: const Icon(Icons.date_range),
                  title: const Text("Modified"),
                  subtitle: Text(DateFormat("dd/MM/yy hh:mm").format(
                      DateTime.parse(item.otherDetails['updatedOn']),
                    ),),
                ),
                const Divider(),
                Text("Activity",
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: isLight ? Colors.black : Colors.white)),
                ListTile(
                  leading: const Icon(Icons.edit),
                  title: Text("Edited by ${userIdUserDetailsMap[item.otherDetails['updatedBy']]["USER_NAME"]}"),
                  subtitle: Text(DateFormat("dd/MM/yy hh:mm").format(
                      DateTime.parse(item.otherDetails['updatedOn']),
                    )),
                ),
                ListTile(
                  leading: const Icon(Icons.share),
                  title: Text("Created by ${userIdUserDetailsMap[item.otherDetails['createdBy']]["USER_NAME"]}"),
                  subtitle: Text(DateFormat("dd/MM/yy hh:mm").format(
                      DateTime.parse(item.otherDetails['createdOn']),
                    ),),
                ),
              ],
            ),
          ),
        ),);
      },
    );
  }
}
