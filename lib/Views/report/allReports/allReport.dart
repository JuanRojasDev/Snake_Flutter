import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:sqlite_flutter_crud/JsonModels/Usuario.dart';

class ReportPage extends StatefulWidget {
  final Usuario? usuario;

  ReportPage({this.usuario});

  @override
  _ReportPageState createState() => _ReportPageState();
}

class Report {
  final String title;
  final String description;
  final Uint8List? imageBytes;
  final String userProfileImage;
  final String userName;

  Report({
    required this.title,
    required this.description,
    this.imageBytes,
    required this.userProfileImage,
    required this.userName,
  });
}

class _ReportPageState extends State<ReportPage> {
  List<Report> _reports = [];

  Future<void> _pickImage(Function(Uint8List?) onImagePicked) async {
    try {
      final pickedFile =
          await ImagePicker().pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        final bytes = await pickedFile.readAsBytes();
        onImagePicked(bytes);
      }
    } catch (error) {
      print("Error picking image: $error");
    }
  }

  void _deleteReport(int index) {
    setState(() {
      _reports.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            builder: (BuildContext context) {
              return Container(
                height: 100,
                child: Column(
                  children: [
                    ListTile(
                      leading: Icon(Icons.note_add),
                      title: Text('Escribir Reporte'),
                      onTap: () {
                        Navigator.of(context).pop();
                        // Implement the action to create a new report
                      },
                    ),
                  ],
                ),
              );
            },
          );
        },
        child: Icon(Icons.add),
        backgroundColor: Color(0xFF5DB075),
      ),
      body: ListView.builder(
        itemCount: _reports.length,
        itemBuilder: (context, index) {
          final report = _reports[index];
          return Card(
            margin: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
            elevation: 3,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        backgroundImage: CachedNetworkImageProvider(
                          report.userProfileImage,
                        ),
                        radius: 25,
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              report.userName,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'Posted 2 hours ago', // Replace with actual timestamp if available
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12),
                  Text(
                    report.title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  report.imageBytes != null
                      ? Image.memory(
                          report.imageBytes!,
                          height: 150,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        )
                      : SizedBox.shrink(),
                  SizedBox(height: 10),
                  Text(
                    report.description,
                    style: TextStyle(
                      fontSize: 14,
                      fontStyle: FontStyle.italic,
                      color: Colors.grey[700],
                    ),
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit, color: Colors.blue),
                        onPressed: () {
                          // Implement edit functionality
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          _deleteReport(index);
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
