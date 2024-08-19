import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sqlite_flutter_crud/Authtentication/login.dart';
import 'package:sqlite_flutter_crud/Views/report/reportsMe/report.dart';
import 'package:sqlite_flutter_crud/Views/profile/profile.dart';
import 'package:sqlite_flutter_crud/Providers/Home_Body_provider.dart';
import 'package:sqlite_flutter_crud/Views/snake/snake_Info/Galeria/Screen_Galeria.dart';
import 'package:http/http.dart' as http;
import '../JsonModels/Usuario.dart';
import '../Providers/snake_class.dart';

class HomeScreen extends StatefulWidget {
  final Usuario? usuario;

  const HomeScreen({this.usuario, Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Widget bodyContent = Body_init();

  void updateBodyContent(Widget newContent) {
    setState(() {
      bodyContent = newContent;
    });
  }

  @override
  Widget build(BuildContext context) {
    final body_Provider = context.watch<Home_Body_Provider>();
    int _selectedIndex = 0;
    String _appBarTitle = 'Inicio';

    return Scaffold(
        appBar: AppBar(
          title: Text(
              body_Provider
                  .appBarTitle, // Actualiza el título según el icono seleccionado
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
                accountName:
                    Text(widget.usuario?.nombres ?? 'Usuario no disponible'),
                accountEmail:
                    Text(widget.usuario?.correo ?? 'Usuario no disponible'),
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
                title:
                    Text('Cerrar Sesión', style: TextStyle(color: Colors.red)),
                onTap: () {
                  // Acción para cerrar sesión y redirigir al login
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => LoginScreen()));
                },
              ),
            ],
          ),
        ),
        body: body_Provider.Body_ini,
        backgroundColor: Colors.white,
        bottomNavigationBar: BottomAppBar(
          color: Colors.white,
          child: Row(
            mainAxisAlignment: MainAxisAlignment
                .spaceEvenly, // Ajusta el espacio entre los botones
            children: [
              IconButton(
                iconSize: 30, // Ajusta el tamaño del ícono
                icon: Icon(
                  Icons.edit,
                  color: body_Provider.selectedIndex == 1
                      ? Colors.green
                      : Color(0xFF6e7168),
                ), // Resalta la opción de escribir
                onPressed: () {
                  // Acción para el botón de escribir
                  body_Provider
                      .setSelectedIndex(1); // Actualiza el selectedIndex
                  body_Provider.setAppBarTitle(
                      'Publicaciones'); // Cambia el título del AppBar
                  body_Provider.changedBodyHome(ReportPage(usuario: widget.usuario,));
                },
              ),
              IconButton(
                iconSize: 40, // Ajusta el tamaño del ícono
                icon: Icon(
                  Icons.home,
                  color: body_Provider.selectedIndex == 0
                      ? Colors.green
                      : Color(0xFF6e7168),
                ), // Resalta la opción de inicio
                onPressed: () {
                  // Acción para el botón de inicio
                  body_Provider
                      .setSelectedIndex(0); // Actualiza el selectedIndex
                  body_Provider
                      .setAppBarTitle('Inicio'); // Cambia el título del AppBar
                  body_Provider.changedBodyHome(Body_init());
                },
              ),
              IconButton(
                iconSize: 30, // Ajusta el tamaño del ícono
                icon: Icon(
                  Icons.person,
                  color: body_Provider.selectedIndex == 2
                      ? Colors.green
                      : Color(0xFF6e7168),
                ),
                onPressed: () {
                  // Acción para el botón de perfil
                  body_Provider
                      .setSelectedIndex(2); // Actualiza el selectedIndex
                  body_Provider.setAppBarTitle(
                      'Mi Perfil'); // Cambia el título del AppBar
                  body_Provider.changedBodyHome(ProfilePage(usuario: widget.usuario));
                },
              ),
            ],
          ),
        ));
  }
}

class Body_init extends StatelessWidget {
  final Usuario? usuario;

  const Body_init({Key? key, this.usuario}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final body_Provider = context.watch<Home_Body_Provider>();

    Future<void> fectSnakesPoison(bool valid) async {
      final String url =
          'https://back-1-9ehs.onrender.com/Snakes/poison?valid=' +
              valid.toString(); // server ip

      print(url);

      final Map<String, String> headers = {'Content-Type': 'application/json'};

      final response = await http.get(Uri.parse(url), headers: headers);
      List<Serpiente> serpientes = [];
      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(response.body);

        if (jsonResponse != []) {
          for (var element in jsonResponse) {
            serpientes.add(Serpiente.fromJson(element));
          }
        }

        body_Provider.changedBodyHome(Screen_galeria(
          serpientes: serpientes,
        ));
      }
    }

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          TextField(
            decoration: InputDecoration(
              hintText: 'Buscar serpientes',
              prefixIcon: Icon(Icons.search),
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
                    fectSnakesPoison(true);
                  },
                ),
                SizedBox(height: 20),
                CategoryCard(
                  title: 'Serpientes No Venenosas',
                  imageUrl: 'lib/assets/mamba_negra.jpg',
                  onTap: () {
                    // Acción al pulsar la tarjeta de serpientes no venenosas
                    fectSnakesPoison(false);
                  },
                ),
              ],
            ),
          ),
          SizedBox(
            height: 10,
          ),
        ],
      ),
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
        child: AnimatedContainer(
          duration: Duration(milliseconds: 200),
          decoration: BoxDecoration(
            color: _isHovering ? Colors.green : Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 2,
                blurRadius: 5,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                child: Image.asset(
                  widget.imageUrl,
                  fit: BoxFit.cover,
                  height: 285,
                  width: double.infinity,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  widget.title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: _isHovering ? Colors.white : Colors.black,
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
