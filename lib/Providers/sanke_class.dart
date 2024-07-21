class Serpiente {
  int idSerpiente;
  String clase;
  String familia;
  bool venenosa;
  String reino;
  String nombre3;
  String nombreCientifico;
  String especie;
  String genero;
  String imagen;

  Serpiente({
    required this.idSerpiente,
    required this.clase,
    required this.familia,
    required this.venenosa,
    required this.reino,
    required this.nombre3,
    required this.nombreCientifico,
    required this.especie,
    required this.genero,
    required this.imagen,
  });

  factory Serpiente.fromJson(Map<String, dynamic> json) {
    return Serpiente(
      idSerpiente: json['idSerpiente'] as int,
      clase: json['clase'] as String,
      familia: json['familia'] as String,
      venenosa: json['venenosa'] as bool,
      reino: json['reino'] as String,
      nombre3: json['nombre3'] as String,
      nombreCientifico: json['nombreCientifico'] as String,
      especie: json['especie'] as String,
      genero: json['genero'] as String,
      imagen: json['imagen'] as String,
    );
  }

  
}