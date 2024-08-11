import 'package:flutter/material.dart';

class snake_public_card extends StatelessWidget {
  final String titulo;
  final String imgUrl;
  final DateTime dateTime;
  final int coments;
  final int likes;
  final String resumen;

  const snake_public_card({super.key, required this.titulo, required this.imgUrl, required this.dateTime, required this.coments, required this.likes, required this.resumen});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 270,
      decoration: BoxDecoration(
        color: Colors.amberAccent,
      ),
      child: Column(
        children: [
          Container(
             
            child: Image(image: NetworkImage(imgUrl)),
              width: 900,
              height: 250,),
              SizedBox(height: 15,),
          Text(titulo),
          Text(resumen),
          Row(
            children: [
              Text(dateTime.toString()),Text(likes.toString()), Text(coments.toString())
            ],
          )
          
        ],
      ),
    );
  }
}