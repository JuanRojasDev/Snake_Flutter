import 'dart:io';
import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:provider/provider.dart';
import 'package:sqlite_flutter_crud/Authtentication/home.dart';
import 'dart:convert';
import 'package:sqlite_flutter_crud/Authtentication/login.dart';
import 'package:sqlite_flutter_crud/JsonModels/SnakeReportDefault.dart';
import 'package:sqlite_flutter_crud/JsonModels/reporte.dart';
import 'package:sqlite_flutter_crud/JsonModels/users.dart';
import 'package:sqlite_flutter_crud/Providers/Home_Body_provider.dart';
import 'package:sqlite_flutter_crud/Providers/report_provider.dart';
import 'package:sqlite_flutter_crud/SQLite/sqlite.dart';
import 'package:sqlite_flutter_crud/Views/report/Reports_List_view/allReport.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:path/path.dart' as path;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:sqlite_flutter_crud/Views/report/reportsMe/createReport.dart';

class PageIdentification extends StatefulWidget {
  const PageIdentification({Key? key}) : super(key: key);

  @override
  State<PageIdentification> createState() => _PageIdentificationState();
}

class _PageIdentificationState extends State<PageIdentification> {
  Uint8List? _image;
  String respuesta = "";
  bool isVisibleConfirm = false;
  final _formKey = GlobalKey<FormState>();
  final storage = FlutterSecureStorage();
  late SnakeReportDefault dataDefault;

  Future<void> _pickImage(ImageSource source) async {
    try {
      final pickedFile = await ImagePicker().pickImage(source: source);
      if (pickedFile != null) {
        final bytes = await pickedFile.readAsBytes();
        setState(() {
          _image = bytes;
        });
        await subirImagen(bytes);
      }
    } catch (error) {
      print("Error picking image: $error");
    }
  }

  Future<void> subirImagen(Uint8List image) async {
    setState(() {
      isVisibleConfirm = true;
    });

    var request = http.MultipartRequest('POST',
        Uri.parse("https://back-production-0678.up.railway.app/snakeidentify"));
    var multipartFile = await http.MultipartFile.fromBytes(
      'image',
      image,
      filename: 'imagen.jpg',
    );
    request.files.add(multipartFile);
    try{
    var response = await request.send();
    print("esttus"+response.statusCode.toString());

    if (response.statusCode == 200 ) {
      final responseBody = await response.stream.bytesToString();
      final decodedResponse = jsonDecode(responseBody);
      setState(() {
        dataDefault = SnakeReportDefault.fromJson(decodedResponse);
        dataDefault.image = image;
        print("Default" + dataDefault.issnake.toString());
        if (dataDefault.name == null) {
          print("esto es null");
        }
        if(dataDefault.issnake){
          respuesta = 'Nombre: ${dataDefault.name}, Descripción: ${dataDefault.description}, Es Venenosa: ${dataDefault.venomous! ? 'sí' : 'no'}';
        }
        else{
          respuesta = 'Error No se identifica una serpiente en la imagen';
        }
        isVisibleConfirm = false;
      });
    } else {
        dataDefault = SnakeReportDefault(issnake: false);
        print('Error al subir la imagen: ${response.statusCode}');
        setState(() {
          respuesta = 'Error al identificar imagen Se recomienda imagenes con una resolucion minima de 900x900 Codigo:${response.statusCode} ';
        isVisibleConfirm = false;
      });
    }
    }
    catch (error) {
    print("Error uploading image: $error");
    setState(() {
      dataDefault = SnakeReportDefault(issnake: false);
      respuesta = 'Error al subir la imagen. Intente nuevamente.';
      isVisibleConfirm = false;
    });
  }
  }

  @override
  Widget build(BuildContext context) {
    final body_Provider = context.watch<Home_Body_Provider>();
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: _image != null
                        ? Image.memory(
                            _image!,
                            height: 250,
                            fit: BoxFit.cover,
                          )
                        : Image.network(
                            "https://www.todofondos.net/wp-content/uploads/2920x1642-Fondo-de-pantalla-negro-scaled.jpg",
                            height: 250,
                            fit: BoxFit.cover,
                          ),
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton.icon(
                      icon: Icon(Icons.photo_library),
                      label: Text('Galería',
                          style: TextStyle(color: Colors.black)),
                      onPressed: () => _pickImage(ImageSource.gallery),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(13),
                        ),
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      ),
                    ),
                    ElevatedButton.icon(
                      icon: Icon(Icons.camera_alt),
                      label:
                          Text('Cámara', style: TextStyle(color: Colors.black)),
                      onPressed: () => _pickImage(ImageSource.camera),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(13),
                        ),
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                if (_image == null)
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        "Envíe una imagen de una serpiente para ver qué especie es y si es venenosa (Estos valores no están comprobados por un experto)",
                        style: TextStyle(fontSize: 16),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                SizedBox(height: 20),
                if (isVisibleConfirm)
                  Center(
                    child: LoadingIndicator(
                      indicatorType: Indicator.ballRotateChase,
                      colors: [
                        Colors.green,
                        const Color.fromARGB(255, 115, 214, 118),
                        const Color.fromARGB(255, 130, 233, 134)
                      ],
                      strokeWidth: BorderSide.strokeAlignCenter,
                    ),
                  )
                else if (respuesta.isNotEmpty)
                  Column(
                    children: [
                      Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text(
                            respuesta,
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      dataDefault.issnake
                          ? ElevatedButton.icon(
                              icon: Icon(Icons.photo_library),
                              label: Text('Publicar',
                                  style: TextStyle(color: Colors.black)),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => Scaffold(
                                      body: createReport(
                                        defaultData: dataDefault,
                                      ),
                                    ),
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(13),
                                ),
                                padding: EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 10),
                              ),
                            )
                          : Text("La Imagen no es una serpiente"),
                    ],
                  )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
