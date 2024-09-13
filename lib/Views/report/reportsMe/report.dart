import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:provider/provider.dart';
import 'package:sqlite_flutter_crud/Authtentication/home.dart';
import 'dart:typed_data';
import 'package:sqlite_flutter_crud/Authtentication/login.dart';
import 'package:sqlite_flutter_crud/JsonModels/reporte.dart';
import 'package:sqlite_flutter_crud/Providers/Home_Body_provider.dart';
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
      print("Error picking image: $error");
    }
  }

  void _deleteReport(int index) {
    setState(() {
      widget._reports.removeAt(index);
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
        throw Exception('Failed to load reports');
      }
    } catch (e) {
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
                  title: Text('Crear Publicacion'),
                ),
                body: createReport(),
              ),
            ),
          );
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
        ),
      ),
    );
  }

  Widget _reportCard(BuildContext context, Reporte report) {
    final reportProvider = context.watch<Reporte_Provider>();

    return GestureDetector(
      onTap: () {},
      child: Card(
        margin: EdgeInsets.all(10),
        color: Color(0xFFFAF3E0),
        child: Padding(
          padding: EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    backgroundImage: CachedNetworkImageProvider(
                      report.imagenUsuario ??
                          "https://th.bing.com/th/id/OIP.xW3Jf1_XaGI7z-jjrAgUIAHaE8?rs=1&pid=ImgDetMain",
                    ),
                    radius: 25,
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          report.usuario_nombre ?? '',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              CachedNetworkImage(
                imageUrl: report.imagen ??
                    "https://th.bing.com/th/id/OIP.xW3Jf1_XaGI7z-jjrAgUIAHaE8?rs=1&pid=ImgDetMain",
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
                height: 250,
                width: double.infinity,
                fit: BoxFit.cover,
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
                      reportProvider.deleteReport(report.reportId);
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
