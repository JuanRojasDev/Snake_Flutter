import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:sqlite_flutter_crud/Providers/Home_Body_provider.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:sqlite_flutter_crud/Providers/snake_class.dart';
import 'package:sqlite_flutter_crud/Providers/snake_provider.dart';
import 'package:sqlite_flutter_crud/Views/snake/snake_Info/Info_snake/info_Snale.dart';

class Screen_galeria extends StatefulWidget {
  Screen_galeria({super.key});

  @override
  State<Screen_galeria> createState() => _Screen_galeriaState();
}

class _Screen_galeriaState extends State<Screen_galeria> {
  @override
  Widget build(
    BuildContext context,) {
    final snake_Provider = context.watch<Snake_Provider>();

    if (snake_Provider.serpientes.length > 0) {
       
       return ListView(children: [Info_Snake(infoSnake: (snake_Provider.serpientes[0]))]);
    }
    return Text(
        "Lista vacia");
  }
}
