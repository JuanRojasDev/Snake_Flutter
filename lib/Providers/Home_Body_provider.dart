
import 'package:flutter/material.dart';
import 'package:sqlite_flutter_crud/Authtentication/home.dart';


class Home_Body_Provider extends ChangeNotifier {

    Widget Body_ini = Body_init() ; 

    Future<void> cahngedBodyHome(Widget newBody)async{
      if(newBody != Null)
        Body_ini = newBody; 
      notifyListeners();
    }
}