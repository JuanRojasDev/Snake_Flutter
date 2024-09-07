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
  String _name = "Victoria Robertson";
  String _status = "Ingeniera Agroecológica";
  bool showPosts = true; // Variable para cambiar entre Publicaciones y Fotos

  final _nameController = TextEditingController();
  final _statusController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.usuario?.nombres ?? _name;
    _statusController.text = _status;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    height: 150,
                    color: Color(0xFF5DB074),
                  ),
                  Positioned(
                    top: 10,
                    left: 16,
                    right: 16,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton(
                          onPressed: () {
                            // Acción al presionar Ajustes
                          },
                          child: Text(
                            "Ajustes",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20, // Ajusta el tamaño de la letra aquí
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            // Acción al presionar Salir
                          },
                          child: Text(
                            "Salir",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20, // Ajusta el tamaño de la letra aquí
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    bottom: -60,
                    left: MediaQuery.of(context).size.width / 2 - 60,
                    child: GestureDetector(
                      onTap: _pickImage,
                      child: CircleAvatar(
                        radius: 60,
                        backgroundColor: Colors.white,
                        child: CircleAvatar(
                          radius: 55,
                          backgroundImage: _profileImage != null
                              ? FileImage(_profileImage!)
                              : AssetImage('lib/assets/default_profile.png')
                                  as ImageProvider,
                          child: _profileImage == null
                              ? Icon(Icons.camera_alt,
                                  color: Colors.white, size: 40)
                              : null,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 80),
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
              showPosts
                  ? _buildPosts()
                  : _buildPhotos(), // Mostrar Publicaciones o Fotos según el estado
            ],
          ),
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

  // Sección de Publicaciones
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
                SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[700],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 10),
          Text(
            timeAgo,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }

  // Sección de Fotos
  Widget _buildPhotos() {
    return Column(
      children: [
        _buildPhotoItem('lib/assets/snake_image.png', 'Guio Perdicero'),
        _buildPhotoItem('lib/assets/snake_image2.png', 'Serpiente Coral'),
      ],
    );
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
}
