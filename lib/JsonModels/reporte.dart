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
  Reporte( {
    this.reportId,
    this.titulo,
    this.descripcion,
    this.imagen,
    this.serpientes_id_serpientes,
    this.created_at,
    this.usuario_id_usuario,
    this.imageBytes,
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
    );
  }
}
