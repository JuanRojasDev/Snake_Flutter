import 'dart:convert';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:sqlite_flutter_crud/Authtentication/home.dart';
import 'package:sqlite_flutter_crud/Authtentication/login.dart';
import 'package:sqlite_flutter_crud/Providers/Home_Body_provider.dart';
import 'package:sqlite_flutter_crud/Providers/usuer_provider.dart';
import '../../../JsonModels/Usuario.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool showPosts = true;

  File? _profileImage;
  File? _coverImage;
  String _name = "";
  String _status = "Descripción";
  String? imageUrl = "";
  final _nameController = TextEditingController();
  final _statusController = TextEditingController();
  final storage = FlutterSecureStorage();

  Future<http.Response> editUser() async {
    final String? token = await storage.read(key: 'jwt');
    if (token == null) {
      throw Exception('Missing JWT token');
    }

    final Uri url = Uri.parse('https://back-1-9ehs.onrender.com/usuario/edit');
    final Map<String, dynamic> body = {"nombre": _name, "imagenurl": imageUrl};
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
      throw Exception('Error creating report');
    }

    return response;
  }

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
      });
    }
  }

  Future<File?> _pickImageFile() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      _profileImage = File(pickedFile.path);
      return File(pickedFile.path);
    } else {
      return null;
    }
  }

  Future<String> subirImagenFireBase(File image) async {
    final storage =
        FirebaseStorage.instanceFor(bucket: 'meta-snake.appspot.com');

    final storageRef = storage
        .ref()
        .child('images/${DateTime.now().millisecondsSinceEpoch}.jpg');

    final uploadTask = storageRef.putFile(image);

    try {
      await uploadTask.whenComplete(() {});
      final snapshot = await uploadTask.whenComplete(() {});
      final downloadUrl = await snapshot.ref.getDownloadURL();
      print('Imagen subida correctamente: $downloadUrl');
      return downloadUrl;
    } on FirebaseException catch (error) {
      return ("Error uploading image: ${error.code} - ${error.message}");
    } catch (error) {
      return ("Unexpected error: $error");
    }
  }

  void _saveImageUrl(String url) {
    setState(() {
      imageUrl = url;
    });
  }

  void _saveName() async {
    setState(() {
      _name = _nameController.text;
    });
    await editUser();
  }

  void _saveStatus() {
    setState(() {
      _status = _statusController.text;
    });
  }

  @override
  Widget build(BuildContext context) {
    print(imageUrl);

    final user_provider = context.watch<UserProvider>();
    _nameController.text = user_provider.usernow.nombres;
    imageUrl = user_provider.usernow.imagen;

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
                      await _pickImage();

                      imageUrl = await subirImagenFireBase(_profileImage!);

                      await editUser();

                      _saveImageUrl(imageUrl!);

                      user_provider.setImage(imageUrl!);
                    },
                    child: CircleAvatar(
                      radius: 90,
                      backgroundColor: Colors.white,
                      child: CircleAvatar(
                        radius: 85,
                        backgroundImage: user_provider.usernow.imagen != null
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
                    onSubmitted: (value) =>
                        {_saveName(), user_provider.setUserName(_name)},
                  ),
                ],
              ),
            ),
            SizedBox(height: 80.0),
            Text(
              _name,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            Text(
              _status,
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey[700],
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildTabOption("Publicaciones", showPosts, () {
                    setState(() {
                      showPosts = true;
                    });
                  }),
                  SizedBox(width: 10),
                  _buildTabOption("Fotos", !showPosts, () {
                    setState(() {
                      showPosts = false;
                    });
                  }),
                ],
              ),
            ),
            Divider(thickness: 2, color: Colors.grey[300]),
            showPosts ? _buildPosts() : _buildPhotos(),
          ],
        ),
      ),
    );
  }

  Widget _buildTabOption(String title, bool isActive, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: isActive ? Color(0xFF5DB074) : Colors.grey,
            ),
          ),
          if (isActive)
            Container(
              margin: EdgeInsets.only(top: 4),
              height: 2,
              width: 100,
              color: Color(0xFF5DB074),
            ),
        ],
      ),
    );
  }

  Widget _buildPosts() {
    return Column(
      children: [
        _buildPostItem(
          "Serpiente Cuatro Narices",
          "Hola a todos, quiero compartirles esta serpiente cuatro narices ubicada en Humadea",
          "hace 8 min",
        ),
        _buildPostItem(
          "Serpiente Coral",
          "Iba caminando y me encontré con esta serpiente Coral ubicada en Acacias",
          "hace 4 horas",
        ),
        _buildPostItem(
          "Guio Negro",
          "Me asusté mucho cuando lo vi! Escuché que los Guios Negros también se llaman Anaconda Verde",
          "hace 3 días",
        ),
      ],
    );
  }

  Widget _buildPostItem(String title, String description, String timeAgo) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          CircleAvatar(
            radius: 25,
            backgroundColor: Colors.grey[300],
            backgroundImage: AssetImage('lib/assets/default_snake.png'),
          ),
          SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[700],
                  ),
                ),
                Text(
                  timeAgo,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[500],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPhotos() {
    return Container(
      height: 300,
      child: GridView.builder(
        padding: EdgeInsets.symmetric(horizontal: 16),
        itemCount: 6,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
        ),
        itemBuilder: (context, index) {
          return Container(
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(8),
              image: DecorationImage(
                image: AssetImage('lib/assets/default_snake.png'),
                fit: BoxFit.cover,
              ),
            ),
          );
        },
      ),
    );
  }
}

Widget _buildPhotoItem(String imagePath, String title) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Image.asset(
            imagePath,
            height: 200,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
        ),
        SizedBox(height: 8),
        Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
      ],
    ),
  );
}
