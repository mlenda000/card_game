import 'package:card_game/components/card_list.dart';
import 'package:card_game/components/deck_pile.dart';
import 'package:card_game/components/discard_pile.dart';
import 'package:card_game/components/player_info.dart';
import 'package:card_game/models/card_model.dart';
import 'package:card_game/models/player_model.dart';
import 'package:card_game/providers/crazy_eights_game_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GameBoard extends StatelessWidget {
  const GameBoard({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<CrazyEightsGameProvider>(
      builder: (context, model, child) {
        return model.currentDeck != null
            ? Column(
              children: [
                PlayerInfo(turn: model.turn),
                Expanded(
                  child: Stack(
                      children: [
                        Container(
                          color: Colors.green,
                          child: Align(
                            alignment: Alignment.center,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    GestureDetector(
                                      onTap: () async {
                                        await model.drawCards(model.turn.currentPlayer);
                                      },
                                      child: DeckPile(
                                          remaining: model.currentDeck!.remaining),
                                    ),
                                    SizedBox(width: 8),
                                    DiscardPile(
                                      cards: model.discards,
                                    ),
                                  ],
                                ),
                                if (model.buttonWidget != null) model.buttonWidget!,
                              ],
                            ),
                          ),
                        ),
                        Align(
                            alignment: Alignment.topCenter,
                            child: Padding(
                              padding: const EdgeInsets.only(left:16.0, right: 16.0, top: 4.0),
                              child: CardList(
                                player: model.players[1],
                              ),
                            )),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    if (model.turn.currentPlayer == model.players[0])
                                      ElevatedButton(
                                          onPressed: model.canEndTurn
                                              ? () {
                                                  model.endTurn();
                                                }
                                              : null,
                                          child: const Text("End Turn"))
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(bottom:4.0, left: 16.0, right: 16.0),
                                child: CardList(
                                  player: model.players[0],
                                  onPlayCard: (CardModel card) {
                                    model.playCard(
                                        card: card, player: model.players[0]);
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                ),
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
