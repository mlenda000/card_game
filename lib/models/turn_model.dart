import 'package:card_game/models/card_model.dart';
import 'package:card_game/models/player_model.dart';

class TurnModel {
  final List<PlayerModel> players;
  int index;
  PlayerModel currentPlayer;
  int drawCount;
  int actionCount;

  TurnModel(
      {required this.players,
      required this.currentPlayer,
      this.index = 0,
      this.drawCount = 0,
      this.actionCount = 0});

  void nextTurn() {
    index += 1;
    currentPlayer = index % 2 == 0 ? players[0] : players[1];
    drawCount = 0;
    actionCount = 0;
  }

  PlayerModel get otherPlayer {
    return players.firstWhere((p) => p != currentPlayer);
  }

  int getPlayerNumber(String name) {
    final player = players.firstWhere((p) => p.name == name);
    return players.indexOf(player) + 1;
  }
}
