import 'package:flutter/material.dart';

class Info_Snake extends StatelessWidget {
  final int infoInt; 
  const Info_Snake({super.key, required this.infoInt});

  @override
  Widget build(BuildContext context) {
    return Text('info page load'+infoInt.toString());
  }
}