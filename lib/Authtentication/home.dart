import 'package:flutter/material.dart';
import 'package:sqlite_flutter_crud/Authtentication/login.dart';
<<<<<<< HEAD
import '../JsonModels/Usuario.dart';
import 'package:sqlite_flutter_crud/Authtentication/report.dart'; // Importa tu pantalla de reporte aquí

class HomeScreen extends StatelessWidget {
  final Usuario? usuario;

  HomeScreen({this.usuario});

  @override
=======

import '../JsonModels/Usuario.dart';

class HomeScreen extends StatelessWidget {
  
  final Usuario? usuario;

HomeScreen({this.usuario});
  
  @override

>>>>>>> 3ba1d22dbc15e871792a2a3084c49387f9c95fe2
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Inicio',
            style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 24)),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.filter_list, color: Color(0xFF5DB075)),
            onPressed: () {
              // Acción del botón de filtrar
            },
          ),
        ],
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: Icon(Icons.menu, color: Color(0xFF5DB075)),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            UserAccountsDrawerHeader(
              accountName: Text(usuario?.nombres ?? 'Usuario no disponible'),
              accountEmail: Text(usuario?.correo ?? 'Usuario no disponible'),
              currentAccountPicture: CircleAvatar(
                backgroundImage:
                    AssetImage('lib/assets/your_profile_picture.jpg'),
              ),
              decoration: BoxDecoration(color: Color(0xFF5DB075)),
            ),
            ListTile(
              leading: Icon(Icons.person),
              title: Text('Mi Perfil'),
              onTap: () {
                // Acción para ir a Mi Perfil
              },
            ),
            ListTile(
              leading: Icon(Icons.article),
              title: Text('Mis Publicaciones'),
              onTap: () {
                // Acción para ir a Mis Publicaciones
              },
            ),
            ListTile(
              leading: Icon(Icons.favorite),
              title: Text('Mis Me Gusta'),
              onTap: () {
                // Acción para ir a Mis Me Gusta
              },
            ),
            ListTile(
              leading: Icon(Icons.message),
              title: Text('Menciones'),
              onTap: () {
                // Acción para ir a Menciones
              },
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Configuración'),
              onTap: () {
                // Acción para ir a Configuración
              },
            ),
            ListTile(
              leading: Icon(Icons.info),
              title: Text('Acerca de'),
              onTap: () {
                // Acción para ir a Acerca de
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.logout, color: Colors.red),
              title: Text('Cerrar Sesión', style: TextStyle(color: Colors.red)),
              onTap: () {
                // Acción para cerrar sesión y redirigir al login
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => LoginScreen()));
              },
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(
                hintText: 'Buscar serpientes',
                prefixIcon: Icon(Icons.search, color: Colors.black),
                filled: true,
                fillColor: Color(0xFFF0F0F0),
                contentPadding: EdgeInsets.symmetric(vertical: 0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: Column(
                children: [
                  CategoryCard(
                    title: 'Serpientes Venenosas',
                    imageUrl: 'lib/assets/mamba_verde.jpg',
                    onTap: () {
                      // Acción al pulsar la tarjeta de serpientes venenosas
                    },
                  ),
                  SizedBox(height: 20),
                  CategoryCard(
                    title: 'Serpientes No Venenosas',
                    imageUrl: 'lib/assets/mamba_negra.jpg',
                    onTap: () {
                      // Acción al pulsar la tarjeta de serpientes no venenosas
                    },
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ), // Espacio adicional entre las tarjetas y la barra de navegación inferior
            BottomAppBar(
              color: Colors.white,
              child: Row(
                mainAxisAlignment: MainAxisAlignment
                    .spaceEvenly, // Ajusta el espacio entre los botones
                children: [
                  IconButton(
                    iconSize: 30, // Ajusta el tamaño del ícono
                    icon: Icon(Icons.help_outline),
                    onPressed: () {
                      // Acción para el botón de ayuda
                    },
                  ),
                  IconButton(
                    iconSize: 30, // Ajusta el tamaño del ícono
                    icon: Icon(Icons.edit),
                    onPressed: () {
                      // Acción para el botón de escribir
<<<<<<< HEAD
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ReportPage()));
=======
>>>>>>> 3ba1d22dbc15e871792a2a3084c49387f9c95fe2
                    },
                  ),
                  IconButton(
                    iconSize: 40, // Ajusta el tamaño del ícono
                    icon: Icon(Icons.home,
                        color: Colors.green), // Resalta la opción de inicio
                    onPressed: () {
                      // Acción para el botón de inicio
                    },
                  ),
                  IconButton(
                    iconSize: 30, // Ajusta el tamaño del ícono
                    icon: Icon(Icons.message),
                    onPressed: () {
                      // Acción para el botón de mensajes
                    },
                  ),
                  IconButton(
                    iconSize: 30, // Ajusta el tamaño del ícono
                    icon: Icon(Icons.person),
                    onPressed: () {
                      // Acción para el botón de perfil
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      backgroundColor: Colors.white,
    );
  }
}

class CategoryCard extends StatefulWidget {
  final String title;
  final String imageUrl;
  final VoidCallback onTap;

  CategoryCard(
      {required this.title, required this.imageUrl, required this.onTap});

  @override
  _CategoryCardState createState() => _CategoryCardState();
}

class _CategoryCardState extends State<CategoryCard> {
  bool _isHovering = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: MouseRegion(
        onEnter: (_) {
          setState(() {
            _isHovering = true;
          });
        },
        onExit: (_) {
          setState(() {
            _isHovering = false;
          });
        },
        child: Card(
          elevation: _isHovering ? 10 : 2, // Elevación aumentada al hacer hover
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          child: Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: ScaleTransition(
                  scale: _isHovering
                      ? Tween(begin: 1.0, end: 1.1).animate(CurvedAnimation(
                          parent: ModalRoute.of(context)!.animation!,
                          curve: Curves.easeInOut,
                        ))
                      : Tween(begin: 1.1, end: 1.0).animate(CurvedAnimation(
                          parent: ModalRoute.of(context)!.animation!,
                          curve: Curves.easeInOut,
                        )),
                  child: Image.asset(
                    widget.imageUrl,
                    width: double.infinity,
                    height: MediaQuery.of(context).size.height / 3,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Container(
                width: double.infinity,
                height: MediaQuery.of(context).size.height / 3,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.black.withOpacity(0.2),
                ),
                alignment: Alignment.center,
                child: Text(
                  widget.title,
                  style: TextStyle(
                    fontSize: 24,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
