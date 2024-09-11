import 'dart:io';
import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
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
import 'package:path/path.dart' as path;
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

class pageidentification extends StatefulWidget {
  const pageidentification({Key? key}) : super(key: key);

  @override
  State<pageidentification> createState() => _pageidentification();
}

class _pageidentification extends State<pageidentification> {
  String? imageUrl;
  Uint8List? _image;
  File? imageFile;
  String respuesta = "";
  bool isVisible = false;
  bool isVisibleConfirm = false;
  bool iscreateReportTrue = false;
  final db = DatabaseHelper();
  final _formKey = GlobalKey<FormState>();
  final storage = new FlutterSecureStorage();

  Future<void> _pickFiles() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'png'],
      allowMultiple: false,
    );

    if (result != null) {
      PlatformFile file = result.files.first;
      print(file.name);
      print(file.path);
    } else {
      print('No file selected');
    }
  }

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




  Future<String> subirImagenFireBase(File image) async {
    // Create a reference to the specific bucket
    final storage =
        FirebaseStorage.instanceFor(bucket: 'meta-snake.appspot.com');

    // Create a reference to the node where the image will be stored
    final storageRef = storage
        .ref()
        .child('images/${DateTime.now().millisecondsSinceEpoch}.jpg');

    // Upload the image data (in Uint8List format) to Firebase Storage
    final uploadTask = storageRef.putFile(image);

    try {
      // Wait for the image upload to complete
      await uploadTask.whenComplete(() {});
      final snapshot = await uploadTask.whenComplete(() {});
      // Get the download URL of the uploaded image
      final downloadUrl = await snapshot.ref.getDownloadURL();

      // Print the download URL to the console
      print('Imagen subida correctamente: $downloadUrl');

      // Return the download URL
      return downloadUrl;
    } on FirebaseException catch (error) {
      // Handle FirebaseException error
      return("Error uploading image: ${error.code} - ${error.message}");
      // Optionally re-throw the exception for further handling in the calling function
      // throw error;
    } catch (error) {
      // Handle other exceptions (e.g., network errors)
      return("Unexpected error: $error");
      // Optionally return a default value or handle the error differently
    }

    // You can optionally return a default value here if the upload fails
    // return null;
  }

  Future<void> subirImagen(Uint8List image) async {
    isVisibleConfirm = true;
    // Crear un multipart file
    var request = http.MultipartRequest(
        'POST', Uri.parse("https://back-1-9ehs.onrender.com/snakeidentify"));
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

    setState(() {
      respuesta = responseBody.trim();
      isVisibleConfirm = false;
    });
      
    } else {
      // Ocurrió un error
      print('Error al subir la imagen: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {

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
                  _image != null
                ? Image.memory(
                      _image!,
                      width: double.infinity, // Ensures equal width for both images
                      height: 200.0, // Adjust height as needed
                    )
                : Image.network(
                      "https://i.ytimg.com/vi/BIlfrjfF718/maxresdefault.jpg",
                      width: double.infinity, // Ensures equal width for both images
                      height: 200.0, // Adjust height as needed
                    ),
                    SizedBox(height: 20,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                                        ElevatedButton(
                    onPressed: () async {
                      try {
                        // Pick an image from the gallery
                        final pickedFile = await ImagePicker()
                            .pickImage(source: ImageSource.gallery);

                        if (pickedFile != null) {
                          // Read the image data into a Uint8List
                          final bytes = await pickedFile.readAsBytes();
                          setState(() {
                            _image = bytes;
                          });
                          // Call the function to upload the image to Firebase Storage
                          File file = File(pickedFile.path);
    
                            print('$file');
                          
                             await subirImagen(bytes);
                          
                          // Do something with the uploaded image URL (e.g., display it)
                          print(
                              'Imagen subida correctamente: $respuesta'); // Optional: print success message
                        } else {
                          // Handle user cancellation or error
                          print('No image selected.'); // Optional: inform user
                        }
                      } catch (error) {
                        // Handle any errors that might occur during image picking or upload
                        print("Error picking or uploading image: $error");
                      }
                    },
                    child: Text('Seleccionar Imagen'),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      try {
                        // Pick an image from the gallery
                        final pickedFile = await ImagePicker()
                            .pickImage(source: ImageSource.camera);

                        if (pickedFile != null) {
                          // Read the image data into a Uint8List
                          final bytes = await pickedFile.readAsBytes();
                          setState(() {
                            _image = bytes;
                          });
                          // Call the function to upload the image to Firebase Storage
                          File file = File(pickedFile.path);
    
                            print('$file');
                          
                           await subirImagen(bytes);
                            
                          // Do something with the uploaded image URL (e.g., display it)
                          print(
                              'Imagen subida correctamente: $imageUrl'); // Optional: print success message
                        } else {
                          // Handle user cancellation or error
                          print('No image selected.'); // Optional: inform user
                        }
                      } catch (error) {
                        // Handle any errors that might occur during image picking or upload
                        print("Error picking or uploading image: $error");
                      }
                    },
                    child: Text('Tomar Foto'),
                  ),
                    ],
                  ),
                  SizedBox(height: 20,),
                  _image != null
                  ?SizedBox()
                  :Text("Envie una imagen de una serpiente para ver que especie es y si esta es venenosa (Estos valores no estan comprobados por un expert)"),
                  
                  isVisibleConfirm == true
                  ?LoadingIndicator(indicatorType: Indicator.ballRotate)
                  :Text(respuesta),


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
