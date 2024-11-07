import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'package:sqlite_flutter_crud/Authtentication/login.dart';
import 'package:sqlite_flutter_crud/Providers/snake_class.dart';
import 'package:sqlite_flutter_crud/Providers/snake_provider.dart';
import 'package:sqlite_flutter_crud/Providers/user_provider.dart';
import 'package:sqlite_flutter_crud/Views/info/info.dart';
import 'package:sqlite_flutter_crud/Views/report/Reports_List_view/IdReport.dart';
import 'package:sqlite_flutter_crud/Views/report/Reports_List_view/allReport.dart';
import 'package:sqlite_flutter_crud/Views/report/reportsMe/report.dart';
import 'package:sqlite_flutter_crud/Views/profile/profile.dart';
import 'package:sqlite_flutter_crud/Providers/Home_Body_provider.dart';
import 'package:sqlite_flutter_crud/Views/settings/settings.dart';
import 'package:sqlite_flutter_crud/Views/snake/SnakeIdentification/pageidentification.dart';
import 'package:sqlite_flutter_crud/Views/snake/snake_Info/Galeria/Screen_Galeria.dart';
import 'package:http/http.dart' as http;
import '../JsonModels/Usuario.dart';

class HomeScreen extends StatefulWidget {
  final Usuario usuario;

  const HomeScreen({required this.usuario, Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late TextEditingController searchController;
  late List<Serpiente> filteredSerpientes;
  Widget bodyContent = Screen_galeria();

  void updateBodyContent(Widget newContent) {
    setState(() {
      bodyContent = newContent;
    });
  }

  @override
  void initState() {
    super.initState();
    searchController = TextEditingController();
    searchController.addListener(() {
      setState(() {}); // Actualiza la vista cada vez que cambia el texto
    });
  }

  Future<void> _filterSerpientes(String query) async {
    final snakeProvider = context.read<Snake_Provider>();

    snakeProvider.filterSerpientes(query);
    
    print('Query: $query');
    print('Serpientes antes del filtro: ${snakeProvider.serpientes.length}');

    setState(() {
      if (query.isEmpty) {
        filteredSerpientes = snakeProvider.serpientes;
      } else {
        filteredSerpientes = snakeProvider.serpientes.where((serpiente) {
          return serpiente.nombre3.toLowerCase().contains(query.toLowerCase());
        }).toList();
      }
      print('Serpientes filtradas: ${filteredSerpientes.length}');
    });
  }

  @override
  Widget build(BuildContext context) {
    final body_Provider = context.watch<Home_Body_Provider>();
    final snakeProvider = context.watch<Snake_Provider>();
    final user_provider = context.watch<UserProvider>();

    user_provider.setUser(widget.usuario);

    int _selectedIndex = 0;
    String _appBarTitle = 'Inicio';

    return Scaffold(
        appBar: AppBar(
          title: Text("inicio",
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
              onPressed: () {},
            ),
          ],
          leading: BuilderMenu(),
        ),
        drawer: DrawerHome(widget: widget),
        body: body_Provider.Body_ini,
        backgroundColor: Colors.white,
        bottomNavigationBar:
            ButonBarHome(body_Provider: body_Provider, widget: widget));
  }
}

class ButonBarHome extends StatelessWidget {
  const ButonBarHome({
    super.key,
    required this.body_Provider,
    required this.widget,
  });

  final Home_Body_Provider body_Provider;
  final widget;

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
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
              body_Provider.setSelectedIndex(1); // Actualiza el selectedIndex
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Scaffold(
                      appBar: AppBar(
                        title: Text('Publicaciones'),
                        leading: BuilderMenu(),
                      ),
                      drawer: DrawerHome(widget: widget),
                      body: AllReport(),
                      bottomNavigationBar: ButonBarHome(
                          body_Provider: body_Provider, widget: widget)),
                ),
              );
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
              body_Provider.setSelectedIndex(0); // Actualiza el selectedIndex

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Scaffold(
                      appBar: AppBar(
                        title: Text('Inicio'),
                        leading: BuilderMenu(),
                      ),
                      drawer: DrawerHome(widget: widget),
                      body: Body_init(),
                      bottomNavigationBar: ButonBarHome(
                          body_Provider: body_Provider, widget: widget)),
                ),
              );
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
              body_Provider.setSelectedIndex(2); // Actualiza el selectedIndex
              body_Provider
                  .setAppBarTitle('Mi Perfil'); // Cambia el título del AppBar
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Scaffold(
                      appBar: AppBar(
                        title: Text("Mi Perfil"),
                        leading: BuilderMenu(),
                      ),
                      drawer: DrawerHome(widget: widget),
                      body: ProfilePage(),
                      bottomNavigationBar: ButonBarHome(
                          body_Provider: body_Provider, widget: widget)),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class BuilderMenu extends StatelessWidget {
  const BuilderMenu({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (BuildContext context) {
        return IconButton(
          icon: Icon(Icons.menu, color: Color(0xFF5DB075)),
          onPressed: () {
            Scaffold.of(context).openDrawer();
          },
        );
      },
    );
  }
}

class DrawerHome extends StatelessWidget {
  DrawerHome({
    super.key,
    required this.widget,
  });

  final widget;

  final storage = new FlutterSecureStorage();

  @override
  Widget build(BuildContext context) {
    final user_provider = context.watch<UserProvider>();
    Future<bool> signOutFromGoogle() async {
      try {
        await user_provider.userCredential.value.signOut();

        return true;
      } on Exception catch (_) {
        return false;
      }
    }

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountName: Text(user_provider.usernow.nombres),
            accountEmail: Text(user_provider.usernow.correo),
            currentAccountPicture: CircleAvatar(
              backgroundImage: NetworkImage(user_provider.usernow.imagen ??
                  'https://www.google.com/images/branding/googlelogo/2x/googlelogo_color_272x92dp.png'),
            ),
            decoration: BoxDecoration(color: Color(0xFF5DB075)),
          ),
          ListTile(
            leading: Icon(Icons.person),
            title: Text('Mi Perfil'),
            onTap: () {
              // Acción para ir a Mi Perfil
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Scaffold(
                      appBar: AppBar(
                        title: Text('Mi Perfil'),
                        leading: BuilderMenu(),
                      ),
                      drawer: DrawerHome(widget: widget),
                      body: ProfilePage(),
                      bottomNavigationBar: ButonBarHome(
                          body_Provider: Home_Body_Provider(), widget: widget)),
                ),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.article),
            title: Text('Mis Publicaciones'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Scaffold(
                    appBar: AppBar(
                      title: Text('Mis Publicaciones'),
                      leading: BuilderMenu(),
                    ),
                    drawer: DrawerHome(widget: widget),
                    body: IdReport(
                      id: user_provider.usernow.id,
                    ), // Asegúrate de pasar el usuario
                    bottomNavigationBar: ButonBarHome(
                      body_Provider: Home_Body_Provider(),
                      widget: widget,
                    ),
                  ),
                ),
              );
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
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Scaffold(
                    appBar: AppBar(
                      title: Text('Configuración'),
                      leading: BuilderMenu(),
                    ),
                    drawer: DrawerHome(widget: widget),
                    body: Settings(
                      usuario: user_provider.usernow,
                    ), // Asegúrate de pasar el usuario
                    bottomNavigationBar: ButonBarHome(
                      body_Provider: Home_Body_Provider(),
                      widget: widget,
                    ),
                  ),
                ),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.info),
            title: Text('Acerca de'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Scaffold(
                    appBar: AppBar(
                      title: Text('Acerca de "Snake Meta"'),
                      leading: BuilderMenu(),
                    ),
                    drawer: DrawerHome(widget: widget),
                    body: Info(
                      usuario: user_provider.usernow,
                    ), // Asegúrate de pasar el usuario
                    bottomNavigationBar: ButonBarHome(
                      body_Provider: Home_Body_Provider(),
                      widget: widget,
                    ),
                  ),
                ),
              );
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.logout, color: Colors.red),
            title: Text(
              'Cerrar Sesión',
              style: TextStyle(color: Colors.red),
            ),
            onTap: () async {
              bool shouldLogout = await showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    title: Center(
                      child: Text(
                        '¿Quieres salir de la Aplicación?',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w600, // Semibold
                          fontSize: 18,
                        ),
                      ),
                    ),
                    content: Text(
                      'Si sales de la Aplicación, perderás todo el progreso que no hayas guardado.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16),
                    ),
                    actionsAlignment: MainAxisAlignment.spaceEvenly,
                    actions: <Widget>[
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop(false); // No cerrar sesión
                        },
                        style: TextButton.styleFrom(
                          backgroundColor: Color(0xFF898A8D), // Color de fondo
                        ),
                        child: Text(
                          'Cancelar',
                          style: TextStyle(color: Colors.white), // Texto blanco
                        ),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF5DB075), // Fondo del botón
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                        ),
                        onPressed: () {
                          Navigator.of(context)
                              .pop(true); // Confirmar cerrar sesión
                        },
                        child: Text(
                          'Ok',
                          style: TextStyle(color: Colors.white), // Texto blanco
                        ),
                      ),
                    ],
                  );
                },
              );

              if (shouldLogout) {
                // Lógica para cerrar sesión
                await storage.delete(key: 'jwt');
                await storage.delete(key: 'user');
                user_provider.logoutUser();
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                  (route) => false,
                );
                bool result = await signOutFromGoogle();

                if (result) {
                  user_provider.userCredential.value = '';
                  print("Cerrado de sesión completo");
                }
              }
            },
          ),
        ],
      ),
    );
  }
}

class Body_init extends StatefulWidget {
  const Body_init({Key? key}) : super(key: key);

  @override
  _Body_initState createState() => _Body_initState();
}

class _Body_initState extends State<Body_init> {
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final bodyProvider = context.watch<Home_Body_Provider>();
    final serpienteProvider = context.watch<Snake_Provider>();

    Future<void> fectSnakesPoison(bool valid) async {
      await serpienteProvider.fectSnakesPoison(valid);
      bodyProvider.changedBodyHome(Screen_galeria());
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
            onChanged: (query) {
              // Filtra las serpientes en base al texto ingresado
              serpienteProvider.filterSerpientes(query);
            },
          ),
          SizedBox(height: 20),
          Expanded(
            child: serpienteProvider.filteredSerpientes.isEmpty
                ? PageView(
                    // Si el campo de búsqueda está vacío, muestra las tarjetas de categoría
                    children: [
                      CategoryCard(
                        title: 'Serpientes Venenosas',
                        imageUrl: 'lib/assets/mamba_verde.jpg',
                        onTap: () {
                          fectSnakesPoison(true);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Scaffold(
                                appBar: AppBar(
                                  title: Text('Serpientes'),
                                  leading: BuilderMenu(),
                                ),
                                drawer: DrawerHome(widget: Widget),
                                body: Screen_galeria(),
                                bottomNavigationBar: ButonBarHome(
                                    body_Provider: bodyProvider,
                                    widget: Widget),
                              ),
                            ),
                          );
                        },
                      ),
                      CategoryCard(
                        title: 'Serpientes No Venenosas',
                        imageUrl: 'lib/assets/mamba_negra.jpg',
                        onTap: () {
                          fectSnakesPoison(false);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Scaffold(
                                appBar: AppBar(
                                  title: Text('Serpientes'),
                                  leading: BuilderMenu(),
                                ),
                                drawer: DrawerHome(widget: Widget),
                                body: Screen_galeria(),
                                bottomNavigationBar: ButonBarHome(
                                    body_Provider: bodyProvider,
                                    widget: Widget),
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  )
                : ListView.builder(
                    // Si hay resultados de búsqueda, muestra la lista de coincidencias
                    itemCount: serpienteProvider.filteredSerpientes.length,
                    itemBuilder: (context, index) {
                      final serpiente =
                          serpienteProvider.filteredSerpientes[index];
                      return ListTile(
                        title: Text(serpiente.nombre3),
                        subtitle: Text(utf8.decode(serpiente.descripcion.codeUnits)),
                        leading: Image.network(
                          serpiente.imagen ?? 'path/to/default/image.jpg',
                          fit: BoxFit.cover,
                          width: 50,
                          height: 50,
                        ),
                        onTap: () {
                          fectSnakesPoison(serpiente.venenosa);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Scaffold(
                                appBar: AppBar(
                                  title:
                                      Text('Serpiente - ${serpiente.nombre3}'),
                                  leading: BuilderMenu(),
                                ),
                                drawer: DrawerHome(widget: Widget),
                                body: Screen_galeria(),
                                bottomNavigationBar: ButonBarHome(
                                    body_Provider: bodyProvider,
                                    widget: Widget),
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
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

  CategoryCard({
    required this.title,
    required this.imageUrl,
    required this.onTap,
  });

  @override
  _CategoryCardState createState() => _CategoryCardState();
}

class _CategoryCardState extends State<CategoryCard> {
  bool _isHovering = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
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
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Stack(
            children: [
              // Imagen que cubre toda la tarjeta
              Image.asset(
                widget.imageUrl,
                fit: BoxFit.cover,
                height: double
                    .infinity, // Esto asegura que la imagen cubra toda la tarjeta
                width: double.infinity,
              ),
              // Degradado en la parte inferior
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  height:
                      400, // Ajusta el tamaño del degradado según tu preferencia
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withOpacity(0.7),
                      ],
                    ),
                  ),
                ),
              ),
              // Texto de la tarjeta (Serpiente venenosa o no venenosa)
              Positioned(
                bottom: 20,
                left: 20,
                right: 20,
                child: Text(
                  widget.title.toUpperCase(),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
