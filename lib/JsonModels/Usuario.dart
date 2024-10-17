class Usuario {
  final int id; // Asegúrate de que este campo esté presente
  String nombres;
  final String correo;
  final String? direccion;
  final String? contrasena; // Renombrado para mantener la consistenciacls
  final String? apellido;
  final String fechaN;
  final int? edad;
  final String? token;
  String? imagen;
  String? descripcion;
  String? imagen_fondo;

  Usuario({
    required this.id, // Agregado a los parámetros del constructor
    required this.nombres,
    required this.correo,
    this.direccion,
    this.contrasena,
    this.apellido,
    required this.fechaN,
    this.edad,
    this.token,
    this.imagen,
    this.descripcion,
    this.imagen_fondo,
  });

  factory Usuario.fromJson(Map<String, dynamic> json) {
    return Usuario(
      id: json['data']['id'] ??
          '', // Asegúrate de que el JSON contenga el id y proporciona un valor por defecto
      nombres: json['data']['nombres'] ??
          '', // Proporciona valor por defecto si es null
      correo: json['data']['correo'] ??
          '', // Proporciona valor por defecto si es null
      direccion: json['data']['direccion'], // Permite null
      contrasena: json['data']['contraseña'], // Permite null
      apellido: json['data']['apellido'] ??
          '', // Proporciona valor por defecto si es null
      fechaN: json['data']['fecha_n'] ??
          '', // Proporciona valor por defecto si es null
      edad: json['data']['edad'], // Permite null
      imagen: json['data']['imagen'], // Permite null
      token: json['access_token'] ??
          '', // Proporciona valor por defecto si es null
      descripcion: json['data']['Descripcion'], // Permite null
      imagen_fondo: json['data']['imagen_fondo'], // Permite null
    );
  }
}
