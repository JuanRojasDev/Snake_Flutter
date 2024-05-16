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
        usrId: json["usrId"],
        usrName: json["usrName"],
        usrEmail: json["usrEmail"],
        usrPassword: json["usrPassword"],
        usrDob: json["usrDob"],
      );

  Map<String, dynamic> toMap() => {
        "usrId": usrId,
        "usrName": usrName,
        "usrEmail": usrEmail,
        "usrPassword": usrPassword,
        "usrDob": usrDob,
      };

  Map<String, dynamic> toJson() {
    // Add a throw statement to ensure the method doesn't complete normally
    throw UnimplementedError();
  }
}
