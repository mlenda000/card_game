import 'package:card_game/components/card_list.dart';
import 'package:card_game/components/deck_pile.dart';
import 'package:card_game/components/playing_card.dart';
import 'package:card_game/models/card_model.dart';
import 'package:card_game/models/player_model.dart';
import 'package:card_game/providers/game_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GameBoard extends StatelessWidget {
  const GameBoard({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<GameProvider>(
      builder: (context, model, child) {
        return model.currentDeck != null
            ? Stack(
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: GestureDetector(
                        onTap: () async {
                          await model.drawCards(model.players.first);
                        },
                        child:
                            DeckPile(remaining: model.currentDeck!.remaining)),
                  ),
                  Align(
                      alignment: Alignment.bottomCenter,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              ElevatedButton(
                                  onPressed: () {}, child:const Text("End Turn"))
                            ],
                          ),
                          const SizedBox(height: 8,),
                          CardList(
                            player: model.players[0],
                          ),
                        ],
                      )),
                ],
              )
            : Center(
                child: TextButton(
                  child: Text("New Game"),
                  onPressed: () {
                    final players = [
                      PlayerModel(name: "Mark", isHuman: true),
                      PlayerModel(name: "Bot", isHuman: false)
                    ];
                    model.newGame(players);
                  },
                ),
              );
      },
    );
  }
}
