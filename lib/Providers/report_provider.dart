import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:sqlite_flutter_crud/JsonModels/reporte.dart';

class Reporte_Provider extends ChangeNotifier {
  List<Reporte> reportesAll = [];
  bool fecthData = false;

  void setReportes(List<Reporte> nuevosReportes) {
    reportesAll = nuevosReportes;
    notifyListeners();
  }

  void agregarReportes(Reporte nuevosReportes) {
    reportesAll.add(nuevosReportes);
    notifyListeners();
  }



  Future<void> fetchAllReports() async {
    try {
      final response = await http
          .get(Uri.parse('https://back-1-9ehs.onrender.com/Reporte/all'));
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

    Future<void> deleteReport() async {
    try {
      final response = await http
          .get(Uri.parse('https://back-1-9ehs.onrender.com/Reporte/all'));
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
      print('Error delet reports: $e');
    }
  }
}
