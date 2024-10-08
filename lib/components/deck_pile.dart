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
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration:
                BoxDecoration(shape: BoxShape.circle, color: Colors.black),
          ),
          Center(
              child: Text(
            "$remaining",
            style: TextStyle(color: Colors.white),
          ))
        ],
      ),
    );
  }
}
