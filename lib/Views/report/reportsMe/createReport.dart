import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import 'package:sqlite_flutter_crud/Authtentication/login.dart';
import 'package:sqlite_flutter_crud/JsonModels/reporte.dart';
import 'package:sqlite_flutter_crud/JsonModels/users.dart';
import 'package:sqlite_flutter_crud/Providers/report_provider.dart';
import 'package:sqlite_flutter_crud/SQLite/sqlite.dart';
import 'package:sqlite_flutter_crud/Views/report/allReports/allReport.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class createReport extends StatefulWidget {
  const createReport({Key? key}) : super(key: key);

  @override
  State<createReport> createState() => _createReportState();
}

class _createReportState extends State<createReport> {
  final TextEditingController _Controllertitle = TextEditingController();
  final TextEditingController _ControllerDescription = TextEditingController();
  String? imageUrl;
  Uint8List? _image;
  bool isVisible = false;
  bool isVisibleConfirm = false;
  bool iscreateReportTrue = false;
  final db = DatabaseHelper();
  final _formKey = GlobalKey<FormState>();
  final storage = new FlutterSecureStorage();
  Future<void> _pickImage(Function(Uint8List?) onImagePicked) async {
    try {
      final pickedFile =
          await ImagePicker().pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        final bytes = await pickedFile.readAsBytes();
        onImagePicked(bytes);
      }
    } catch (error) {
      // Handle error (e.g., print message, show snackbar)
      print("Error picking image: $error");
    }
  }

  Future<http.Response> createReport() async {
    // 1. Retrieve JWT token from secure storage
    final String? token = await storage.read(key: 'jwt');
    if (token == null) {
      throw Exception('Missing JWT token'); // Handle missing token error
    }

    // 2. Construct the request URL
    final Uri url =
        Uri.parse('https://back-1-9ehs.onrender.com/Reporte/create');

    // 3. Prepare the request body
    final Map<String, dynamic> body = {
      "titulo": _Controllertitle.text,
      "descripcion": _ControllerDescription.text,
      "imagen": imageUrl!.replaceAll(
          RegExp(r'"'), ''), // Assuming 'imageUrl' is a valid image URL
      "serpientes_id_serpientes": 12, // Replace with actual value if dynamic
      "usuario_id_usuario": 0, // Replace with actual value if dynamic
    };

    // 4. Set request headers
    final Map<String, String> headers = {
      'Content-Type': 'application/json; charset=utf-8',
      'Authorization': 'Bearer $token', // Include retrieved JWT token
      'accept': 'application/json',
    };

    // 5. Send the POST request
    final http.Response response =
        await http.post(url, headers: headers, body: jsonEncode(body));

    // 6. Handle the response
    if (response.statusCode == 200 || response.statusCode == 201) {
      // Request successful, handle the response data here
      final decodedResponse = jsonDecode(response.body);
      // Process the decoded response depending on your API's structure
      print(decodedResponse); // Example usage
    } else {
      // Request failed, handle the error
      print('Error: ${response.statusCode}');
      print('${response.body}');
      throw Exception('Error creating report'); // Throw a custom exception
    }

    return response;
  }

  Future<void> subirImagen(Uint8List image) async {
    // Crear un multipart file
    var request = http.MultipartRequest(
        'POST', Uri.parse("https://back-1-9ehs.onrender.com/upload_image"));
    var multipartFile = await http.MultipartFile.fromBytes(
      'image', // Nombre del campo en el servidor
      image,
      filename: 'imagen.jpg', // Nombre del archivo en el servidor
    );
    request.files.add(multipartFile);

    // Agregar cualquier otro dato que necesites enviar
    // request.fields['otro_dato'] = 'valor';

    // Enviar la petición
    var response = await request.send();
    if (response.statusCode == 200) {
      // La imagen se subió correctamente

      final responseBody = await response.stream.bytesToString();
      print(
          'Imagen subida exitosamente. Respuesta del servidor: $responseBody');

      imageUrl = responseBody.trim();
    } else {
      // Ocurrió un error
      print('Error al subir la imagen: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    
    final reportProvider = context.watch<Reporte_Provider>();

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  const SizedBox(height: 10), // Espacio desde la parte superior
                  const Center(
                    child: Text(
                      "Publicacion",
                      style: TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    margin: const EdgeInsets.all(8),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Color(0xFFF6F6F6).withOpacity(0.8),
                      border: Border.all(
                          color: Color(0xFFBFBFBF),
                          width: 0.4), // Borde más grueso
                    ),
                    child: TextFormField(
                      controller: _Controllertitle,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "El nombre de usuario es requerido";
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                        icon: Icon(Icons.person),
                        border: InputBorder.none,
                        hintText: "Titulo",
                        hintStyle: TextStyle(
                            color: Color(
                                0xFFBFBFBF)), // Color del icono // Color del texto del hint
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.all(8),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Color(0xFFF6F6F6)
                          .withOpacity(0.8), // Color llamativo para el fondo
                      border: Border.all(
                          color: Color(0xFFBFBFBF),
                          width: 0.4), // Borde más grueso
                    ),
                    child: TextFormField(
                      controller: _ControllerDescription,
                      decoration: InputDecoration(
                        icon: Icon(Icons.description),
                        border: InputBorder.none,
                        hintText: "descripcion",
                        hintStyle: TextStyle(
                            color: Color(
                                0xFFBFBFBF)), // Color del icono // Color del texto del hint
                      ),
                    ),
                  ),
                  _image != null
                      ? Image.memory(_image!)
                      : Text("no hay imagen selecionada"),
                  ElevatedButton(
                    onPressed: () => _pickImage((bytes) {
                      setState(() {
                        _image = bytes;
                      });
                      subirImagen(_image!);
                    }),
                    child: Text('Seleccionar Imagen'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      // Call createReport() only if the provider is available
                      if (reportProvider != null) {
                        createReport();
                        // Assuming fetchData is a method
                      }
                      reportProvider.fecthData = false;

                      Navigator.pop(context,reportProvider.fetchAllReports());
                    },
                    child: Text('Crear Publicación'),
                  ),

                  iscreateReportTrue
                      ? const Text(
                          "El registro no se pudo completar, intente nuevamente",
                          style: TextStyle(color: Colors.red),
                        )
                      : const SizedBox(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
