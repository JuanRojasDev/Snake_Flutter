import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sqlite_flutter_crud/Authtentication/home.dart';
import 'dart:typed_data';
import '../../../JsonModels/Usuario.dart';

class ReportPage extends StatefulWidget {
  final Usuario? usuario;

  ReportPage({this.usuario});

  @override
  _ReportPageState createState() => _ReportPageState();
}

class Report extends ChangeNotifier {
  String title;
  String description;
  Uint8List? imageBytes;

  Report({
    required this.title,
    required this.description,
    this.imageBytes,
  });

    Future<void> _pickImage(Function(Uint8List?) onImagePicked) async {
    try {
      final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        final bytes = await pickedFile.readAsBytes();
        onImagePicked(bytes);
      }
    } catch (error) {
      // Handle error (e.g., print message, show snackbar)
      print("Error picking image: $error");
    }
  }

}

class _ReportPageState extends State<ReportPage> {
  List<Report> _reports = [];

  Future<void> _pickImage(Function(Uint8List?) onImagePicked) async {
    try {
      final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        final bytes = await pickedFile.readAsBytes();
        onImagePicked(bytes);
      }
    } catch (error) {
      // Handle error (e.g., print message, show snackbar)
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
      backgroundColor: Colors.white,

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
            margin: EdgeInsets.all(10),
            color: Color(0xFFFAF3E0), // Color blanco hueso
            child: Padding(
              padding: EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    report.title,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 10),
                  report.imageBytes != null
                      ? Image.memory(
                          report.imageBytes!,
                          height: 150,
                        )
                      : Text('No hay imagen seleccionada.'),
                  SizedBox(height: 10),
                  Text(
                    report.description,
                    style: TextStyle(
                      fontSize: 16,
                      fontStyle: FontStyle.italic,
                      color: Colors.grey,
                    ),
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () {
                          
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
      )
    );
  }
}
