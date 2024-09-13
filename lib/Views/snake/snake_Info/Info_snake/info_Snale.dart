import 'package:flutter/material.dart';
import 'package:sqlite_flutter_crud/Providers/snake_class.dart';

class Info_Snake extends StatelessWidget {
  final Serpiente infoSnake;

  const Info_Snake({super.key, required this.infoSnake});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: double.infinity,
            height: 200, // Tamaño ajustado para dispositivos móviles
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
                  'https://back-1-9ehs.onrender.com/view_image/?imagen=' +
                      infoSnake.imagen,
                ),
                fit: BoxFit.cover, // Ajuste para cubrir el contenedor
              ),
            ),
          ),
          SizedBox(height: 16),
          Text(
            infoSnake.nombre3,
            style: TextStyle(
              fontSize: 30,
              fontStyle: FontStyle.italic,
              fontWeight: FontWeight.bold,
              color: Colors.black87, // Negro oscuro
            ),
          ),
          SizedBox(height: 16),
          textBasicStyle("Clase", infoSnake.clase, Colors.black87),
          textBasicStyle("Especie", infoSnake.especie, Colors.black87),
          textBasicStyle("Familia", infoSnake.familia, Colors.black87),
          textBasicStyle("Género", infoSnake.genero, Colors.black87),
          textBasicStyle(
              "Nombre Científico", infoSnake.nombreCientifico, Colors.black87),
          textBasicStyle(
              "Es Venenosa", infoSnake.venenosa ? 'Sí' : 'No', Colors.black87),
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
        ],
      ),
    );
  }

  Row textBasicStyle(String label, String value, Color color) => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Text(
              label + ":",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: color,
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
}
