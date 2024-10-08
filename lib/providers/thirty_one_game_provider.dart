import 'package:card_game/components/suit_chooser_modal.dart';
import 'package:card_game/constants.dart';
import 'package:card_game/main.dart';
import 'package:card_game/models/card_model.dart';
import 'package:card_game/providers/game_provider.dart';
import 'package:flutter/material.dart';

class ThirtyOneGameProvider extends GameProvider {
  @override
  Future<void> setupBoard() async {
    // Setup the board
    for (var p in players) {
      await drawCards(p, count: 3, allowAnyTime: true);
    }

    await drawCardToDiscardPile();

    turn.drawCount = 0;
    turn.actionCount = 0;
  }

  
  @override
  bool get canEndTurn {
    return turn.drawCount == 1 && turn.actionCount == 1;
  }

  @override
  bool get canDrawCard {
    return turn.drawCount < 1;
  }

  @override
  bool canPlayCard(CardModel card) {
    return turn.drawCount == 1 && turn.actionCount < 1;
  }

  @override
  bool get showTrump {
    return false;
  }

  @override
  bool get gameIsOver {
    
    return false;
  }

  @override
  void finishGame() {
    showToast("Game over! ${turn.currentPlayer.name} WINS!");

    notifyListeners();
  }

  @override
  Future<void> botTurn() async {
    final p = turn.currentPlayer;

    await Future.delayed(const Duration(milliseconds: 500));
    for (final c in turn.currentPlayer.cards) {
      if (canPlayCard(c)) {
        await playCard(card: c, player: p);
        endTurn();
        return;
      }
    }
    await Future.delayed(const Duration(milliseconds: 500));
    await drawCards(p);
    await Future.delayed(const Duration(milliseconds: 500));

    if (canPlayCard(p.cards.last)) {
      await playCard(card: p.cards.last, player: p);
    }
    endTurn();
  }

 
}
