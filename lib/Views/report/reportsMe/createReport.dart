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
import 'package:sqlite_flutter_crud/JsonModels/SnakeReportDefault.dart';
import 'package:sqlite_flutter_crud/JsonModels/reporte.dart';
import 'package:sqlite_flutter_crud/JsonModels/users.dart';
import 'package:sqlite_flutter_crud/Providers/report_provider.dart';
import 'package:sqlite_flutter_crud/SQLite/sqlite.dart';
import 'package:sqlite_flutter_crud/Views/report/Reports_List_view/allReport.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:path/path.dart' as path;
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

class createReport extends StatefulWidget {
  const createReport({
    Key? key,
    this.defaultData,
  }) : super(key: key);

  final SnakeReportDefault? defaultData;

  @override
  State<createReport> createState() => _createReportState();
}

class _createReportState extends State<createReport> {
  final TextEditingController _Controllertitle = TextEditingController();
  final TextEditingController _ControllerDescription = TextEditingController();
  String? imageUrl;
  Uint8List? _image;
  File? imageFile;
  bool isVisible = false;
  bool isVisibleConfirm = false;
  bool iscreateReportTrue = false;
  final db = DatabaseHelper();
  final _formKey = GlobalKey<FormState>();
  final storage = new FlutterSecureStorage();

  @protected
  @mustCallSuper
  void initState() {
    if (!(widget.defaultData == null)){
      _Controllertitle.text = widget.defaultData!.name!;
      _ControllerDescription.text = widget.defaultData!.description!;
      _image = widget.defaultData!.image;
      subirImagenFireBaseData(_image!);
    }
  }

  Future<void> _pickFiles() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'png', 'pdf'],
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


  Future<http.Response> createReport() async {
    // 1. Retrieve JWT token from secure storage
    final String? token = await storage.read(key: 'jwt');
    if (token == null) {
      throw Exception('Missing JWT token'); // Handle missing token error
    }

    // 2. Construct the request URL
    final Uri url =
        Uri.parse('https://back-production-0678.up.railway.app/Reporte/create');

    print(imageUrl);
    // 3. Prepare the request body
    final Map<String, dynamic> body = {
      "titulo": _Controllertitle.text,
      "descripcion": _ControllerDescription.text,
      "imagen": imageUrl,
      "serpientes_id_serpientes": 2,
      // Replace with actual value if dynamic
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

  Future<String> subirImagenFireBaseData(Uint8List image) async {
    // Create a reference to the specific bucket
    final storage =
        FirebaseStorage.instanceFor(bucket: 'meta-snake.appspot.com');

    // Create a reference to the node where the image will be stored
    final storageRef = storage
        .ref()
        .child('images/${DateTime.now().millisecondsSinceEpoch}.jpg');

    // Upload the image data (in Uint8List format) to Firebase Storage
    final uploadTask = storageRef.putData(image);

    try {
      // Wait for the image upload to complete
      await uploadTask.whenComplete(() {});
      final snapshot = await uploadTask.whenComplete(() {});
      // Get the download URL of the uploaded image
      final downloadUrl = await snapshot.ref.getDownloadURL();

      // Print the download URL to the console
      print('Imagen subida correctamente: $downloadUrl');

      // Return the download URL
      imageUrl= downloadUrl;
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
    // Crear un multipart file
    var request = http.MultipartRequest(
        'POST', Uri.parse("https://back-production-0678.up.railway.app/upload_image"));
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
    final reportProvider = context.watch<ReportProvider>();

    return Scaffold(
      backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text(
              "Crear Publicacion", // Actualiza el título según el icono seleccionado
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 24)),
          backgroundColor: Colors.white,
          elevation: 0,
          actions: [
            TextButton(
                    onPressed: () async{

                       await createReport();

                       reportProvider.fetchData = false;

                       Navigator.pop(context, reportProvider.fetchAllReports());
                    }
                    , 
            child: Text("PUBLICAR",
            style: TextStyle(
                  color: Color.fromARGB(255, 0, 0, 0),
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                )
                  )
            ),
            
          ],),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
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
                    height: 500,
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
                      maxLines: 19,
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
                      ? Image.memory(_image! ,width: MediaQuery.of(context).size.width,)
                      : Text("no hay imagen selecionada"),
                  Container(
                                        margin: const EdgeInsets.all(8),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Color(0xFFF6F6F6)
                          .withOpacity(0.8), // Color llamativo para el fondo
                      border: Border.all(
                          color: Color(0xFFBFBFBF),
                          width: 0.4), // Borde más grueso
                    ),
                    
                    child: ElevatedButton.icon(
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
                            
                             imageUrl = await subirImagenFireBase(file);
                            
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
                        icon: Icon(Icons.photo_library),
                        label: Text('Galería',style: TextStyle(  color: Colors.black)),
                          style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        ),
                    ),
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
