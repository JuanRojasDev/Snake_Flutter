import 'package:flutter/material.dart';
import 'package:sqlite_flutter_crud/Authtentication/home.dart';
import 'package:sqlite_flutter_crud/Views/snake/snake_Info/Galeria/Screen_Galeria.dart';

class Home_Body_Provider extends ChangeNotifier {
  Widget drawerInit = DrawerHome(widget: widget);
  Widget Leadig = BuilderMenu();
  
  


  static get widget => null;
}
