import 'dart:typed_data';

import 'package:sqlite_flutter_crud/JsonModels/Usuario.dart';



class Reporte {
  final int? reportId;
  final String? titulo;
  final String? descripcion;
  final String? imagen;
  final int? serpientes_id_serpientes;
  final String? created_at;
  final int? usuario_id_usuario;
  final Uint8List? imageBytes;
  final String? usuario_nombre; // Almacenamos solo el nombre del usuario
  final int? usuario_id; 
  final String? imagenUsuario;      // Almacenamos solo el ID del usuario

  Reporte({
    this.reportId,
    this.titulo,
    this.descripcion,
    this.imagen,
    this.serpientes_id_serpientes,
    this.created_at,
    this.usuario_id_usuario,
    this.imageBytes,
    this.usuario_nombre,
    this.usuario_id,
    this.imagenUsuario,
  });

  factory Reporte.fromJson(Map<String, dynamic> json) {
    return Reporte(
      titulo: json['titulo'],
      descripcion: json['descripcion'],
      imagen: json['imagen'],
      reportId: json['idReporte'],
      serpientes_id_serpientes: json['serpientes_id_serpientes'],
      created_at: json['created_at'],
      usuario_id_usuario: json['usuario_id_usuario'],
      usuario_nombre: json['usuario']['nombre'], // Extraemos el nombre del usuario
      usuario_id: json['usuario']['idUsuario'], // Extraemos el ID del usuario
      imagenUsuario:  json['usuario']['imagen'],
    );
  }

  Map<String, dynamic> toMap() => {
    "titulo": titulo,
    "descripcion": descripcion,
    "imagen": imagen,
    "reportId": reportId,
    "serpientes_id_serpientes": serpientes_id_serpientes,
    "created_at": created_at,
    "usuario_id_usuario": usuario_id_usuario,
    "usuario_nombre": usuario_nombre,
    "usuario_id": usuario_id,
    "imagenUsuario": imagenUsuario,
  };
}