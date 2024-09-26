import 'package:flutter/material.dart';

class GameScreen extends StatelessWidget {
  const GameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Card Game"),
        actions: [
          TextButton(
            onPressed: () {},
            child:const  Text("New game", style: TextStyle(color: Colors.white),),
          ),
        ],
      ),
    );
  }
}
