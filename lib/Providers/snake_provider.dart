import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:sqlite_flutter_crud/Authtentication/home.dart';
import 'package:sqlite_flutter_crud/Providers/snake_class.dart';

class Snake_Provider extends ChangeNotifier {
  List<Serpiente> serpientes = [];
  List<Serpiente> filteredSerpientes = []; // Lista para serpientes filtradas
  bool fetcdata = false;

  void setSerpientes(List<Serpiente> nuevasSerpientes) {
    serpientes = nuevasSerpientes;
    filteredSerpientes = nuevasSerpientes; // Inicializar como lista completa
    notifyListeners();
  }

  void filterSerpientes(String query) {
    if (query.isEmpty) {
      filteredSerpientes =
          serpientes; // Restaurar lista completa si no hay filtro
    } else {
      filteredSerpientes = serpientes
          .where((serpiente) =>
              serpiente.nombre3.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
    notifyListeners();
  }

  Future<void> fectSnakesPoison(bool valid) async {
    final String url =
        'https://back-production-0678.up.railway.app/Snakes/poison?valid=' +
            valid.toString();

    final Map<String, String> headers = {'Content-Type': 'application/json'};
    final response = await http.get(Uri.parse(url), headers: headers);

    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);
      List<Serpiente> serpientes = [];

      if (jsonResponse.isNotEmpty) {
        for (var element in jsonResponse) {
          serpientes.add(Serpiente.fromJson(element));
        }
      }
      setSerpientes(serpientes);
    }
  }
}
