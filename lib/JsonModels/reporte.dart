import 'package:sqlite_flutter_crud/JsonModels/Usuario.dart';

class Reporte{
  final int? reportId;
  final String? titulo;
  final String? descripcion;

  Reporte({
    this.reportId,
    this.titulo,
    this.descripcion,
  });

  factory Reporte.fromJson(Map<String, dynamic> json) {
    return Reporte(
      titulo: json['titulo'],
      descripcion: json['descripcion'],
    );
  }
}
