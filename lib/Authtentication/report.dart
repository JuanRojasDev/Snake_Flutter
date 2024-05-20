import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sqlite_flutter_crud/Authtentication/home.dart';
import 'dart:typed_data';
import 'package:sqlite_flutter_crud/Authtentication/login.dart';
import '../JsonModels/Usuario.dart';

class ReportPage extends StatefulWidget {
  final Usuario? usuario;

  ReportPage({this.usuario});

  @override
  _ReportPageState createState() => _ReportPageState();
}

class Report {
  String title;
  String description;
  String comment;
  Uint8List? imageBytes;

  Report({
    required this.title,
    required this.description,
    required this.comment,
    this.imageBytes,
  });
}

class _ReportPageState extends State<ReportPage> {
  List<Report> _reports = [];

  Future<void> _pickImage(Function(Uint8List?) onImagePicked) async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final bytes = await pickedFile.readAsBytes();
      onImagePicked(bytes);
    }
  }

  void _showReportForm(BuildContext context, {Report? report, int? index}) {
    TextEditingController titleController =
        TextEditingController(text: report?.title ?? '');
    TextEditingController descriptionController =
        TextEditingController(text: report?.description ?? '');
    TextEditingController commentController =
        TextEditingController(text: report?.comment ?? '');
    Uint8List? imageBytes = report?.imageBytes;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(report == null ? 'Escribir Reporte' : 'Editar Reporte'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: titleController,
                  decoration: InputDecoration(labelText: 'Título'),
                ),
                TextField(
                  controller: descriptionController,
                  decoration: InputDecoration(labelText: 'Descripción'),
                ),
                TextField(
                  controller: commentController,
                  decoration: InputDecoration(labelText: 'Comentario'),
                ),
                SizedBox(height: 10),
                imageBytes == null
                    ? Text('No hay imagen seleccionada.')
                    : Image.memory(
                        imageBytes!,
                        height: 150,
                      ),
                ElevatedButton(
                  onPressed: () => _pickImage((bytes) {
                    setState(() {
                      imageBytes = bytes;
                    });
                  }),
                  child: Text('Seleccionar Imagen'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Guardar'),
              onPressed: () {
                setState(() {
                  if (report == null) {
                    _reports.add(Report(
                      title: titleController.text,
                      description: descriptionController.text,
                      comment: commentController.text,
                      imageBytes: imageBytes,
                    ));
                  } else {
                    _reports[index!] = Report(
                      title: titleController.text,
                      description: descriptionController.text,
                      comment: commentController.text,
                      imageBytes: imageBytes,
                    );
                  }
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _deleteReport(int index) {
    setState(() {
      _reports.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Reporte de Serpientes'),
        backgroundColor: Color(0xFF5DB075),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            UserAccountsDrawerHeader(
              accountName:
                  Text(widget.usuario?.nombres ?? 'Usuario no disponible'),
              accountEmail:
                  Text(widget.usuario?.correo ?? 'Usuario no disponible'),
              currentAccountPicture: CircleAvatar(
                backgroundImage:
                    AssetImage('lib/assets/your_profile_picture.jpg'),
              ),
              decoration: BoxDecoration(color: Color(0xFF5DB075)),
            ),
            ListTile(
              leading: Icon(Icons.person),
              title: Text('Mi Perfil'),
              onTap: () {
                // Acción para ir a Mi Perfil
              },
            ),
            ListTile(
              leading: Icon(Icons.article),
              title: Text('Mis Publicaciones'),
              onTap: () {
                // Acción para ir a Mis Publicaciones
              },
            ),
            ListTile(
              leading: Icon(Icons.favorite),
              title: Text('Mis Me Gusta'),
              onTap: () {
                // Acción para ir a Mis Me Gusta
              },
            ),
            ListTile(
              leading: Icon(Icons.message),
              title: Text('Menciones'),
              onTap: () {
                // Acción para ir a Menciones
              },
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Configuración'),
              onTap: () {
                // Acción para ir a Configuración
              },
            ),
            ListTile(
              leading: Icon(Icons.info),
              title: Text('Acerca de'),
              onTap: () {
                // Acción para ir a Acerca de
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.logout, color: Colors.red),
              title: Text('Cerrar Sesión', style: TextStyle(color: Colors.red)),
              onTap: () {
                // Acción para cerrar sesión y redirigir al login
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => LoginScreen()));
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            builder: (BuildContext context) {
              return Container(
                height: 100,
                child: Column(
                  children: [
                    ListTile(
                      leading: Icon(Icons.note_add),
                      title: Text('Escribir Reporte'),
                      onTap: () {
                        Navigator.of(context).pop();
                        _showReportForm(context);
                      },
                    ),
                  ],
                ),
              );
            },
          );
        },
        child: Icon(Icons.add),
        backgroundColor: Color(0xFF5DB075),
      ),
      body: ListView.builder(
        itemCount: _reports.length,
        itemBuilder: (context, index) {
          final report = _reports[index];
          return Card(
            margin: EdgeInsets.all(10),
            color: Color(0xFFFAF3E0), // Color blanco hueso
            child: Padding(
              padding: EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    report.title,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 10),
                  report.imageBytes != null
                      ? Image.memory(
                          report.imageBytes!,
                          height: 150,
                        )
                      : Text('No hay imagen seleccionada.'),
                  SizedBox(height: 10),
                  Text(
                    report.description,
                    style: TextStyle(
                      fontSize: 16,
                      fontStyle: FontStyle.italic,
                      color: Colors.grey,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(report.comment),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () {
                          _showReportForm(context,
                              report: report, index: index);
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          _deleteReport(index);
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
              iconSize: 30,
              icon: Icon(Icons.help_outline),
              onPressed: () {
                // Acción para el botón de ayuda
              },
            ),
            IconButton(
              iconSize: 30,
              icon: Icon(Icons.edit),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            ReportPage(usuario: widget.usuario)));
              },
            ),
            IconButton(
              iconSize: 40,
              icon: Icon(Icons.home, color: Colors.green),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => HomeScreen()));
              },
            ),
            IconButton(
              iconSize: 30,
              icon: Icon(Icons.message),
              onPressed: () {
                // Acción para el botón de mensajes
              },
            ),
            IconButton(
              iconSize: 30,
              icon: Icon(Icons.person),
              onPressed: () {
                // Acción para el botón de perfil
              },
            ),
          ],
        ),
      ),
    );
  }
}
