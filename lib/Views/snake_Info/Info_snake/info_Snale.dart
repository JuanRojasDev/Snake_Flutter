import 'package:flutter/material.dart';
import 'package:sqlite_flutter_crud/Providers/snake_class.dart';

class Info_Snake extends StatelessWidget {
  final Serpiente infoSnake;

  const Info_Snake({super.key, required this.infoSnake});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            child: Image(
                image: NetworkImage(
                    'https://back-1-9ehs.onrender.com/view_image/?imagen=' +
                        infoSnake.imagen),
                fit: BoxFit.fill,
                alignment: Alignment.topCenter),
            width: 900,
            height: 250,
            decoration: BoxDecoration(border: Border.all(color: Colors.black)),
          ),
          Text(
            infoSnake.nombre3,
            style: TextStyle(
                fontSize: 30,
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.bold),
          ),
          textBasicStyle("Clase", infoSnake.clase),
          textBasicStyle("Especie", infoSnake.especie),
          textBasicStyle("Familia", infoSnake.familia),
          textBasicStyle("Genero", infoSnake.genero),
          textBasicStyle("Nombre Cientifico", infoSnake.nombreCientifico),
          textBasicStyle("Es Venenosa", infoSnake.venenosa ? 'Si' : 'No'),
        ],
      ),
    );
  }

  Row textBasicStyle(String text1, String text2) => Row(
        children: [
          Text(
            text1 + " : ",
            style: TextStyle(fontSize: 20),
          ),
          Text(
            text2,
            style: TextStyle(fontSize: 20),
          ),
        ],
      );
}
