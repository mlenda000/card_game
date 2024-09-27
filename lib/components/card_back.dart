import 'package:card_game/constants.dart';
import 'package:flutter/material.dart';

class CardBack extends StatelessWidget {
  final double size;
  final Widget? child;

  const CardBack({
    super.key, 
    this.size = 1,
    this.child
    });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: CARD_WIDTH * size,
      height: CARD_HEIGHT * size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4.0),
        color: const Color.fromARGB(255, 89, 33, 243),
        border: Border.all(color: Colors.black), 
      ),
      child: child ?? Container(),
      
    );
  }
}