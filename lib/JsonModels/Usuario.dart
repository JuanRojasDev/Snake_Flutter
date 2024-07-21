class Usuario {
  
  final String nombres;
  final String correo;
  final String? direccion;
  final String? contrasena;
  final String? apellido;
  final String fechaN;
  final String? rol;
  final int? edad;
  final String? Token;

  Usuario({
    required this.nombres,
    required this.correo,
    this.direccion,
    this.contrasena,
    this.apellido,
    required this.fechaN,
    this.rol,
    this.edad,
    this.Token,
  });

  factory Usuario.fromJson(Map<String, dynamic> json) {
    return Usuario(
      nombres: json['data']['nombres'],
      correo: json['data']['correo'],
      direccion: json['data']['direccion'],
      contrasena: json['data']['contraseña'],
      apellido: json['data']['apellido'],
      fechaN: json['data']['fecha_n'],
      rol: json['data']['rol'],
      edad: json['data']['edad'],
      Token: json['access_token']
    );
  }

  


}