// Aquí primero creamos el modelo JSON de usuarios
// Para analizar estos datos JSON, haga
//

class Users {
  final int? usrId;
  final String usrName;
  final String usrEmail;
  final String usrPassword;
  final String? usrDob;

  Users({
    this.usrId,
    required this.usrName,
    required this.usrEmail,
    required this.usrPassword,
    this.usrDob,
  });

  factory Users.fromMap(Map<String, dynamic> json) => Users(
        usrId: json["idUsuario"],
        usrName: json["nombres"],
        usrEmail: json["correo"],
        usrPassword: json["contraseña"],
        usrDob: json["fecha_n"],
      );

  Map<String, dynamic> toMap() => {
        "idUsuario": usrId,
        "nombres": usrName,
        "correo": usrEmail,
        "usrPassword": usrPassword,
        "fecha_n": usrDob,
      };


}
