import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:sqlite_flutter_crud/Authtentication/home.dart';
import 'package:sqlite_flutter_crud/Providers/snake_class.dart';

class Snake_Provider extends ChangeNotifier {
  List<Serpiente> serpientes = [];

  void setSerpientes(List<Serpiente> nuevasSerpientes) {
    serpientes = nuevasSerpientes;
    notifyListeners();
  }

  void agregarSerpiente(Serpiente nuevaSerpiente) {
    serpientes.add(nuevaSerpiente);
    notifyListeners();
  }
}
