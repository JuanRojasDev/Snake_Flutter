import 'dart:convert';
import 'package:flutter/cupertino.dart';
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
import 'package:sqlite_flutter_crud/Views/profile/profileId.dart';
import 'package:sqlite_flutter_crud/Views/report/reportsMe/createReport.dart';
import 'package:sqlite_flutter_crud/Views/snake/SnakeIdentification/pageidentification.dart';
import '../../../JsonModels/Usuario.dart';

class AllReport extends StatefulWidget {
  final Usuario? usuario;
  List<Reporte> _reports = [];

  AllReport({this.usuario});

  @override
  _AllReportState createState() => _AllReportState();
}

class _AllReportState extends State<AllReport> {
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
      Provider.of<ReportProvider>(context, listen: false)
          .agregarReportes(report);
    });
  }

    String calcularTiempoTranscurrido(String fechaString) {
    // Convertir el string a un objeto DateTime
    final fechaPasada = DateTime.parse(fechaString);
    print("pasado"+fechaPasada.toString());
    // Obtener la fecha y hora actual
    DateTime ahora = DateTime.now().toUtc().add(Duration(minutes: 300));
    print("Ahora"+ahora.toString());

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
      if(dias == 1){
        return "Hace $dias día";
      }
      else{
        
        return "Hace $dias días";
      }
    } else if (diferencia.inMinutes >= 60) {
      int horas = diferencia.inMinutes ~/ 60;
      return "Hace $horas horas";
    } else {
      int minutos = diferencia.inMinutes;
      return "Hace $minutos minutos";
    }
  }

  Future<void> fetchAllReports() async {
    final reportProvider = context.watch<ReportProvider>();
    try {
      final response = await http.get(
          Uri.parse('https://back-production-0678.up.railway.app/Reporte/all'));
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
    final reportProvider = context.watch<ReportProvider>();

    if (!reportProvider.fetchData) {
      fetchAllReports();
      reportProvider.fetchData = true;
    }
    final body_Provider = context.watch<Home_Body_Provider>();
    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => Scaffold(
                      appBar: AppBar(
                        title: Text("Identificar Serpientes"),
                        leading: BuilderMenu(),
                      ),
                      drawer: DrawerHome(widget: widget),
                      body: PageIdentification(),
                      bottomNavigationBar: ButonBarHome(
                          body_Provider: body_Provider, widget: widget))));
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
                      context, reportProvider.reportesAll[reportProvider.reportesAll.length - 1 - index]);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _reportCard(BuildContext context, Reporte report) {
    final reportProvider = context.watch<ReportProvider>();
    final body_Provider = context.watch<Home_Body_Provider>();
    return GestureDetector(
      onTap: () {

      },
      child: Card(
        margin: EdgeInsets.all(10),
        color: Colors.white,
        child: Padding(
          padding: EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Scaffold(
                      appBar: AppBar(
                        title: Text("Mi Perfil"),
                        leading: BuilderMenu(),
                      ),
                      drawer: DrawerHome(widget: widget),
                      body: profileId(report: report,),
                      bottomNavigationBar: ButonBarHome(
                          body_Provider: body_Provider, widget: widget)),
                ),
              );
                    },
                    child: CircleAvatar(
                      backgroundImage: CachedNetworkImageProvider(
                        report.imagenUsuario ??
                            "https://th.bing.com/th/id/OIP.xW3Jf1_XaGI7z-jjrAgUIAHaE8?rs=1&pid=ImgDetMain",
                      ),
                      radius: 25,
                    ),
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
                                                Text(
                          calcularTiempoTranscurrido(report.created_at!) ?? '',
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
              Text(
                utf8.decode(report.titulo!.codeUnits) ?? '',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
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
                utf8.decode(report.descripcion!.codeUnits) ?? '',
                style: TextStyle(
                  fontSize: 16,
                  fontStyle: FontStyle.italic,
                ),
              ),
              SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}
