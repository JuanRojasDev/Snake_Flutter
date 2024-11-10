import 'dart:convert';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
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
  String _Descripcion = "Nombre del Usuario";
  String _status = "Esta es una descripción breve";
  String? imageUrl = "";
  String? CoverimageUrl = "";
  final _nameController = TextEditingController();
  final _statusController = TextEditingController();
  final storage = FlutterSecureStorage();
  late List<Reporte>? _showreports = null;

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
      "Descripcion": _Descripcion,
      "imagen_fonodo": CoverimageUrl
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

  void _saveDescription() async {
    setState(() {
      _Descripcion = _statusController.text;
    });
    await editUser();
  }

  Future<void> fetchMeReports() async {
    try {
      final String? token = await storage.read(key: 'jwt');
      if (token == null) {
        throw Exception('Missing JWT token'); // Handle missing token error
      }
      final Map<String, String> headers = {
        'Content-Type': 'application/json; charset=utf-8',
        'Authorization': 'Bearer $token', // Include retrieved JWT token
        'accept': 'application/json',
      };
      final response = await http.get(
          Uri.parse(
              'https://back-production-0678.up.railway.app/Reporte/all_me'),
          headers: headers);

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        final List<Reporte> reports =
            data.map((json) => Reporte.fromJsonNoUSer(json)).toList();
        setState(() {
          _showreports = reports;
        });
      } else {
        // Handle error
        throw Exception('Failed to load reports');
      }
    } catch (e) {
      // Handle error
      print('Error fetching reports: $e');
    }
  }

  void delete(int id ){
    setState(() {
      _showreports?.removeWhere((reporte) => reporte.reportId == id);
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    fetchMeReports();
    print("init");
  }

  @override
  Widget build(BuildContext context) {
    final user_provider = context.watch<UserProvider>();
    _nameController.text = user_provider.usernow.nombres;
    if (user_provider.usernow.descripcion == null) {
      _statusController.text =  "Descripcion de Usuario";
    } else {
      _statusController.text = utf8.decode(user_provider.usernow.descripcion!.codeUnits)  ?? "Selecciona una descripcion";
    }
    imageUrl = user_provider.usernow.imagen;
    CoverimageUrl = user_provider.usernow.imagenFondo;
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
                    CoverimageUrl = await subirImagenFireBase(_profileImage!);
                    await editUser();
                    _saveImageUrl(CoverimageUrl!);
                    user_provider.setImageBack(CoverimageUrl!);
                  },
                  child: Container(
                    height: 250,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      image: user_provider.usernow.imagenFondo != ""
                          ? DecorationImage(
                              image: NetworkImage(CoverimageUrl ?? ""),
                              fit: BoxFit.cover,
                            )
                          : null,
                      color: Color(0xFF5DB074),
                    ),
                    child: user_provider.usernow.imagenFondo != ""
                        ? Stack(
                            children: [
                              Positioned(
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
                              ),
                            ],
                          )
                        : null,
                  ),
                ),
                // Ícono de lápiz para editar el perfil
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
                        {_saveName(), user_provider.setUserName(_name)},
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
                      user_provider.setUserDescription(_Descripcion)
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
                mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.all(9),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(22),
                              topLeft: Radius.circular(22)),
                          border: Border.all(
                              width: 3,
                              color: Color.fromARGB(150, 180, 178, 178))),
                      child: _buildTabOption("Publicaciones", showPosts, () {
                        setState(() {
                          showPosts = true;
                        });
                      }),
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.all(9),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                              bottomRight: Radius.circular(22),
                              topRight: Radius.circular(22)),
                          border: Border.all(
                              width: 3,
                              color: Color.fromARGB(150, 180, 178, 178))),
                      child: _buildTabOption("Fotos", !showPosts, () {
                        setState(() {
                          showPosts = false;
                        });
                      }),
                    ),
                  ),
                ],
              ),
            ),
            Divider(thickness: 2, color: Colors.grey[300]),
            showPosts ? _buildPosts(_showreports) : _buildPhotos(_showreports),
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
              fontSize: 20,
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

  String calcularTiempoTranscurrido(String fechaString) {
    // Convertir el string a un objeto DateTime
    DateTime fechaPasada = DateTime.parse(fechaString);

    // Obtener la fecha y hora actual
    DateTime ahora = DateTime.now();

    // Calcular la diferencia en milisegundos
    Duration diferencia = ahora.difference(fechaPasada);

    // Determinar la unidad de tiempo más apropiada
    if (diferencia.inDays >= 365) {
      int year = diferencia.inDays ~/ 365;
      return "Hace $year años";
    } else if (diferencia.inDays >= 30) {
      int meses = diferencia.inDays ~/ 30;
      return "Hace $meses meses";
    } else if (diferencia.inHours >= 24) {
      int dias = diferencia.inHours ~/ 24;
      return "Hace $dias días";
    } else if (diferencia.inMinutes >= 60) {
      int horas = diferencia.inMinutes ~/ 60;
      return "Hace $horas horas";
    } else {
      int minutos = diferencia.inMinutes;
      return "Hace $minutos minutos";
    }
  }

  Widget _buildPosts([List<Reporte>? reports]) {
    if (reports != null) {
      if (reports!.length > 0) {
        return Column(
          children: List.generate(
            reports!.length,
            (index) => _buildPostItem(
              utf8.decode(reports[index].titulo!.codeUnits),
              utf8.decode(reports[index].descripcion!.codeUnits),
              calcularTiempoTranscurrido(
                  reports[index].created_at ?? "2023-11-28 10:30:00"),
              reports[index].reportId,
              reports[index].imagen,
            ),
          ),
        );
      } else {
        return Text("No has creado Reportes");
      }
    } else {
      return Text("No has creado Reportes");
    }
  }

  Widget _buildPostItem(String? title, String? description, String? timeAgo,
      int id, String? imagen) {
    final report_provider = context.watch<ReportProvider>();
    return Padding(
      padding: const EdgeInsets.all(11),
      child: Row(
        children: [
          Container(
            width: 65, // Adjust the width as needed
            height: 65, // Adjust the height as needed
            margin: EdgeInsets.only(bottom: 33),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(8)),
              // Set the shape to rectangle
              image: DecorationImage(
                image: NetworkImage(imagen!),
                fit: BoxFit.fill,
                alignment: Alignment.topCenter,
              ),
            ),
          ),
          SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Expanded(
                      child: Text(
                        title ?? "default",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        Text(
                          timeAgo ?? "default",
                          style: TextStyle(fontSize: 14, color: Colors.grey),
                        ),
                        IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () => showDialog<void>(
                            context: context,
                            barrierDismissible:
                                false, // User must confirm or cancel
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text('Confirmar Eliminacion'),
                                content: Text(
                                    '¿Estás seguro de eliminar tu publicación? Si la eliminas no la podrás volver a ver.'),
                                actions: <Widget>[
                                  TextButton(
                                    child: Text('Cancelar'),
                                    onPressed: () => Navigator.pop(context),
                                  ),
                                  TextButton(
                                    child: Text('Eliminar'),
                                    onPressed: () {
                                      Navigator.pop(
                                          context); 
                                      report_provider.deleteReport(id);
                                      delete(id);
                                      
                                    },
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                      ],
                    )
                  ],
                ),
                SizedBox(height: 5),
                Text(
                  description?.trim() ??
                      "default", // Trim leading/trailing whitespace
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black54,
                  ),
                ),
                SizedBox(height: 5),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPhotosItem(String? title, String? imagen) {
    final report_provider = context.watch<ReportProvider>();
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          Container(
            width: double.infinity, // Adjust the width as needed
            height: 400, // Adjust the height as needed
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(16)),
              // Set the shape to rectangle
              image: DecorationImage(
                image: NetworkImage(imagen!),
                fit: BoxFit.fill,
                alignment: Alignment.topCenter,
              ),
            ),
          ),
          Text(
            title ?? "default",
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

  Widget _buildPhotos([List<Reporte>? reports]) {
    if (reports != null) {
      if (reports!.length > 0) {
        return Column(
          children: List.generate(
            reports!.length,
            (index) => _buildPhotosItem(
              utf8.decode(reports[index].titulo!.codeUnits),
              reports[index].imagen,
            ),
          ),
        );
      } else {
        return Text("No has creado Reportes");
      }
    } else {
      return Text("No has creado Reportes");
    }
  }
}
