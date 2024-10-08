import 'package:card_game/components/card_list.dart';
import 'package:card_game/components/deck_pile.dart';
import 'package:card_game/components/discard_pile.dart';
import 'package:card_game/components/player_info.dart';
import 'package:card_game/models/card_model.dart';
import 'package:card_game/models/player_model.dart';
import 'package:card_game/providers/game_provider.dart';
import 'package:flutter/material.dart';

class GameBoard extends StatelessWidget {
  final GameProvider provider;

  const GameBoard({super.key, required this.provider});

  @override
  Widget build(BuildContext context) {
    return provider.currentDeck != null
        ? Column(
            children: [
              PlayerInfo(turn: provider.turn),
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
                                    await provider
                                        .drawCards(provider.turn.currentPlayer);
                                  },
                                  child: DeckPile(
                                      remaining:
                                          provider.currentDeck!.remaining),
                                ),
                                const SizedBox(width: 8),
                                DiscardPile(
                                  onPressed: (card) {
                                    provider.drawCardsFromDiscard(
                                        provider.turn.currentPlayer);
                                  },
                                  cards: provider.discards,
                                ),
                              ],
                            ),
                            if (provider.buttonWidget != null && provider.showTrump)
                              provider.buttonWidget!,
                          ],
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.topCenter,
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 16.0, right: 16.0, top: 4.0),
                        child: CardList(
                          player: provider.players[1],
                        ),
                      ),
                    ),
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
                                ...provider.additionalButtons,
                                if (provider.turn.currentPlayer ==
                                    provider.players[0])
                                  ElevatedButton(
                                    onPressed: provider.canEndTurn
                                        ? () {
                                            provider.endTurn();
                                          }
                                        : null,
                                    child: const Text("End Turn"),
                                  ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                bottom: 4.0, left: 16.0, right: 16.0),
                            child: CardList(
                              player: provider.players[0],
                              onPlayCard: (CardModel card) {
                                provider.playCard(
                                    card: card, player: provider.players[0]);
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
              child: const Text("New Game"),
              onPressed: () {
                final players = [
                  PlayerModel(name: "Mark", isHuman: true),
                  PlayerModel(name: "Bot", isHuman: false)
                ];
                provider.newGame(players);
              },
            ),
          );
  }
}
