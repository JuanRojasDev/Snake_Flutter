import 'package:flutter/material.dart';
import 'package:sqlite_flutter_crud/Authtentication/home.dart';
import 'package:sqlite_flutter_crud/Views/snake/snake_Info/Galeria/Screen_Galeria_old.dart';

class Home_Body_Provider extends ChangeNotifier {
  Widget Body_ini = Body_init();
  Widget previousBody = Body_init();
  int _selectedIndex = 0; // Por defecto, selecciona el botón de inicio
  String _appBarTitle =
      'Inicio'; // Por defecto, el título del AppBar es 'Inicio'

  // Getter for selectedIndex
  int get selectedIndex => _selectedIndex;
  String get appBarTitle => _appBarTitle;

  // Setter for selectedIndex
  void setSelectedIndex(int index) {
    _selectedIndex = index;
    notifyListeners();
  }

  // Setter for appBarTitle
  void setAppBarTitle(String title) {
    _appBarTitle = title;
    notifyListeners();
  }

  Future<void> changedBodyHome(Widget newBody) async {
    if (newBody != Null) {
      Body_ini = newBody;  
      previousBody = Body_ini;
      };

    notifyListeners();
  }
    // Function to navigate back to the previous body
  void navigateBackToPreviousBody() {
    Body_ini = previousBody;
    notifyListeners();
  }
}
