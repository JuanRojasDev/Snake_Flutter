import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:loading_indicator/loading_indicator.dart';
import 'dart:convert';
import 'package:sqlite_flutter_crud/Authtentication/login.dart';
import 'package:sqlite_flutter_crud/JsonModels/users.dart';
import 'package:sqlite_flutter_crud/SQLite/sqlite.dart';
import 'package:flutter/gestures.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final username = TextEditingController();
  final email = TextEditingController();
  final password = TextEditingController();
  final confirmPassword = TextEditingController();
  final birthDateController = TextEditingController();
  DateTime? selectedDate;

  bool isVisible = false;
  bool isVisibleConfirm = false;
  bool isSignUpTrue = false;
  bool _acceptTerms = false;
  final db = DatabaseHelper();
  final formKey = GlobalKey<FormState>();

  // Función para mostrar los términos y condiciones
  void _showTermsAndConditions() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Términos y condiciones'),
          content: SingleChildScrollView(
            child: Text(
              'Aquí puedes agregar los términos y condiciones...',
            ),
          ),
          actions: [
            TextButton(
              child: Text('Aceptar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  signUp() async {
    if (formKey.currentState!.validate()) {
      if (!_acceptTerms) {
        setState(() {
          isSignUpTrue = true;
        });
        return;
      }

      var user = Users(
        usrName: username.text,
        usrEmail: email.text,
        usrPassword: password.text,
        usrDob: selectedDate?.toIso8601String(),
      );
      // Crear el body de la solicitud
      final Map<String, String> body = {
        "nombres": user.usrName,
        "correo": user.usrEmail,
        "direccion": "string",
        "contraseña": user.usrPassword,
        "apellido": "null",
        "fecha_n": user.usrDob ?? '', // Aquí corregimos la fecha
        "rol": "null",
        "edad": '0'
      };

      // Realizar la solicitud POST al servidor
      var url =
          Uri.parse('https://back-production-0678.up.railway.app/users/create');

      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return Overlay(
            initialEntries: [
              OverlayEntry(
                builder: (context) => Center(
                  child: LoadingIndicator(
                    indicatorType: Indicator.ballPulse,
                    colors: const [
                      Color.fromARGB(255, 36, 235, 18),
                      Color.fromARGB(255, 25, 224, 128),
                      Color.fromARGB(255, 59, 235, 150),
                      Color.fromARGB(255, 116, 241, 181)
                    ],
                    pathBackgroundColor: Color.fromARGB(255, 138, 209, 5),
                  ),
                ),
              ),
            ],
          );
        },
      );

      var response = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(body),
      );

      // Verificar el código de estado de la respuesta
      if (response.statusCode == 200) {
        // El usuario se registró exitosamente
        if (!mounted) return;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );
      } else {
        // El registro no se pudo completar
        Navigator.pop(context);
        setState(() {
          isSignUpTrue = true;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  const SizedBox(height: 10), // Espacio desde la parte superior
                  const Center(
                    child: Text(
                      "Registrarse",
                      style: TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Input de nombre de usuario
                  _buildTextField(username, "Nombre de usuario", Icons.person),
                  // Input de correo electrónico
                  _buildTextField(email, "Correo electrónico", Icons.email),
                  // Input de contraseña
                  _buildPasswordField(password, "Contraseña", isVisible),
                  // Input de confirmar contraseña
                  _buildPasswordField(
                      confirmPassword, "Confirmar contraseña", isVisibleConfirm,
                      confirmPasswordCheck: true),
                  // Input de fecha de nacimiento
                  _buildDatePicker(),
                  const SizedBox(height: 10),
                  // Checkbox de términos y condiciones
                  Row(
                    children: [
                      Checkbox(
                        value: _acceptTerms,
                        activeColor:
                            const Color(0xFF5DB075), // Color personalizado
                        onChanged: (bool? value) {
                          setState(() {
                            _acceptTerms = value ?? false;
                          });
                        },
                      ),
                      RichText(
                        text: TextSpan(
                          text: 'He leído y acepto los ',
                          style: const TextStyle(color: Colors.black),
                          children: [
                            TextSpan(
                              text: 'términos',
                              style: const TextStyle(color: Color(0xFF5DB075)),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  _showTermsAndConditions();
                                },
                            ),
                            const TextSpan(
                              text: ' y ',
                              style: TextStyle(color: Colors.black),
                            ),
                            TextSpan(
                              text: 'condiciones',
                              style: const TextStyle(color: Color(0xFF5DB075)),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  _showTermsAndConditions();
                                },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  // Botón de registro
                  Container(
                    height: 55,
                    width: MediaQuery.of(context).size.width * .9,
                    decoration: BoxDecoration(
                      borderRadius:
                          BorderRadius.circular(27.5), // Hace el botón circular
                      color: const Color(0xFF5DB075),
                    ),
                    child: TextButton(
                      onPressed: signUp,
                      child: const Text(
                        "Registrarse",
                        style: TextStyle(color: Colors.white, fontSize: 18.0),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("¿Ya tienes una cuenta?"),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text(
                          "Iniciar Sesión",
                          style: TextStyle(
                              color: Color(
                                  0xFF5DB075)), // Cambia el color del texto
                        ),
                      ),
                    ],
                  ),
                  isSignUpTrue
                      ? const Text(
                          "El registro no se pudo completar, intente nuevamente",
                          style: TextStyle(color: Colors.red),
                        )
                      : const SizedBox(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Métodos para crear los widgets de los campos
  Widget _buildTextField(
      TextEditingController controller, String hint, IconData icon) {
    return Container(
      margin: const EdgeInsets.all(8),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: const Color(0xFFF6F6F6).withOpacity(0.8),
        border: Border.all(color: const Color(0xFFBFBFBF), width: 0.4),
      ),
      child: TextFormField(
        controller: controller,
        validator: (value) {
          if (value!.isEmpty) {
            return "$hint es requerido";
          }
          return null;
        },
        decoration: InputDecoration(
          icon: Icon(icon),
          border: InputBorder.none,
          hintText: hint,
          hintStyle: const TextStyle(color: Color(0xFFBFBFBF)),
        ),
      ),
    );
  }

  Widget _buildPasswordField(
      TextEditingController controller, String hint, bool visibility,
      {bool confirmPasswordCheck = false}) {
    return Container(
      margin: const EdgeInsets.all(8),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: const Color(0xFFF6F6F6).withOpacity(0.8),
        border: Border.all(color: const Color(0xFFBFBFBF), width: 0.4),
      ),
      child: TextFormField(
        controller: controller,
        obscureText: !visibility,
        validator: (value) {
          if (value!.isEmpty) {
            return "$hint es requerido";
          }
          if (confirmPasswordCheck && value != password.text) {
            return "Las contraseñas no coinciden";
          }
          return null;
        },
        decoration: InputDecoration(
          icon: const Icon(Icons.lock),
          border: InputBorder.none,
          hintText: hint,
          hintStyle: const TextStyle(color: Color(0xFFBFBFBF)),
          suffixIcon: IconButton(
            icon: Icon(visibility ? Icons.visibility : Icons.visibility_off),
            onPressed: () {
              setState(() {
                if (confirmPasswordCheck) {
                  isVisibleConfirm = !isVisibleConfirm;
                } else {
                  isVisible = !isVisible;
                }
              });
            },
          ),
        ),
      ),
    );
  }

  Widget _buildDatePicker() {
    return GestureDetector(
      onTap: () async {
        DateTime? picked = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(1900),
          lastDate: DateTime.now(),
        );
        if (picked != null) {
          setState(() {
            selectedDate = picked;
            birthDateController.text = "${picked.toLocal()}".split(' ')[0];
          });
        }
      },
      child: AbsorbPointer(
        child: Container(
          margin: const EdgeInsets.all(8),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: const Color(0xFFF6F6F6).withOpacity(0.8),
            border: Border.all(color: const Color(0xFFBFBFBF), width: 0.4),
          ),
          child: TextFormField(
            controller: birthDateController,
            decoration: const InputDecoration(
              icon: Icon(Icons.calendar_today),
              border: InputBorder.none,
              hintText: "Fecha de nacimiento",
              hintStyle: TextStyle(color: Color(0xFFBFBFBF)),
            ),
          ),
        ),
      ),
    );
  }
}
