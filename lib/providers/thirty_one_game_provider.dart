import 'dart:math';
import 'package:card_game/models/card_model.dart';
import 'package:card_game/providers/game_provider.dart';

const GS_PLAYER_HAS_KNOCKED = "GS_PLAYER_HAS_KNOCKED";

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
  List<ActionButton> get additionalButtons {
    return ([
      ActionButton(
          label: "Knock",
          onPressed: () {
            gameState[GS_PLAYER_HAS_KNOCKED] = turn.currentPlayer;

            endTurn();
          })
    ]);
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
    if (gameState[GS_PLAYER_HAS_KNOCKED] != null &&
        gameState[GS_PLAYER_HAS_KNOCKED] == turn.currentPlayer) {
      return true;
    }
    return false;
  }

  @override
  void finishGame() {
    for (final p in players) {
      int diamondPoints = 0;
      int spadePoints = 0;
      int clubsPoints = 0;
      int heartsPoints = 0;
      for (final c in p.cards) {
        int points = 0;

        switch (c.value) {
          case "KING":
          case "QUEEN":
          case "JACK":
            points += 10;
            break;
          case "ACE":
            points += 11;
            break;
          default:
            points += int.parse(c.value);
        }
        switch (c.suit) {
          case Suit.Clubs:
            clubsPoints += points;
            break;
          case Suit.Diamonds:
            diamondPoints += points;
            break;
          case Suit.Hearts:
            heartsPoints += points;
            break;
          case Suit.Spades:
            spadePoints += points;
          default:
            break;
        }
      }
      final totalPoints = [
        spadePoints,
        heartsPoints,
        clubsPoints,
        diamondPoints
      ].fold(spadePoints, max);

      p.score = totalPoints;
      print(p.score);
      showToast("Game over! ${p.name} WINS!");

      notifyListeners();
    }
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
