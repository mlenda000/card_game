import 'package:card_game/constants.dart';
import 'package:flutter/material.dart';

class CardBack extends StatelessWidget {
  final double size;
  final Widget? child;

  const CardBack({super.key, this.size = 1, this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
        width: CARD_WIDTH * size,
        height: CARD_HEIGHT * size,
        decoration: BoxDecoration(
          color: Colors.purple,
          border: Border.all(color: Colors.black,   width: 1.0),
          borderRadius: BorderRadius.circular(8),
            image: DecorationImage(
          image:
              NetworkImage("https://www.deckofcardsapi.com/static/img/back.png"),
          fit: BoxFit.cover,
        )),
        child: child ?? Container());
  }
}
