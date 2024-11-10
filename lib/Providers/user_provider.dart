import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:sqlite_flutter_crud/JsonModels/Usuario.dart';

class UserProvider extends ChangeNotifier {
  Usuario _usernow = Usuario(
      nombres: '',
      correo: '',
      fechaN: '',
      imagenFondo: '',
      descripcion: '',
      id: 0);
  Usuario _userdefault = Usuario(
      nombres: '',
      correo: '',
      fechaN: '',
      imagenFondo: '',
      descripcion: '',
      id: 0); // Initialize with default values
  bool _fetchData = false;
  final storage = new FlutterSecureStorage();

  ValueNotifier userCredential = ValueNotifier('');

  Usuario get usernow => _usernow;
  bool get fetchData => _fetchData;

  Future<void> logoutUser() async {
    _usernow = _userdefault;
    
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
    _usernow.imagenFondo = newimagne;
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
