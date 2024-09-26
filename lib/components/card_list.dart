import 'package:card_game/components/playing_card.dart';
import 'package:card_game/constants.dart';
import 'package:card_game/models/card_model.dart';
import 'package:card_game/models/player_model.dart';
import 'package:flutter/material.dart';

class CardList extends StatelessWidget {
  final double size;
  final PlayerModel player;
  final Function(CardModel)? onPlayCard;
  const CardList(
      {super.key, this.size = 1, required this.player, this.onPlayCard});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: CARD_HEIGHT * size,
        width: double.infinity,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: player.cards.length,
          itemBuilder: (context, index) {
            final card = player.cards[index];
            return PlayingCard(card: card , size: size, visible: true,);
          },
        ));
  }
}
