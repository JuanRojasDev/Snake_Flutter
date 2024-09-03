import 'package:flutter/material.dart';
import 'package:sqlite_flutter_crud/JsonModels/Usuario.dart';

class UserProvider extends ChangeNotifier {
  Usuario _usernow = Usuario(nombres: '', correo: '', fechaN: ''); // Initialize with default values
  bool _fetchData = false;

  Usuario get usernow => _usernow;
  bool get fetchData => _fetchData;

  void setUser(Usuario newUser) {
    _usernow = newUser;
    notifyListeners();
  }
  void setImage(String newimagne) {
    _usernow.imagen = newimagne;
    notifyListeners();
  }
  void setUserName(String name) {
    _usernow.nombres = name;
    notifyListeners();
  }
  void setFetchData(bool newFetchData) {
    _fetchData = newFetchData;
    notifyListeners();
  }
}