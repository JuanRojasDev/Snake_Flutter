import 'dart:io';
import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:sqlite_flutter_crud/JsonModels/SnakeReportDefault.dart';
import 'package:sqlite_flutter_crud/Providers/report_provider.dart';
import 'package:path/path.dart' as path;

class CreateReport extends StatefulWidget {
  const CreateReport({
    Key? key,
    this.defaultData,
  }) : super(key: key);

  final SnakeReportDefault? defaultData;

  @override
  State<CreateReport> createState() => _CreateReportState();
}

class _CreateReportState extends State<CreateReport> {
  final TextEditingController _controllerTitle = TextEditingController();
  final TextEditingController _controllerDescription = TextEditingController();
  String? imageUrl;
  Uint8List? _image;
  final _formKey = GlobalKey<FormState>();
  final storage = const FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    if (widget.defaultData != null) {
      _controllerTitle.text = widget.defaultData!.name ?? '';
      _controllerDescription.text = widget.defaultData!.description ?? '';
      _image = widget.defaultData!.image;
      if (_image != null) {
        _uploadImageToFirebase(_image!);
      }
    }
  }

  Future<void> _pickImage() async {
    try {
      final pickedFile =
          await ImagePicker().pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        setState(() {
          _image = File(pickedFile.path).readAsBytesSync();
        });
        _uploadImageToFirebase(_image!);
      }
    } catch (error) {
      print("Error picking image: $error");
    }
  }

  Future<void> _uploadImageToFirebase(Uint8List imageBytes) async {
    try {
      String fileName = path.basename(DateTime.now().toString());
      Reference storageRef =
          FirebaseStorage.instance.ref().child('uploads/$fileName');
      UploadTask uploadTask = storageRef.putData(imageBytes);
      TaskSnapshot taskSnapshot = await uploadTask;
      String downloadUrl = await taskSnapshot.ref.getDownloadURL();

      setState(() {
        imageUrl = downloadUrl;
      });

      print('File uploaded successfully. Download URL: $downloadUrl');
    } catch (e) {
      print('Error uploading image: $e');
    }
  }

  Future<void> _createReport() async {
    final String? token = await storage.read(key: 'jwt');
    final String? userId = await storage.read(key: 'userId');

    if (token == null || userId == null) {
      throw Exception('Falta el token JWT o el ID del usuario');
    }

    final Uri url =
        Uri.parse('https://back-production-0678.up.railway.app/Reporte/create');
    final Map<String, dynamic> body = {
      "titulo": _controllerTitle.text,
      "descripcion": _controllerDescription.text,
      "imagen": imageUrl,
      "serpientes_id_serpientes": 2,
      "usuario_id_usuario": int.parse(userId),
    };

    final Map<String, String> headers = {
      'Content-Type': 'application/json; charset=utf-8',
      'Authorization': 'Bearer $token',
      'accept': 'application/json',
    };

    final http.Response response =
        await http.post(url, headers: headers, body: jsonEncode(body));

    if (response.statusCode == 200 || response.statusCode == 201) {
      final decodedResponse = jsonDecode(response.body);
      print(decodedResponse);
    } else {
      print('Error: ${response.statusCode}');
      print('${response.body}');
      throw Exception('Error creando el reporte');
    }
  }

  @override
  Widget build(BuildContext context) {
    final reportProvider = context.watch<ReportProvider>();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Crear Publicación",
            style: TextStyle(color: Colors.black, fontSize: 24)),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          TextButton(
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                await _createReport();
                reportProvider.fetchData = false;
                Navigator.pop(context, reportProvider.fetchAllReports());
              }
            },
            child: const Text("Publicar",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.bold)),
          ),
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  _buildTextField(_controllerTitle, 'Título', Icons.title),
                  _buildTextField(
                      _controllerDescription, 'Descripción', Icons.description,
                      maxLines: 19),
                  _image != null
                      ? Image.memory(_image!,
                          width: MediaQuery.of(context).size.width)
                      : const Text("No hay imagen seleccionada"),
                  ElevatedButton.icon(
                    onPressed: _pickImage,
                    icon: const Icon(Icons.upload_file),
                    label: const Text('Seleccionar Imagen'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
      TextEditingController controller, String hintText, IconData icon,
      {int maxLines = 1}) {
    return Container(
      margin: const EdgeInsets.all(8),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: const Color(0xFFF6F6F6).withOpacity(0.8),
        border: Border.all(color: const Color(0xFFBFBFBF), width: 0.4),
      ),
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
        validator: (value) {
          if (value!.isEmpty) {
            return "Este campo es requerido";
          }
          return null;
        },
        decoration: InputDecoration(
          icon: Icon(icon),
          border: InputBorder.none,
          hintText: hintText,
          hintStyle: const TextStyle(color: Color(0xFFBFBFBF)),
        ),
      ),
    );
  }
}
