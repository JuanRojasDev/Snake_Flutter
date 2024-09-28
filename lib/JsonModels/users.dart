class Users {
  final int? usrId;
  final String usrName;
  final String usrEmail;
  final String usrPassword;
  final String? usrDob;
  final String? token;
  final String? descripcion;
  final String? imagen_fondo;

  Users({
    this.usrId,
    required this.usrName,
    required this.usrEmail,
    required this.usrPassword,
    this.usrDob,
    this.token,
    this.descripcion,
    this.imagen_fondo,
  });

  factory Users.fromMap(Map<String, dynamic> json) => Users(
    usrId: json["idUsuario"],
    usrName: json["nombres"],
    usrEmail: json["correo"],
    usrPassword: json["contraseña"],
    usrDob: json["fecha_n"],
    descripcion: json["descripcion"],
    imagen_fondo: json["imagen_fondo"],
  );

  Map<String, dynamic> toMap() => {
    "idUsuario": usrId,
    "nombres": usrName,
    "correo": usrEmail,
    "usrPassword": usrPassword,
    "fecha_n": usrDob,
    "descripcion": descripcion,
    "imagen_fondo": imagen_fondo,
  };
}