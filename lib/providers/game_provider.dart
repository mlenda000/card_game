

import 'package:card_game/models/card_model.dart';
import 'package:card_game/models/deck_model.dart';
import 'package:card_game/models/player_model.dart';
import 'package:card_game/models/turn_model.dart';
import 'package:card_game/services/deck_service.dart';
import 'package:flutter/material.dart';

class GameProvider with ChangeNotifier {

  GameProvider() {
    _service = DeckService();
  }
  late TurnModel _turn;
  TurnModel get turn => _turn;

  late DeckService _service;

  DeckModel? _currentDeck;
  DeckModel? get currentDeck => _currentDeck;

  List<PlayerModel> _players = [];
  List<PlayerModel> get players => _players;

  List<CardModel> _discards = [];
  List<CardModel> get discards => _discards;
  CardModel? get discardTop => _discards.isEmpty ? null : _discards.last;

  Map<String, dynamic> gameState ={};

  Future<void> newGame(List<PlayerModel> players) async {
    final deck = await _service.newDeck();
    _currentDeck = deck;
    _players = players;
    _discards = [];
    _turn = TurnModel(players: players, currentPlayer: players.first);

    notifyListeners();
  }

  Future<void> setupBoard() async {

  }
  Future<void> drawCards(PlayerModel player, {int count=1}) async {
    if (_currentDeck == null) return;
    final draw = await _service.drawCards(_currentDeck!, count: count);
    player.addCards(draw.cards);
    _turn.drawCount += count;
    _currentDeck!.remaining = draw.remaining;

    notifyListeners();
  }

}