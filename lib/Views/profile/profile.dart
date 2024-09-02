import 'dart:convert';
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:sqlite_flutter_crud/Authtentication/home.dart';
import 'package:sqlite_flutter_crud/Authtentication/login.dart';
import '../../../JsonModels/Usuario.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ProfilePage extends StatefulWidget {
  final Usuario? usuario;

  const ProfilePage({this.usuario, Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  File? _profileImage;
  File? _coverImage;
  String _name = "Nombre";
  String _status = "Descripción";
  String? imageUrl;
  final _nameController = TextEditingController();
  final _statusController = TextEditingController();
  final storage = new FlutterSecureStorage();

  Future<http.Response> editUser() async {
    // 1. Retrieve JWT token from secure storage
    final String? token = await storage.read(key: 'jwt');
    if (token == null) {
      throw Exception('Missing JWT token'); // Handle missing token error
    }

    // 2. Construct the request URL
    final Uri url =
        Uri.parse('https://back-1-9ehs.onrender.com/usuario/edit');

    // 3. Prepare the request body
    final Map<String, dynamic> body = {
        "nombre": widget.usuario?.nombres,
        "imagenurl": imageUrl
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
  

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.usuario?.nombres ?? 'Usuario no disponible';
    _statusController.text = _status;
    imageUrl = widget.usuario?.imagen;
  }

  Future<void> _pickImage(bool isProfileImage) async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        if (isProfileImage) {
          _profileImage = File(pickedFile.path);
        } else {
          _coverImage = File(pickedFile.path);
        }
      });
    }
  }


    Future<File?> _pickImageFile() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null){
      _profileImage = File(pickedFile.path);
      return File(pickedFile.path);
    }
    else{
      return null;
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
      return ("Error uploading image: ${error.code} - ${error.message}");
      // Optionally re-throw the exception for further handling in the calling function
      // throw error;
    } catch (error) {
      // Handle other exceptions (e.g., network errors)
      return ("Unexpected error: $error");
      // Optionally return a default value or handle the error differently
    }

    // You can optionally return a default value here if the upload fails
    // return null;
  }

  void _saveName() {
    setState(() {
      _name = _nameController.text;
    });
  }

  void _saveStatus() {
    setState(() {
      _status = _statusController.text;
    });
  }

  @override
  Widget build(BuildContext context) {
    print(imageUrl);
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                GestureDetector(
                  onTap: () {},
                  child: Container(
                    height: 250,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      image: _coverImage != null
                          ? DecorationImage(
                              image: FileImage(_coverImage!),
                              fit: BoxFit.cover,
                            )
                          : null,
                      color: Color(0xFF5DB074),
                    ),
                    child: _coverImage == null
                        ? Center(
                            child: Icon(Icons.camera_alt,
                                color: Colors.white, size: 50),
                          )
                        : null,
                  ),
                ),
                Positioned(
                  bottom: -50,
                  left: MediaQuery.of(context).size.width / 2 - 88,
                  child: GestureDetector(
                    onTap: () async {
                      await _pickImage(true);

                      imageUrl = await subirImagenFireBase(_profileImage!);

                      await editUser();
                    },
                    child: CircleAvatar(
                      radius: 90, // Ajusta el tamaño del círculo aquí
                      backgroundColor: Colors.white,
                      child: CircleAvatar(
                        radius: 85, // Ajusta el tamaño de la imagen aquí
                        backgroundImage: imageUrl != null
                            ? NetworkImage(imageUrl!)
                            : AssetImage('lib/assets/default_profile.png')
                                as ImageProvider,
                      ),
                    ),
                  ),
                ),
                
              ],
            ),
                              
            SizedBox(height: 55),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                children: [
                  TextField(
                    controller: _nameController,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                    ),
                    onSubmitted: (value) => _saveName(),
                  ),
                  SizedBox(height: 5),
                  TextField(
                    controller: _statusController,
                    textAlign: TextAlign.center,
                    maxLength: 100,
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.black54,
                    ),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                    ),
                    onSubmitted: (value) => _saveStatus(),
                  ),
                  Divider(
                    thickness: 2,
                    color: Colors.grey[300],
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildProfileOption(
                        title: "Publicaciones",
                        icon: Icons.article,
                        onTap: () {
                          // Acción al pulsar "Publicaciones"
                        },
                      ),
                      _buildProfileOption(
                        title: "Fotos",
                        icon: Icons.photo_library,
                        onTap: () {
                          // Acción al pulsar "Fotos"
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileOption({
    required String title,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Icon(icon, size: 30, color: Colors.green[700]),
          SizedBox(height: 5),
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}
