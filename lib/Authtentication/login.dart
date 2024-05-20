import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sqlite_flutter_crud/Authtentication/signup.dart';
import 'package:sqlite_flutter_crud/JsonModels/Usuario.dart';
import 'dart:convert';
import '../JsonModels/users.dart';
import 'home.dart';

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

  Future<void> _login() async {
    final String url =
        'https://back-1-9ehs.onrender.com/users/login'; // server ip

    //final String url ='http://127.0.0.1:8000/users/login'; // local ip

    final Map<String, String> body = {
      'email': _usernameController.text,
      'password': _passwordController.text,
    };

    final Map<String, String> headers = {'Content-Type': 'application/json'};

    final response = await http.post(Uri.parse(url),
        body: jsonEncode(body), headers: headers);

    if (response.statusCode == 200) {
      // Inicio de sesión exitoso, navegar a la siguiente pantalla (home.dart)
      Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      Usuario user = Usuario.fromJson(jsonResponse);
      print(user.nombres);

      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => HomeScreen(
                    usuario: user,
                  ))); // Navegar a home.dart
    } else {
      // Mostrar un mensaje de error al usuario

      print('This will be logged to the console in the browser.');
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
            builder: (context) => HomeScreen())); // Navegar a home.dart
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green.shade100,
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                const Text(
                  "Iniciar Sesión",
                  style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
                const SizedBox(height: 15),
                Image.asset(
                  "lib/assets/login.png",
                  width: 210,
                ),
                const SizedBox(height: 15),
                Container(
                  margin: const EdgeInsets.all(8),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.white.withOpacity(.2),
                  ),
                  child: TextField(
                    controller: _usernameController,
                    decoration: const InputDecoration(
                      icon: Icon(Icons.person),
                      border: InputBorder.none,
                      hintText: "Correo",
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(8),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.white.withOpacity(.2),
                  ),
                  child: TextField(
                    controller: _passwordController,
                    obscureText: !_isVisible,
                    decoration: InputDecoration(
                      icon: const Icon(Icons.lock),
                      border: InputBorder.none,
                      hintText: "Contraseña",
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            _isVisible = !_isVisible;
                          });
                        },
                        icon: Icon(_isVisible
                            ? Icons.visibility
                            : Icons.visibility_off),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  height: 55,
                  width: MediaQuery.of(context).size.width * .9,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(2),
                    color: Colors.green.shade400,
                  ),
                  child: TextButton(
                    onPressed: _login,
                    child: const Text(
                      "Iniciar Sesión",
                      style: TextStyle(color: Colors.white),
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
                      child: const Text("Registrarse"),
                    ),
                  ],
                ),
                _isLoginTrue
                    ? const Text(
                        "Nombre de usuario o contraseña incorrectos",
                        style: TextStyle(color: Colors.red),
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
                Container(
                  height: 55,
                  width: MediaQuery.of(context).size.width * .9,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(2),
                    color: Colors.grey.shade300,
                  ),
                  child: TextButton(
                    onPressed: _continueAsGuest,
                    child: const Text(
                      "Continuar como invitado",
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
