import 'package:card_game/components/playing_card.dart';
import 'package:card_game/constants.dart';
import 'package:card_game/models/card_model.dart';
import 'package:flutter/material.dart';

class DiscardPile extends StatelessWidget {
  final List<CardModel> cards;
  final double size;
  const DiscardPile({super.key, required this.cards, this.size = 1});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: CARD_WIDTH * size,
      height: CARD_HEIGHT * size,
      decoration: BoxDecoration(
        color: Colors.black45,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Stack(
        children: cards.map((card) => PlayingCard(card: card, visible: true,)).toList(),
      )
    );
  }
}