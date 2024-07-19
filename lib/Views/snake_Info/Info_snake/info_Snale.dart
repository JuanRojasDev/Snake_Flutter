import 'package:flutter/material.dart';

class Info_Snake extends StatelessWidget {
  final int infoInt; 
  final String nameSnake;
  final String imgUrl;

  const Info_Snake({super.key, required this.infoInt, required this.nameSnake, required this.imgUrl});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
           
          child: Image(image: NetworkImage(imgUrl)),
            width: 900,
            height: 250,),
            SizedBox(height: 15,),
        Text(nameSnake),
        Text(infoInt.toString()),
      ],
    );
  }
}