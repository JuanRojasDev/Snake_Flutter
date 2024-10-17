import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:loading_indicator/loading_indicator.dart';
import 'package:provider/provider.dart';
import 'package:sqlite_flutter_crud/Authtentication/signup.dart';
import 'package:sqlite_flutter_crud/JsonModels/Usuario.dart';
import 'package:sqlite_flutter_crud/Providers/Home_Body_provider.dart';
import 'package:sqlite_flutter_crud/Providers/user_provider.dart';
import 'dart:convert';
import 'home.dart';
import 'package:flutter/gestures.dart'; // Import necesario

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isVisible = false;
  bool _isLoginTrue = false;
  bool _acceptTerms = false;
  final storage = FlutterSecureStorage();

  Future<void> _login() async {
    final String url =
        'https://back-production-0678.up.railway.app/users/login'; // server ip

    final Map<String, String> body = {
      'identifier': _usernameController.text,
      'password': _passwordController.text,
    };

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Center(
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
        );
      },
    );

    final Map<String, String> headers = {'Content-Type': 'application/json'};

    final response = await http.post(Uri.parse(url),
        body: jsonEncode(body), headers: headers);

    if (response.statusCode == 200) {
      // Inicio de sesión exitoso, navegar a la siguiente pantalla (home.dart)
      Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      Usuario user = Usuario.fromJson(jsonResponse);
      String? token =  user.token;
      print("este es el token"+token!);
      await storage.write(key: 'jwt', value: user.token);

      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => HomeScreen(
                    usuario: user,
                  ))); // Navegar a home.dart
    } else {
      // Mostrar un mensaje de error al usuario
      Navigator.pop(context);
      setState(() {
        _isLoginTrue = true;
      });
    }
  }

  Future<void> _continueAsGuest() async {
    // Navegar a la pantalla de inicio como invitado (home.dart)
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => HomeScreen(
                  usuario: Usuario(
                      nombres: "Invitado",
                      correo: "guest@example.com",
                      fechaN: "fechaN",
                      descripcion: "Default",
                      imagen_fondo: "",
                      id: 1),
                ))); // Navegar a home.dart
  }

  void _showTermsAndConditions() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Términos y Condiciones'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Aquí van los términos y condiciones...'),
              ],
            ),
          ),
          actions: <Widget>[
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start, // Alineación superior
            children: [
              const SizedBox(height: 180), // Espacio desde la parte superior
              const Center(
                child: Text(
                  "Iniciar Sesión",
                  style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
              ),
              const SizedBox(height: 20), // Aumenta este valor para más espacio
              Container(
                margin: const EdgeInsets.all(8),
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Color(0xFFF6F6F6)
                      .withOpacity(0.8), // Color llamativo para el fondo
                  border: Border.all(
                      color: Color(0xFFBFBFBF), width: 0.4), // Borde más grueso
                ),
                child: TextField(
                  controller: _usernameController,
                  decoration: const InputDecoration(
                    icon: Icon(
                      Icons.email,
                    ), // Color del icono
                    border: InputBorder.none,
                    hintText: "Correo Electrónico o Nombre de Usuario",
                    hintStyle: TextStyle(
                        color: Color(
                            0xFFBFBFBF)), // Color del icono // Color del texto del hint
                  ),
                  style: const TextStyle(
                      color: Colors.black), // Color del texto de entrada
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
                      color: Color(0xFFBFBFBF), width: 0.4), // Borde más grueso
                ),
                child: TextField(
                  controller: _passwordController,
                  obscureText: !_isVisible,
                  decoration: InputDecoration(
                    icon: const Icon(Icons.lock),
                    border: InputBorder.none,
                    hintText: "Contraseña",
                    hintStyle: TextStyle(
                        color: Color(
                            0xFFBFBFBF)), // Color del icono // Color del texto del hint
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          _isVisible = !_isVisible;
                        });
                      },
                      icon: Icon(
                          _isVisible ? Icons.visibility : Icons.visibility_off,
                          color: Color(0xFFBFBFBF)),
                    ),
                  ),
                ),
              ),
              Container(
                height: 55,
                width: MediaQuery.of(context).size.width * .9,
                decoration: BoxDecoration(
                  borderRadius:
                      BorderRadius.circular(27.5), // Hace el botón circular
                  color: Color(0xFF5DB075),
                ),
                child: TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: Color(0xFF5DB075),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(27.5),
                    ),
                  ),
                  onPressed: _login,
                  child: const Text(
                    "Iniciar Sesión",
                    style: TextStyle(color: Colors.white, fontSize: 18.0),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("No tienes cuenta aún?"),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const SignUp()));
                    },
                    child: const Text(
                      "Registrarse",
                      style: TextStyle(
                          color:
                              Color(0xFF5DB075)), // Cambia el color del texto
                    ),
                  ),
                ],
              ),
              _isLoginTrue
                  ? Center(
                      child: const Text(
                        "Nombre de usuario o contraseña incorrectos",
                        style: TextStyle(color: Colors.red),
                      ),
                    )
                  : const SizedBox(height: 20),
              const Divider(
                height: 20,
                thickness: 2,
                color: Colors.black,
                indent: 20,
                endIndent: 20,
              ),
              const SizedBox(height: 20),
              const Center(
                child: Text("O iniciar sesión con:"),
              ),
              const SizedBox(height: 10),
              Container(
                height: 55,
                width: MediaQuery.of(context).size.width * .9,
                decoration: BoxDecoration(
                  borderRadius:
                      BorderRadius.circular(27.5), // Hace el botón circular
                  color: Colors.grey.shade300,
                ),
                child: TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.grey.shade300,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(27.5),
                    ),
                  ),
                  onPressed: _continueAsGuest,
                  child: const Text(
                    "Continuar como invitado",
                    style: TextStyle(color: Colors.black, fontSize: 16.0),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                    icon: const Icon(Icons.g_mobiledata, size: 40),
                    onPressed: () {
                      // Aquí agregarías la autenticación con Google
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.youtube_searched_for, size: 40),
                    onPressed: () {
                      // Aquí agregarías la autenticación con Microsoft
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.facebook, size: 40),
                    onPressed: () {
                      // Aquí agregarías la autenticación con Facebook
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
