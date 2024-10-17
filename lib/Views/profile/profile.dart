import 'dart:convert';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:sqlite_flutter_crud/JsonModels/reporte.dart';
import 'package:sqlite_flutter_crud/Providers/report_provider.dart';
import 'package:sqlite_flutter_crud/Providers/user_provider.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool showPosts = true;
  bool isEditing = false;

  File? _profileImage;
  File? _coverImage;
  String _name = "Nombre del Usuario";
  String _descripcion = "Descripción del Usuario";
  String _status = "Esta es una descripción breve";
  String? imageUrl = "";
  String? coverImageUrl = "";
  final _nameController = TextEditingController();
  final _statusController = TextEditingController();
  final storage = FlutterSecureStorage();

  Future<http.Response> editUser() async {
    final String? token = await storage.read(key: 'jwt');
    if (token == null) {
      throw Exception('Missing JWT token');
    }

    final Uri url =
        Uri.parse('https://back-production-0678.up.railway.app/usuario/edit');
    final Map<String, dynamic> body = {
      "nombre": _name,
      "imagenurl": imageUrl,
      "Descripcion": _descripcion,
      "imagen_fondo": coverImageUrl
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
      throw Exception('Error editing user');
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

  Future<String> subirImagenFireBase(File image) async {
    final storage =
        FirebaseStorage.instanceFor(bucket: 'meta-snake.appspot.com');

    final storageRef = storage
        .ref()
        .child('images/${DateTime.now().millisecondsSinceEpoch}.jpg');

    final uploadTask = storageRef.putFile(image);

    try {
      final snapshot = await uploadTask;
      final downloadUrl = await snapshot.ref.getDownloadURL();
      print('Imagen subida correctamente: $downloadUrl');
      return downloadUrl;
    } on FirebaseException catch (error) {
      print("Error uploading image: ${error.code} - ${error.message}");
      throw error;
    } catch (error) {
      print("Unexpected error: $error");
      throw error;
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

  void _saveDescription() async {
    setState(() {
      _descripcion = _statusController.text;
    });
    await editUser();
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = context.watch<UserProvider>();
    _nameController.text = userProvider.usernow.nombres;
    _statusController.text =
        userProvider.usernow.descripcion ?? "Sin descripción";
    imageUrl = userProvider.usernow.imagen;
    coverImageUrl = userProvider.usernow.imagen_fondo;

    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                GestureDetector(
                  onTap: () async {
                    await _pickImage();
                    if (_profileImage != null) {
                      coverImageUrl = await subirImagenFireBase(_profileImage!);
                      await editUser();
                      _saveImageUrl(coverImageUrl!);
                      userProvider.setImageBack(coverImageUrl!);
                    }
                  },
                  child: Container(
                    height: 250,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      image: coverImageUrl != null && coverImageUrl!.isNotEmpty
                          ? DecorationImage(
                              image: NetworkImage(coverImageUrl!),
                              fit: BoxFit.cover,
                            )
                          : null,
                      color: Color(0xFF5DB074),
                    ),
                    child: coverImageUrl != null && coverImageUrl!.isNotEmpty
                        ? Positioned(
                            bottom: 20,
                            left: 0,
                            right: 0,
                            child: Center(
                              child: Icon(
                                Icons.camera_alt,
                                color: Colors.white,
                                size: 70,
                              ),
                            ),
                          )
                        : null,
                  ),
                ),
                Positioned(
                  top: 10,
                  right: 10,
                  child: IconButton(
                    icon: Icon(Icons.edit, color: Colors.white, size: 30),
                    onPressed: () {
                      setState(() {
                        isEditing = !isEditing;
                      });
                    },
                  ),
                ),
                Positioned(
                  bottom: -70,
                  left: MediaQuery.of(context).size.width / 2 - 95,
                  child: GestureDetector(
                    onTap: () async {
                      await _pickImage();
                      if (_profileImage != null) {
                        imageUrl = await subirImagenFireBase(_profileImage!);
                        await editUser();
                        _saveImageUrl(imageUrl!);
                        userProvider.setImage(imageUrl!);
                      }
                    },
                    child: CircleAvatar(
                      radius: 90,
                      backgroundColor: Colors.white,
                      child: CircleAvatar(
                        radius: 85,
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
                    enabled: isEditing,
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "Nombre del usuario",
                    ),
                    onSubmitted: (value) =>
                        {_saveName(), userProvider.setUserName(_name)},
                  ),
                  SizedBox(height: 10),
                  TextField(
                    controller: _statusController,
                    textAlign: TextAlign.center,
                    enabled: isEditing,
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey[700],
                    ),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "Descripción",
                    ),
                    onSubmitted: (value) => {
                      _saveDescription(),
                      userProvider.setUserDescription(_descripcion)
                    },
                  ),
                ],
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
      floatingActionButton: isEditing
          ? FloatingActionButton(
              onPressed: () {
                _saveName();
                _saveDescription();
                setState(() {
                  isEditing = false;
                });
              },
              child: Icon(Icons.save),
            )
          : null,
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

  String calcularTiempoTranscurrido(DateTime fecha) {
    final Duration diferencia = DateTime.now().difference(fecha);
    if (diferencia.inDays > 0) {
      return '${diferencia.inDays} días';
    } else if (diferencia.inHours > 0) {
      return '${diferencia.inHours} horas';
    } else if (diferencia.inMinutes > 0) {
      return '${diferencia.inMinutes} minutos';
    } else {
      return 'Justo ahora';
    }
  }

  Widget _buildPosts() {
    return Container(
      height: 300,
      child: ListView.builder(
        itemCount: 10,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
            child: Card(
              elevation: 2,
              child: ListTile(
                title: Text('Título de publicación $index'),
                subtitle: Text(calcularTiempoTranscurrido(
                    DateTime.now().subtract(Duration(days: index)))),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildPhotos() {
    return Container(
      height: 300,
      child: ListView.builder(
        itemCount: 10,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
            child: Card(
              elevation: 2,
              child: ListTile(
                title: Text('Título de foto $index'),
                leading: Icon(Icons.image),
              ),
            ),
          );
        },
      ),
    );
  }
}
