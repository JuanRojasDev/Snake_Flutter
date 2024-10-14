import 'dart:typed_data';

import 'package:image_picker/image_picker.dart';

class SnakeReportDefault {
  final String? description;
  final String? name;
  final bool? venomous;
  final bool issnake;
  Uint8List? image;

  SnakeReportDefault({
    this.description,
    this.name,
    this.venomous,
    required this.issnake,
    this.image
  });

  factory SnakeReportDefault.fromJson(Map<String, dynamic> json) {
    return SnakeReportDefault(
      description: json['description'] ?? '', // Valor por defecto si no existe
      name: json['name'] ?? '', // Valor por defecto si no existe
      venomous: json['venomous'] ?? false, // Valor por defecto si no existe
      issnake: json['issnake'] as bool,
    );
  }
}