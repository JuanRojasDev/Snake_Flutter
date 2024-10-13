import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sqlite_flutter_crud/Authtentication/login.dart';
import 'package:sqlite_flutter_crud/Providers/snake_provider.dart';
import 'package:sqlite_flutter_crud/Providers/usuer_provider.dart';
import 'package:sqlite_flutter_crud/Views/report/reportsMe/report.dart';
import 'package:sqlite_flutter_crud/Views/profile/profile.dart';
import 'package:sqlite_flutter_crud/Providers/Home_Body_provider.dart';
import 'package:sqlite_flutter_crud/Views/snake/SnakeIdentification/pageidentification.dart';
import 'package:sqlite_flutter_crud/Views/snake/snake_Info/Galeria/Screen_Galeria.dart';
import 'package:http/http.dart' as http;
import '../JsonModels/Usuario.dart';
import '../Providers/snake_class.dart';

class HomeScreen extends StatefulWidget {
  final Usuario usuario;

  const HomeScreen({required this.usuario, Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Widget bodyContent = Screen_galeria();

  void updateBodyContent(Widget newContent) {
    setState(() {
      bodyContent = newContent;
    });
  }

  @override
  Widget build(BuildContext context) {
    final body_Provider = context.watch<Home_Body_Provider>();
    final user_provider = context.watch<UserProvider>();

    user_provider.setUser(widget.usuario);

    int _selectedIndex = 0;
    String _appBarTitle = 'Inicio';

    return Scaffold(
        appBar: AppBar(
          title: Text(
              "inicio", // Actualiza el título según el icono seleccionado
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
          leading: BuilderMenu(), ),
        drawer: DrawerHome(widget: widget),
        body: body_Provider.Body_ini,
        backgroundColor: Colors.white,
        bottomNavigationBar: ButonBarHome(body_Provider: body_Provider, widget: widget));
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
                                body_Provider
                  .setSelectedIndex(1); // Actualiza el selectedIndex
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Scaffold(
                    appBar: AppBar(
                      title: Text('Crear Publicacion'),
                      leading: BuilderMenu(),
                    ),
                    drawer: DrawerHome(widget: widget),
                    
                    body: ReportPage(),
                    bottomNavigationBar: ButonBarHome(body_Provider: body_Provider, widget: widget)
                  ),
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
              body_Provider
                  .setSelectedIndex(0); // Actualiza el selectedIndex

               Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Scaffold(
                    appBar: AppBar(
                      title: Text('Inicio'),
                      leading: BuilderMenu(),
                    ),
                    drawer: DrawerHome(widget: widget),
                    
                    body:Body_init(),
                    bottomNavigationBar: ButonBarHome(body_Provider: body_Provider, widget: widget)
                  ),
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
              body_Provider
                  .setSelectedIndex(2); // Actualiza el selectedIndex
              body_Provider.setAppBarTitle(
                  'Mi Perfil'); // Cambia el título del AppBar
                Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Scaffold(
                    appBar: AppBar(
                      title: Text("Mi Perfil"),
                      leading: BuilderMenu(),
                    ),
                    drawer: DrawerHome(widget: widget),
                    
                    body:ProfilePage(),
                    bottomNavigationBar: ButonBarHome(body_Provider: body_Provider, widget: widget)
                  ),
                ),
              );
            },
          ),
          IconButton(
            iconSize: 30, // Ajusta el tamaño del ícono
            icon: Icon(
              Icons.camera,
              color: body_Provider.selectedIndex == 3
                  ? Colors.green
                  : Color(0xFF6e7168),
            ),
            onPressed: () {
              body_Provider
                  .setSelectedIndex(3); // Actualiza el selectedIndex
              body_Provider.setAppBarTitle(
                  'Identificar'); // Cambia el título del AppBar
              body_Provider.changedBodyHome(PageIdentification());
                Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Scaffold(
                    appBar: AppBar(
                      title: Text("Identificar Serpientes"),
                      leading: BuilderMenu(),
                    ),
                    drawer: DrawerHome(widget: widget),
                    
                    body:PageIdentification(),
                    bottomNavigationBar: ButonBarHome(body_Provider: body_Provider, widget: widget)
                  ),
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
  const DrawerHome({
    super.key,
    required this.widget,
  });

  final widget;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountName:
                Text(widget.usuario?.nombres ?? 'Usuario no disponible'),
            accountEmail:
                Text(widget.usuario?.correo ?? 'Usuario no disponible'),
            currentAccountPicture: CircleAvatar(
              backgroundImage: NetworkImage(widget.usuario?.imagen ??
                  'https://www.google.com/images/branding/googlelogo/2x/googlelogo_color_272x92dp.png'),
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
    );
  }
}

class Body_init extends StatelessWidget {
  

  const Body_init({Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final body_Provider = context.watch<Home_Body_Provider>();
    final serpiente_provider = context.watch<Snake_Provider>();

    Future<void> fectSnakesPoison(bool valid) async {
      serpiente_provider.fectSnakesPoison(valid);
      body_Provider.changedBodyHome(Screen_galeria());
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
            child: PageView(
              children: [
                CategoryCard(
                  title: 'Serpientes Venenosas',
                  imageUrl: 'lib/assets/mamba_verde.jpg',
                  onTap: () {
                    // Acción al pulsar la tarjeta de serpientes venenosas
                    fectSnakesPoison(true);
                  },
                ),
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
