class Usuario {
   String nombres;
  final String correo;
  final String? direccion;
  final String? contrasena;
  final String? apellido;
  final String fechaN;
  final int? edad;
  final String? Token;
   String? imagen;
   String? descripcion;
   String? imagen_fondo;

  Usuario({
    required this.nombres,
    required this.correo,
    this.direccion,
    this.contrasena,
    this.apellido,
    required this.fechaN,
    this.edad,
    this.Token,
    this.imagen,
    this.descripcion,
    this.imagen_fondo,
  });

  factory Usuario.fromJson(Map<String, dynamic> json) {
    return Usuario(
      nombres: json['data']['nombres'],
      correo: json['data']['correo'],
      direccion: json['data']['direccion'],
      contrasena: json['data']['contraseña'],
      apellido: json['data']['apellido'],
      fechaN: json['data']['fecha_n'],
      edad: json['data']['edad'],
      imagen: json['data']['imagen'],
      Token: json['access_token'],
      descripcion: json['data']['Descripcion'],
      imagen_fondo: json['data']['imagen_fonodo'],
    );
  }
}