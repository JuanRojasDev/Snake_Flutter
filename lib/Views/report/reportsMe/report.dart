import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:provider/provider.dart';
import 'package:sqlite_flutter_crud/Authtentication/home.dart';
import 'dart:typed_data';
import 'package:sqlite_flutter_crud/Authtentication/login.dart';
import 'package:sqlite_flutter_crud/JsonModels/reporte.dart';
import 'package:sqlite_flutter_crud/Providers/report_provider.dart';
import 'package:sqlite_flutter_crud/Views/report/reportsMe/createReport.dart';
import '../../../JsonModels/Usuario.dart';

class ReportPage extends StatefulWidget {
  final Usuario? usuario;
  List<Reporte> _reports = [];

  ReportPage({this.usuario});

  @override
  _ReportPageState createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
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

  void _deleteReport(int index) {
    setState(() {
      widget._reports?.removeAt(index);
    });
  }

  void _addReport(Reporte report) {
    setState(() {
      widget._reports.add(report);
      Provider.of<Reporte_Provider>(context, listen: false)
          .agregarReportes(report);
    });
  }

  Future<void> fetchAllReports() async {
    final reportProvider = context.watch<Reporte_Provider>();
    try {
      final response = await http
          .get(Uri.parse('https://back-1-9ehs.onrender.com/Reporte/all'));
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        final List<Reporte> reports =
            data.map((json) => Reporte.fromJson(json)).toList();
        reportProvider.setReportes(reports);
        
      } else {
        // Handle error
        throw Exception('Failed to load reports');
      }
    } catch (e) {
      // Handle error
      print('Error fetching reports: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final reportProvider = context.watch<Reporte_Provider>();

    if (!reportProvider.fecthData) {
      fetchAllReports();
      reportProvider.fecthData = true;
    }

    return Scaffold(
        backgroundColor: Colors.white,
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => Scaffold(
                          appBar: AppBar(
                            title: Text(
                                'Crear Publicacion'), // Mantén el título original
                          ),
                          body:
                              createReport(), // Muestra solo el contenido de createReport()
                        )));
          },
          child: Icon(Icons.add),
          backgroundColor: Color(0xFF4CAF50),
        ),
        body: SafeArea(
         
            child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                scrollDirection: Axis.vertical,
                itemCount: reportProvider.reportesAll.length,
                itemBuilder: (context, index) {
                  return _reportCard(
                      context, reportProvider.reportesAll[index]);
                },
              ),
            ),
          ],
        )));
  }

  Widget _reportCard(BuildContext context, Reporte report) {
    
    return GestureDetector(
      onTap: () {},
      child: Card(
        margin: EdgeInsets.all(10),
        color: Color(0xFFFAF3E0), // Color blanco hueso
        child: Padding(
          padding: EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [

              Text(
                report.usuario_nombre ?? '',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                
                textAlign: TextAlign.center,
              ),
              CachedNetworkImage(
                imageUrl:
                    report.imagenUsuario!,
                placeholder: (context, url) => LoadingIndicator(
                  indicatorType: Indicator.ballPulse,
                  colors: const [
                    Color.fromARGB(255, 36, 235, 18),
                    Color.fromARGB(255, 25, 224, 128),
                    Color.fromARGB(255, 59, 235, 150),
                    Color.fromARGB(255, 116, 241, 181)
                  ],
                  pathBackgroundColor: Color.fromARGB(255, 138, 209, 5),
                ),
                errorWidget: (context, url, error) => Icon(Icons.error),
                height: 150,
              ),

              Text(
                report.titulo ?? '',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                
                textAlign: TextAlign.center,
              ),

              SizedBox(height: 10),
              CachedNetworkImage(
                imageUrl:
                    report.imagen!,
                placeholder: (context, url) => LoadingIndicator(
                  indicatorType: Indicator.ballPulse,
                  colors: const [
                    Color.fromARGB(255, 36, 235, 18),
                    Color.fromARGB(255, 25, 224, 128),
                    Color.fromARGB(255, 59, 235, 150),
                    Color.fromARGB(255, 116, 241, 181)
                  ],
                  pathBackgroundColor: Color.fromARGB(255, 138, 209, 5),
                ),
                errorWidget: (context, url, error) => Icon(Icons.error),
                height: 150,
              ),
              SizedBox(height: 10),
              Text(
                report.descripcion ?? '',
                style: TextStyle(
                  fontSize: 16,
                  fontStyle: FontStyle.italic,
                  color: Colors.grey,
                ),
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      print(report.reportId);
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
