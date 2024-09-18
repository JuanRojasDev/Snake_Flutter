import 'package:flutter/material.dart';

class SnakePublicCard extends StatelessWidget {
  final String titulo;
  final String imgUrl;
  final DateTime dateTime;
  final int coments;
  final int likes;
  final String resumen;

  const SnakePublicCard({
    super.key,
    required this.titulo,
    required this.imgUrl,
    required this.dateTime,
    required this.coments,
    required this.likes,
    required this.resumen,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          children: [
            // Imagen de fondo
            Positioned.fill(
              child: Image.network(
                imgUrl,
                fit: BoxFit.cover,
              ),
            ),
            // Degradado negro para el texto
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                height: 100,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withOpacity(0.7),
                    ],
                  ),
                ),
              ),
            ),
            // Texto en la parte inferior
            Positioned(
              bottom: 20,
              left: 20,
              right: 20,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    titulo,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    resumen,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.8),
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
            // Íconos de comentarios y likes
            Positioned(
              top: 10,
              right: 10,
              child: Row(
                children: [
                  Icon(Icons.thumb_up, color: Colors.white),
                  SizedBox(width: 5),
                  Text(
                    likes.toString(),
                    style: TextStyle(color: Colors.white),
                  ),
                  SizedBox(width: 15),
                  Icon(Icons.comment, color: Colors.white),
                  SizedBox(width: 5),
                  Text(
                    coments.toString(),
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
