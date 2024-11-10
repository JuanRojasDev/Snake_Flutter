import 'dart:convert';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:sqlite_flutter_crud/JsonModels/Usuario.dart';
import 'package:sqlite_flutter_crud/JsonModels/reporte.dart';
import 'package:sqlite_flutter_crud/Providers/report_provider.dart';
import 'package:sqlite_flutter_crud/Providers/user_provider.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class Info extends StatefulWidget {
  final Usuario? usuario;

  Info({this.usuario});

  @override
  _InfoState createState() => _InfoState();
}

class _InfoState extends State<Info> {
  // Función para abrir el enlace en el navegador
  _launchURL(Uri url) async {
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'No se pudo abrir el enlace: $url';
    }
  }

  // Función para realizar una llamada
  _makePhoneCall(Uri phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber.toString(),
    );
    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
    } else {
      throw 'No se pudo realizar la llamada al número: $phoneNumber';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: <Widget>[
            // Título principal
            Text(
              'Bienvenido a la Aplicación de Identificación de Serpientes del Meta',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.green[700],
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),

            // Imagen de bienvenida
            Image.asset(
              'lib/assets/header.jpg',
              height: 200,
              fit: BoxFit.cover,
            ),
            SizedBox(height: 20),

            // Introducción
            Text(
              'Esta aplicación está diseñada para proporcionar información detallada sobre las especies de serpientes en el departamento del Meta. La región del Meta es conocida por su biodiversidad, pero también presenta riesgos asociados con la presencia de serpientes venenosas. Con esta app, podrás conocer más sobre las diferentes especies, sus características, su hábitat y cómo identificarlas de manera precisa.',
              style: TextStyle(
                fontSize: 16,
                height: 1.5,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 20),

            // Sección sobre la importancia de la identificación
            Text(
              '¿Por qué es importante identificar las serpientes?',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.green[600],
              ),
            ),
            SizedBox(height: 10),
            Text(
              'El Meta alberga diversas especies de serpientes, algunas de ellas venenosas. La correcta identificación de estas especies es crucial para evitar accidentes y brindar una respuesta oportuna en caso de envenenamientos. Además, conocer su comportamiento y hábitat contribuye a la preservación del equilibrio ecológico en la región.',
              style: TextStyle(
                fontSize: 16,
                height: 1.5,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 20),

            // Imagen de serpientes
            Image.asset(
              'lib/assets/importancia.jpg',
              height: 200,
              fit: BoxFit.cover,
            ),
            SizedBox(height: 20),

            // Sección de características de la app
            Text(
              'Características de la Aplicación',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.green[600],
              ),
            ),
            SizedBox(height: 10),
            Text(
              '• Base de datos detallada de especies de serpientes del Meta.\n'
              '• Identificación visual y descriptiva de las especies.\n'
              '• Consejos de seguridad y primeros auxilios ante mordeduras.\n'
              '• Información sobre el hábitat y distribución de cada especie.\n'
              '• Función de búsqueda rápida para facilitar la identificación.',
              style: TextStyle(
                fontSize: 16,
                height: 1.5,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 20),

            // Créditos y agradecimientos
            Text(
              'Créditos y Agradecimientos',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.green[600],
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Este proyecto fue desarrollado con el objetivo de educar y crear conciencia sobre la fauna del Meta. Agradecemos a los expertos herpetólogos, biólogos y comunidades locales que contribuyeron con su conocimiento para que esta aplicación sea una herramienta útil y precisa.\n\n'
              'Para más información o reportes sobre serpientes en el Meta, por favor contácta a través de las redes sociales de Cormacarena.',
              style: TextStyle(
                fontSize: 16,
                height: 1.5,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 20),

            // Sección de contacto en caso de emergencia
            Text(
              'Contactos en caso de Emergencia:',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.green[600],
              ),
            ),
            SizedBox(height: 10),
            GestureDetector(
              onTap: () => _makePhoneCall(Uri.parse('tel:+573214820327')),
              child: RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: 'Fauna Silvestre: ',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                    ),
                    TextSpan(
                      text: '321 482 0327',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.blue,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            // Sección de redes sociales
            Text(
              'Redes oficiales de CORMACARENA:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.green[600],
              ),
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Column(
                  children: [
                    IconButton(
                      icon: FaIcon(
                        FontAwesomeIcons.instagram,
                        color: Colors.purple,
                        size: 30,
                      ),
                      onPressed: () =>
                          _launchURL(Uri.parse('https://www.instagram.com/CORMACARENA')),
                    ),
                    Text('Instagram'),
                  ],
                ),
                SizedBox(width: 20),
                Column(
                  children: [
                    IconButton(
                      icon: FaIcon(
                        FontAwesomeIcons.facebook,
                        color: Colors.blue,
                        size: 30,
                      ),
                      onPressed: () => _launchURL(
                          Uri.parse('https://www.facebook.com/CORMACARENA.CDS')),
                    ),
                    Text('Facebook'),
                  ],
                ),
                SizedBox(width: 20),
                Column(
                  children: [
                    IconButton(
                      icon: FaIcon(
                        FontAwesomeIcons.tiktok,
                        color: Colors.black,
                        size: 30,
                      ),
                      onPressed: () => _launchURL(
                          Uri.parse('https://www.tiktok.com/@cormacarenaoficial')),
                    ),
                    Text('TikTok'),
                  ],
                ),
                SizedBox(width: 20),
                Column(
                  children: [
                    IconButton(
                      icon: FaIcon(
                        FontAwesomeIcons.xTwitter,
                        color: Colors.blue,
                        size: 30,
                      ),
                      onPressed: () => _launchURL(Uri.parse('https://x.com/CORMACARENA')),
                    ),
                    Text('X'),
                  ],
                ),
                SizedBox(width: 20),
                Column(
                  children: [
                    IconButton(
                      icon: FaIcon(
                        FontAwesomeIcons.envelope,
                        color: Colors.red,
                        size: 30,
                      ),
                      onPressed: () =>
                          _launchURL(Uri.parse('mailto:info@cormacarena.gov.co')),
                    ),
                    Text('Gmail'),
                  ],
                ),
              ],
            ),
            SizedBox(height: 20),

            // Logo de la aplicación
            Center(
              child: Column(
                children: [
                  Image.asset(
                    'lib/assets/login.png',
                    height: 100,
                    fit: BoxFit.cover,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
