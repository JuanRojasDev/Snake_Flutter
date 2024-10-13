import 'dart:typed_data';

import 'package:image_picker/image_picker.dart';

class SnakeReportDefault {
  final String description;
  final String name;
  final bool venomous;
  Uint8List? image;

  SnakeReportDefault({
    required this.description,
    required this.name,
    required this.venomous,
    this.image
  });

  factory SnakeReportDefault.fromJson(Map<String, dynamic> json) {
    return SnakeReportDefault(
      description: json['description'] as String,
      name: json['name'] as String,
      venomous: json['venomous'] as bool,
    );
  }
}