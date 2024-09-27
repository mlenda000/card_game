import 'package:card_game/models/turn_model.dart';
import 'package:flutter/material.dart';

class PlayerInfo extends StatelessWidget {
  final TurnModel turn;

  const PlayerInfo({super.key, required this.turn});

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.black,
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.only(top:4.0, bottom:4.0, left: 16.0, right: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: turn.players.map((p) {
              final isCurrent = turn.currentPlayer == p;
              return Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(3),
                  color: isCurrent ? Colors.teal[900]: Colors.transparent,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: Padding(
                    padding: const EdgeInsets.only(top:2.0, bottom:2.0, left: 8.0, right: 8.0),
                    child: Text(
                      "Player ${turn.getPlayerNumber(p.name)}: ${p.name} || Card count: ${p.cards.length}",
                      style: TextStyle(
                        color: isCurrent ? Colors.yellowAccent : Colors.white,
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ));
  }
  
}
