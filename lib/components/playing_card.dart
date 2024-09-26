import 'package:cached_network_image/cached_network_image.dart';
import 'package:card_game/components/card_back.dart';
import 'package:card_game/constants.dart';
import 'package:card_game/models/card_model.dart';
import 'package:flutter/material.dart';

class PlayingCard extends StatelessWidget {
  final CardModel card;
  final double size;
  final bool visible;

  const PlayingCard(
      {super.key, required this.card, this.size = 1, this.visible = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: CARD_WIDTH * size,
      height: CARD_HEIGHT * size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4.0),
      ),
      clipBehavior: Clip.antiAlias,
      child: visible
          ? CachedNetworkImage(
              imageUrl: card.image,
              width: CARD_WIDTH * size,
              height: CARD_HEIGHT * size,
            )
          : CardBack(size: size,),
    );
  }
}
