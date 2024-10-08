import 'package:card_game/components/suit_chooser_modal.dart';
import 'package:card_game/constants.dart';
import 'package:card_game/main.dart';
import 'package:card_game/models/card_model.dart';
import 'package:card_game/providers/game_provider.dart';
import 'package:flutter/material.dart';

class CrazyEightsGameProvider extends GameProvider {
  @override
  Future<void> setupBoard() async {
    // Setup the board
    for (var p in players) {
      await drawCards(p, count: 8, allowAnyTime: true);
    }

    await drawCardToDiscardPile();

    setLastPlayed(discardTop!);

    turn.drawCount = 0;
    turn.actionCount = 0;
  }

  @override
  bool canPlayCard(CardModel card) {
    bool canPlay = false;

    if (gameState[GS_LAST_SUIT] == null || gameState[GS_LAST_VALUE] == null) {
      return false;
    }
    if (card.suit == gameState[GS_LAST_SUIT]) {
      canPlay = true;
    }
    if (card.value == gameState[GS_LAST_VALUE]) {
      canPlay = true;
    }
    if (card.value == "8") {
      canPlay = true;
    }

    return canPlay;
  }

  @override
  bool get canEndTurn {
    if (turn.drawCount > 0 || turn.actionCount > 0) return true;

    return false;
  }

  @override
  bool get gameIsOver {
    if (turn.currentPlayer.cards.isEmpty) {
      return true;
    }
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

  @override
  Future<void> applyCardSideEffects(CardModel card) async {
    // 8
    if (card.value == "8") {
      Suit suit;

      if (turn.currentPlayer.isHuman) {
        // show dialog
        suit = await showDialog(
            context: navigatorKey.currentContext!,
            builder: (_) => const SuitChooserModal(),
            barrierDismissible: false);
      } else {
        suit = turn.currentPlayer.cards.first.suit;
      }

      gameState[GS_LAST_SUIT] = suit;
      setTrump(suit);
      showToast(
          "${turn.currentPlayer.name} has changed it to ${CardModel.suitToString(suit)}");
    }
    // 2
    else if (card.value == "2") {
      await drawCards(turn.otherPlayer, count: 2, allowAnyTime: true);
      showToast("${turn.otherPlayer.name} has to draw 2 cards");
    }
    // J
    else if (card.value == "JACK") {
      showToast("${turn.otherPlayer.name} misses a turn");
      skipTurn();
    }
    // QS
    else if (card.value == "QUEEN" && card.suit == Suit.Spades) {
      await drawCards(turn.otherPlayer, count: 5, allowAnyTime: true);
      showToast("${turn.otherPlayer.name} has to draw 5 cards");
    }

    notifyListeners();
  }
}
