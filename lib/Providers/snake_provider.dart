import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:sqlite_flutter_crud/Authtentication/home.dart';
import 'package:sqlite_flutter_crud/Providers/snake_class.dart';

class Snake_Provider extends ChangeNotifier {
  List<Serpiente> serpientes = [];
  bool fetcdata = false;

  void setSerpientes(List<Serpiente> nuevasSerpientes) {
    serpientes = nuevasSerpientes;
    notifyListeners();
  }

  void agregarSerpiente(Serpiente nuevaSerpiente) {
    serpientes.add(nuevaSerpiente);
    notifyListeners();
  }


  Future<void> fectSnakesPoison(bool valid) async {
      final String url =
          'https://back-1-9ehs.onrender.com/Snakes/poison?valid=' +
              valid.toString(); // server ip

      print(url);

      final Map<String, String> headers = {'Content-Type': 'application/json'};

      final response = await http.get(Uri.parse(url), headers: headers);
      List<Serpiente> serpientes = [];
      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(response.body);

        if (jsonResponse != []) {
          for (var element in jsonResponse) {
            serpientes.add(Serpiente.fromJson(element));
          }
        }

        setSerpientes(serpientes);
      }
    }

}
