import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:loading_indicator/loading_indicator.dart';
import 'dart:convert';
import 'package:sqlite_flutter_crud/Authtentication/login.dart';
import 'package:sqlite_flutter_crud/JsonModels/users.dart';
import 'package:sqlite_flutter_crud/SQLite/sqlite.dart';

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
  final db = DatabaseHelper();
  final formKey = GlobalKey<FormState>();

  signUp() async {
    if (formKey.currentState!.validate()) {
      var user = Users(
        usrName: username.text,
        usrEmail: email.text,
        usrPassword: password.text,
        usrDob: selectedDate?.toIso8601String(),
      );
      //crear el body de la solicitud
      final Map<String, String> body = {
        "nombres": user.usrName,
        "correo": user.usrEmail,
        "direccion": "string",
        "contraseña": user.usrPassword,
        "apellido": "null",
        "fecha_n": 'user.usrDob',
        "rol": "null",
        "edad": '0'
      };
      // Realizar la solicitud POST al servidor
      var url = Uri.parse('https://back-1-9ehs.onrender.com/users/create');
      //var url = Uri.parse('http://127.0.0.1:8000/users/create');

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
                  Container(
                    margin: const EdgeInsets.all(8),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Color(0xFFF6F6F6).withOpacity(0.8),
                      border: Border.all(
                          color: Color(0xFFBFBFBF),
                          width: 0.4), // Borde más grueso
                    ),
                    child: TextFormField(
                      controller: username,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "El nombre de usuario es requerido";
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                        icon: Icon(Icons.person),
                        border: InputBorder.none,
                        hintText: "Nombre de usuario",
                        hintStyle: TextStyle(
                            color: Color(
                                0xFFBFBFBF)), // Color del icono // Color del texto del hint
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.all(8),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Color(0xFFF6F6F6)
                          .withOpacity(0.8), // Color llamativo para el fondo
                      border: Border.all(
                          color: Color(0xFFBFBFBF),
                          width: 0.4), // Borde más grueso
                    ),
                    child: TextFormField(
                      controller: email,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "El correo electrónico es requerido";
                        } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+')
                            .hasMatch(value)) {
                          return "Ingrese un correo electrónico válido";
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        icon: Icon(Icons.email),
                        border: InputBorder.none,
                        hintText: "Correo electrónico",
                        hintStyle: TextStyle(
                            color: Color(
                                0xFFBFBFBF)), // Color del icono // Color del texto del hint
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.all(8),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Color(0xFFF6F6F6)
                          .withOpacity(0.8), // Color llamativo para el fondo
                      border: Border.all(
                          color: Color(0xFFBFBFBF),
                          width: 0.4), // Borde más grueso
                    ),
                    child: TextFormField(
                      controller: password,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "La contraseña es requerida";
                        } else if (value.length < 6) {
                          return "La contraseña debe tener al menos 6 caracteres";
                        }
                        return null;
                      },
                      obscureText: !isVisible,
                      decoration: InputDecoration(
                        icon: Icon(Icons.lock),
                        border: InputBorder.none,
                        hintText: "Contraseña",
                        hintStyle: TextStyle(
                            color: Color(
                                0xFFBFBFBF)), // Color del icono // Color del texto del hint
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              isVisible = !isVisible;
                            });
                          },
                          icon: Icon(
                            isVisible ? Icons.visibility : Icons.visibility_off,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.all(8),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Color(0xFFF6F6F6)
                          .withOpacity(0.8), // Color llamativo para el fondo
                      border: Border.all(
                          color: Color(0xFFBFBFBF),
                          width: 0.4), // Borde más grueso
                    ),
                    child: TextFormField(
                      controller: confirmPassword,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Confirme su contraseña";
                        } else if (value != password.text) {
                          return "Las contraseñas no coinciden";
                        }
                        return null;
                      },
                      obscureText: !isVisibleConfirm,
                      decoration: InputDecoration(
                        icon: Icon(Icons.lock),
                        border: InputBorder.none,
                        hintText: "Confirmar contraseña",
                        hintStyle: TextStyle(
                            color: Color(
                                0xFFBFBFBF)), //Color del icono // Color del texto del hint
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              isVisibleConfirm = !isVisibleConfirm;
                            });
                          },
                          icon: Icon(
                            isVisibleConfirm
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.all(8),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Color(0xFFF6F6F6)
                          .withOpacity(0.8), // Color llamativo para el fondo
                      border: Border.all(
                          color: Color(0xFFBFBFBF),
                          width: 0.4), // Borde más grueso
                    ),
                    child: TextFormField(
                      controller: birthDateController,
                      decoration: InputDecoration(
                        icon: Icon(Icons.calendar_today),
                        border: InputBorder.none,
                        hintText: "Fecha de Nacimiento",
                        hintStyle: TextStyle(
                            color:
                                Color(0xFFBFBFBF)), // Color del texto del hint
                      ),
                      onTap: () async {
                        DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(1900),
                          lastDate: DateTime(2100),
                        );

                        if (pickedDate != null) {
                          setState(() {
                            birthDateController.text =
                                "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
                          });
                        }
                      },
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    height: 55,
                    width: MediaQuery.of(context).size.width * .9,
                    decoration: BoxDecoration(
                      borderRadius:
                          BorderRadius.circular(27.5), // Hace el botón circular
                      color: Color(0xFF5DB075),
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
}
