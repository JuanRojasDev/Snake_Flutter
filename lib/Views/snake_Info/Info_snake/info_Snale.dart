import 'package:flutter/material.dart';
import 'package:sqlite_flutter_crud/Providers/sanke_class.dart';

class Info_Snake extends StatelessWidget {
  final Serpiente infoSnake; 


  const Info_Snake({super.key, required this.infoSnake});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
           
          child: Image(image: NetworkImage('https://back-1-9ehs.onrender.com/view_image/?imagen='+infoSnake.imagen)),
            width: 900,
            height: 250,),
            SizedBox(height: 15,),
        Text(infoSnake.nombre3),
        Text(infoSnake.clase),
        Text(infoSnake.especie),
        Text(infoSnake.familia),
        Text(infoSnake.genero),
        Text(infoSnake.nombreCientifico),
        Text(infoSnake.venenosa.toString()),

      ],
    );
  }
}