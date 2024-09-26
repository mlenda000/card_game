import 'package:card_game/components/card_back.dart';
import 'package:flutter/material.dart';

class DeckPile extends StatelessWidget {
  final int remaining;
  final double size;
  final bool canDraw;

  const DeckPile(
      {super.key,
      required this.remaining,
      this.size = 1,
      this.canDraw = false});

  @override
  Widget build(BuildContext context) {
    return CardBack(
      size: size,
      child: Center(
          child: Text(
        "$remaining",
        style: TextStyle(color: Colors.white),
      )),
    );
  }
}
