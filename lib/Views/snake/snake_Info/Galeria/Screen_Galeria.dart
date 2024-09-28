import 'dart:convert';

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
    BuildContext context,
  ) {
    final snake_Provider = context.watch<Snake_Provider>();

    if (!snake_Provider.fetcdata) {
      snake_Provider.fectSnakesPoison(true);
      snake_Provider.fetcdata = true;
    }

    if (snake_Provider.serpientes.length > 0) {
      return SafeArea(
          child: Column(
        children: [
          Row(
            children: [
              GestureDetector(
                child: Text("Venenosas "),
                onTap: () {
                  snake_Provider.fectSnakesPoison(true);
                },
              ),
              GestureDetector(
                child: Text(" No Venenosas"),
                onTap: () {
                  snake_Provider.fectSnakesPoison(false);
                },
              )
            ],
            mainAxisAlignment: MainAxisAlignment.center,
          ),
          Expanded(
            child: GridView.count(
              crossAxisCount: 2, // Adjust the number of columns as needed
              children:
                  List.generate(snake_Provider.serpientes.length, (index) {
                return _buildGridTile(
                    context, snake_Provider.serpientes[index]);
              }),
            ),
          ),
        ],
      ));
    }
    return Text(
        "Lista en base de datos vacia. Agregar datos para un correcto funcionamiento");
  }

  /* lista grid
   Expanded(
   child: GridView.count(
  crossAxisCount: 2, // Adjust the number of columns as needed
    children: List.generate(snake_Provider.serpientes.length, (index) {
      return _buildGridTile(context, snake_Provider.serpientes[index]);
    }),
  ),
),

lista horizontal

          Expanded(
            child: ListView.builder(
              scrollDirection: Axis.vertical,
              itemCount: snake_Provider.serpientes.length,
              itemBuilder: (context, index) {
                return _buildGridTile(context, snake_Provider.serpientes[index]);
              },
            ),
          ),

*/

  Widget _buildListItem(BuildContext context, Serpiente serpiente) {
    final body_Provider = context.watch<Home_Body_Provider>();
    return GestureDetector(
      onTap: () {
        // Replace with your tap handler logic

        body_Provider.changedBodyHome(Info_Snake(infoSnake: serpiente));
      },
      child: Container(
        // Set a width to avoid excessive stretching
        width: MediaQuery.of(context).size.width * 0.75, // Adjust as needed
        // Adjust the height as needed // Adjust as needed
        child: Card(
          margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 40),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          clipBehavior: Clip.antiAliasWithSaveLayer,
          elevation: 5,
          child: Stack(
            // Use a Stack for layering image and text
            children: [
              // Background image filling the container
              Container(
                width: 400,
                height: 600,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(
                      serpiente.imagen,
                    ),

                    fit: BoxFit.contain, // Cover the entire container
                  ),
                ),
              ),
              // Text positioned at the bottom with some padding
              Positioned(
                bottom: 10, // Adjust padding as needed
                left: 10, // Adjust padding as needed
                child: Text(
                  serpiente.nombre3,
                  style: TextStyle(
                    color: Colors.white,
                    backgroundColor: Colors.black
                        .withOpacity(0.5), // Semi-transparent background
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
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
