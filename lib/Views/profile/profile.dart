import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sqlite_flutter_crud/Authtentication/home.dart';
import 'package:sqlite_flutter_crud/Authtentication/login.dart';
import '../../../JsonModels/Usuario.dart';

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

  final _nameController = TextEditingController();
  final _statusController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _nameController.text =  widget.usuario?.nombres ?? 'Usuario no disponible';
    _statusController.text = _status;
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

    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                GestureDetector(
                  onTap: () => _pickImage(false),
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
                    onTap: () => _pickImage(true),
                    child: CircleAvatar(
                      radius: 90, // Ajusta el tamaño del círculo aquí
                      backgroundColor: Colors.white,
                      child: CircleAvatar(
                        radius: 85, // Ajusta el tamaño de la imagen aquí
                        backgroundImage: _profileImage != null
                            ? FileImage(_profileImage!)
                            : AssetImage('lib/assets/default_profile.png')
                                as ImageProvider,
                        child: _profileImage == null
                            ? Icon(Icons.camera_alt,
                                color: Colors.white, size: 55)
                            : null,
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
