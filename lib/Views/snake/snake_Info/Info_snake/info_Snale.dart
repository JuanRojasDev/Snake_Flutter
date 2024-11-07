import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:sqlite_flutter_crud/Providers/snake_class.dart';
import 'package:sqlite_flutter_crud/Providers/snake_provider.dart';

class Info_Snake extends StatefulWidget {
  Serpiente infoSnake;

  Info_Snake({super.key, required this.infoSnake});

  @override
  State<Info_Snake> createState() => _Info_SnakeState();
}

class _Info_SnakeState extends State<Info_Snake> {
  void _set_snake(Serpiente newsnake) {
    setState(() {
      widget.infoSnake = newsnake;
    });
  }

  @override
  Widget build(BuildContext context) {
    final snake_Provider = context.watch<Snake_Provider>();

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Stack(
            children: <Widget>[
              Container(
                width: double.infinity,
                height: 411, // Tamaño ajustado para dispositivos móviles

                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: Offset(0, 3),
                    ),
                  ],
                  image: DecorationImage(
                    image: NetworkImage(
                      widget.infoSnake.imagen,
                    ),
                    fit: BoxFit.cover, // Ajuste para cubrir el contenedor
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    height: 400, // Tamaño ajustado para dispositivos móviles
                    width: 100,
                    child: GridView.count(
                      crossAxisCount:
                          1, // Adjust the number of columns as needed
                      children: List.generate(snake_Provider.serpientes.length,
                          (index) {
                        return _buildGridTile(
                            context, snake_Provider.serpientes[index]);
                      }),
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                textAlign: TextAlign.start,
                widget.infoSnake.nombre3,
                style: TextStyle(
                  fontSize: 44,
                  fontStyle: FontStyle.normal,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                  // Negro oscuro
                ),
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                textAlign: TextAlign.start,
                widget.infoSnake.venenosa ? 'Venenosa' : 'No Venenosa',
                style: TextStyle(
                  fontSize: 22,
                  fontStyle: FontStyle.normal,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                  // Negro oscuro
                ),
              )
            ],
          ),
          SizedBox(height: 16),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
          
            children: [
              Container(
                child: Text(
                  utf8.decode(widget.infoSnake.descripcion.codeUnits),
                  style: TextStyle(
                    fontSize: 18,
                    fontStyle: FontStyle.normal,
                    color: Colors.black87,
                
                    // Negro oscuro
                  ),
                  textAlign: TextAlign.start,
                ),
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                textAlign: TextAlign.start,
                "Taxonomía:",
                style: TextStyle(
                  fontSize: 22,
                  fontStyle: FontStyle.normal,
                  color: const Color(0xFF5DB075),
                  // Negro oscuro
                ),
              )
            ],
          ),
          textBasicStyle("Clase", widget.infoSnake.clase, Colors.black87),
          textBasicStyle("Especie", widget.infoSnake.especie, Colors.black87),
          textBasicStyle("Familia", widget.infoSnake.familia, Colors.black87),
          textBasicStyle("Género", widget.infoSnake.genero, Colors.black87),
          textBasicStyle("Nombre Científico", widget.infoSnake.nombreCientifico,
              Colors.black87),
          textBasicStyle("Es Venenosa", widget.infoSnake.venenosa ? 'Sí' : 'No',
              Colors.black87),
          SizedBox(height: 16),
          Container(
            height: 200, // Tamaño ajustado para dispositivos móviles
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: Offset(0, 3),
                ),
              ],
              image: DecorationImage(
                image: AssetImage(
                    'lib/assets/Villavicencio.jpg'), // Imagen de georeferencia
                fit: BoxFit.cover, // Ajuste para cubrir el contenedor
              ),
            ),
          ),
          textBasicStyle(
              "ID", widget.infoSnake.idSerpiente.toString(), Colors.black87),
          SizedBox(height: 16),
        ],
      ),
    );
  }

  textBasicStyle(String label, String value, Color color) => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Text(
              label + ":",
              style: TextStyle(
                fontSize: 18,
                color: Color(0xFF3366D5),
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 18,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      );
  Widget _buildGridTile(BuildContext context, Serpiente serpiente) {
    return GestureDetector(
      onTap: () {
        _set_snake(serpiente);
        print("2");
      },
      child: Card(
        semanticContainer: true,
        margin: const EdgeInsets.all(10),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
            side: BorderSide(
              color: Colors.white,
              width: 4.0,
            )),
        clipBehavior: Clip.antiAliasWithSaveLayer,
        elevation: 8,
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(serpiente.imagen),
              fit: BoxFit.fill,
              alignment: Alignment.topCenter,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(""),
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
