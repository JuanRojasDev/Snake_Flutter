import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:sqlite_flutter_crud/JsonModels/reporte.dart';

class Reporte_Provider extends ChangeNotifier {
  List<Reporte> reportesAll = [];
  bool fecthData = false;
  final storage = new FlutterSecureStorage();
  List<Reporte> reportesMe = [];
  bool fecthreportesMe = false;


  void setReportes(List<Reporte> nuevosReportes) {
    reportesAll = nuevosReportes;
    notifyListeners();
  }

  void setMeReports(List<Reporte> nuevosReportes2) {
    reportesMe = nuevosReportes2;
    notifyListeners();
  }

  void agregarReportes(Reporte nuevosReportes) {
    reportesAll.add(nuevosReportes);
    notifyListeners();
  }


void eliminarReportePorId(int id) {
  reportesAll.removeWhere((reporte) => reporte.reportId == id);
  reportesMe.removeWhere((reporte) => reporte.reportId == id);
  notifyListeners();
}

  Future<void> fetchAllReports() async {
    try {
      final response = await http
          .get(Uri.parse('https://back-production-0678.up.railway.app/Reporte/all'));
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        final List<Reporte> reports =
            data.map((json) => Reporte.fromJson(json)).toList();
        setReportes(reports);
      } else {
        // Handle error
        throw Exception('Failed to load reports');
      }
    } catch (e) {
      // Handle error
      print('Error fetching reports: $e');
    }
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
      final response = await http
          .get(Uri.parse('https://back-production-0678.up.railway.app/Reporte/all_me'),headers: headers);

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        final List<Reporte> reports = data.map((json) => Reporte.fromJsonNoUSer(json)).toList();
        fecthreportesMe = true;
        setMeReports(reports);
        
      } else {
        // Handle error
        throw Exception('Failed to load reports');
      }
    } catch (e) {
      // Handle error
      print('Error fetching reports: $e');
    }
  }

  Future<http.Response> deleteReport(int id) async {
    // 1. Retrieve JWT token from secure storage
    final String? token = await storage.read(key: 'jwt');
    if (token == null) {
      throw Exception('Missing JWT token'); // Handle missing token error
    }

    // 2. Construct the request URL
    final Uri url =
        Uri.parse('https://back-production-0678.up.railway.app/Reporte/Eliminar?id=$id');



    // 4. Set request headers
    final Map<String, String> headers = {
      'Content-Type': 'application/json; charset=utf-8',
      'Authorization': 'Bearer $token', // Include retrieved JWT token
      'accept': 'application/json',
    };

    // 5. Send the POST request
    final http.Response response =
        await http.delete(url, headers: headers,);

    // 6. Handle the response
    if (response.statusCode == 200 || response.statusCode == 201) {
      // Request successful, handle the response data here
      final decodedResponse = jsonDecode(response.body);
      // Process the decoded response depending on your API's structure
      eliminarReportePorId(id);

      print(decodedResponse); // Example usage
    } else {
      // Request failed, handle the error
      print('Error: ${response.statusCode}');
      print('${response.body}');
      throw Exception('Error creating report'); // Throw a custom exception
    }

    return response;
  }

}
