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

}
