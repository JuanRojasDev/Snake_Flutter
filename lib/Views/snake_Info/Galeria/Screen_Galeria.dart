import 'package:flutter/material.dart';
import 'package:sqlite_flutter_crud/Providers/Home_Body_provider.dart';

import 'package:provider/provider.dart';
import 'package:sqlite_flutter_crud/Views/snake_Info/Info_snake/info_Snale.dart';

class Screen_galeria extends StatelessWidget {
  const Screen_galeria({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: GridView.count(
          crossAxisCount: 2, // Adjust for desired number of columns
          children: List.generate(100, (index) => _buildGridTile(context, index)),
        ),
      ),
    );
  }

  Widget _buildGridTile(BuildContext context,int index) {
     final body_Provider = context.watch<Home_Body_Provider>();
    return GestureDetector(
      onTap: () {
        body_Provider.cahngedBodyHome(Info_Snake(infoInt: index,imgUrl: 'https://www.anipedia.net/images/fotos-serpiente-coral.jpg', nameSnake: 'Coral',));
      },
      child: Card(
          
          margin: const EdgeInsets.all(10),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          clipBehavior: Clip.antiAliasWithSaveLayer,
          elevation: 5,
          child: Container(
            decoration:  BoxDecoration(
              image: DecorationImage(
                image: NetworkImage('https://th.bing.com/th/id/OIP.5pRLWnDjEGalJdZNRCMVowHaEK?rs=1&pid=ImgDetMain'),
                fit: BoxFit.cover,
                alignment: Alignment.topCenter,
              ),
            ),
            child:  Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text('-Assssss-',style: TextStyle(backgroundColor: Color.fromARGB(255, 127, 191, 223))),
                SizedBox(height: 8,)],),
          ),
        ),
    );
  }
}
