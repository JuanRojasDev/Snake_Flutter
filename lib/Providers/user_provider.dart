import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:sqlite_flutter_crud/JsonModels/Usuario.dart';

class UserProvider extends ChangeNotifier {
  Usuario _usernow = Usuario(
      nombres: '',
      correo: '',
      fechaN: '',
      imagen_fondo: '',
      descripcion: '',
      id: '');
  Usuario _userdefault = Usuario(
      nombres: '',
      correo: '',
      fechaN: '',
      imagen_fondo: '',
      descripcion: '',
      id: ''); // Initialize with default values
  bool _fetchData = false;
  final storage = new FlutterSecureStorage();

  Usuario get usernow => _usernow;
  bool get fetchData => _fetchData;

  Future<void> logoutUser() async {
    _usernow = _userdefault;
    await storage.delete(key: 'jwt');
  }

  void setUser(Usuario newUser) {
    _usernow = newUser;
    notifyListeners();
  }

  void setImage(String newimagne) {
    _usernow.imagen = newimagne;
    notifyListeners();
  }

  void setImageBack(String newimagne) {
    _usernow.imagen_fondo = newimagne;
    notifyListeners();
  }

  void setUserName(String name) {
    _usernow.nombres = name;
    notifyListeners();
  }

  void setUserDescription(String name) {
    _usernow.descripcion = name;
    notifyListeners();
  }

  void setFetchData(bool newFetchData) {
    _fetchData = newFetchData;
    notifyListeners();
  }
}