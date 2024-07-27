import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:sqlite_flutter_crud/Providers/Home_Body_provider.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:sqlite_flutter_crud/Providers/snake_class.dart';
import 'package:sqlite_flutter_crud/Providers/snake_provider.dart';
import 'package:sqlite_flutter_crud/Views/snake_Info/Info_snake/info_Snale.dart';

class Screen_galeria extends StatefulWidget {
  List<Serpiente> serpientes;
  Screen_galeria({super.key, required this.serpientes});

  @override
  State<Screen_galeria> createState() => _Screen_galeriaState();
}

class _Screen_galeriaState extends State<Screen_galeria> {
  @override
  Widget build(BuildContext context) {
    final snake_Provider = context.watch<Snake_Provider>();
    List<Serpiente> serpientes = widget.serpientes;
    if (serpientes.length > 0) {
      return SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: GridView.count(
            crossAxisCount: 2, // Adjust for desired number of columns
            children: List.generate(serpientes.length,
                (index) => _buildGridTile(context, serpientes[index])),
          ),
        ),
      );
    }
    return Text(
        "Lista en base de datos vacia. Agregar datos para un correcto funcionamiento");
  }

  Widget _buildGridTile(BuildContext context, Serpiente serpiente) {
    final body_Provider = context.watch<Home_Body_Provider>();
    return GestureDetector(
      onTap: () {
        body_Provider.changedBodyHome(Info_Snake(
          infoSnake: serpiente,
        ));
      },
      child: Card(
        margin: const EdgeInsets.all(10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        clipBehavior: Clip.antiAliasWithSaveLayer,
        elevation: 5,
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(
                  'https://back-1-9ehs.onrender.com/view_image/?imagen=' +
                      serpiente.imagen),
              fit: BoxFit.fill,
              alignment: Alignment.topCenter,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(serpiente.nombre3,
                  style: TextStyle(backgroundColor: Colors.white)),
              SizedBox(
                height: 8,
              )
            ],
          ),
        ),
      ),
    );
  }
}
