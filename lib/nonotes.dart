
import 'package:flutter/material.dart';

class Nonotes extends StatelessWidget {
  const Nonotes({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(child: Text('You have no notes yet!\nStart creating by pressing the + button bellow :)',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),))
        ],
      ),
    ) ;
  }
}
