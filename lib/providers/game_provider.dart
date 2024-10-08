import 'package:card_game/constants.dart';
import 'package:card_game/main.dart';
import 'package:card_game/models/card_model.dart';
import 'package:card_game/models/deck_model.dart';
import 'package:card_game/models/player_model.dart';
import 'package:card_game/models/turn_model.dart';
import 'package:card_game/services/deck_service.dart';
import 'package:flutter/material.dart';


class ActionButton{
  final String label;
  final Function() onPressed;

  ActionButton({required this.label, required this.onPressed});
}
abstract class GameProvider with ChangeNotifier {
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

  Map<String, dynamic> gameState = {};
  Widget? buttonWidget;

  List<Widget> additionalButtons = [];

  Future<void> newGame(List<PlayerModel> players) async {
    final deck = await _service.newDeck();
    _currentDeck = deck;
    _players = players;
    _discards = [];
    setupBoard();
    _turn = TurnModel(players: players, currentPlayer: players.first);

    notifyListeners();
  }

  Future<void> setupBoard() async {}

  Future<void> drawCardToDiscardPile({int count = 1}) async {
    final draw = await _service.drawCards(_currentDeck!, count: count);
    _discards.addAll(draw.cards);
    _currentDeck!.remaining = draw.remaining;

    notifyListeners();
  }

  void setBottomWidget(Widget? widget) {
    buttonWidget = widget;
    notifyListeners();
  }

  bool get showTrump {
    return true;
  }

  void setTrump(Suit suit) {
    setBottomWidget(Padding(
      padding: const EdgeInsets.all(4.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          color: CardModel.suitToColor(suit),
        ),
        child: Card(
          child: Text(
            CardModel.suitToUnicode(suit),
            style: TextStyle(
              color: CardModel.suitToColor(suit),
              fontSize: 32,
            ),
          ),
        ),
      ),
    ));
  }

  void setLastPlayed(CardModel card) {
    gameState[GS_LAST_SUIT] = card.suit;
    gameState[GS_LAST_VALUE] = card.value;

    setTrump(card.suit);

    notifyListeners();
  }

  bool get canDrawCard {
    return _turn.drawCount < 1;
  }

  Future<void> drawCards(PlayerModel player,
      {int count = 1, bool allowAnyTime = false}) async {
    if (_currentDeck == null) return;
    if (!allowAnyTime && !canDrawCard) return;

    final draw = await _service.drawCards(_currentDeck!, count: count);
    player.addCards(draw.cards);
    _turn.drawCount += count;
    _currentDeck!.remaining = draw.remaining;

    notifyListeners();
  }

  bool canPlayCard(CardModel card) {
    if(gameIsOver) return false;

    return _turn.actionCount < 1;
  }

  Future<void> playCard({
    required CardModel card,
    required PlayerModel player,
  }) async {
    if (!canPlayCard(card)) return;

    player.removeCard(card);
    _discards.add(card);
    _turn.actionCount += 1;

    setLastPlayed(card);
    await applyCardSideEffects(card);

    if(gameIsOver){
      finishGame();
    }

    notifyListeners();
  }

  bool canDrawCardFromDiscardPile({int count = 1}){
    if(!canDrawCard) return false;

    return discards.length >= count;
  }

  void drawCardsFromDiscard(PlayerModel player, {int count = 1}){
    if(!canDrawCardFromDiscardPile(count: count)){
      return;
    }
    final start = discards.length - count;
    final end = discards.length;

    final cards = discards.getRange(start, end).toList();
    discards.removeRange(start, end);

    player.addCards(cards);
    turn.drawCount += count;

    notifyListeners();
  }

  Future<void> applyCardSideEffects(CardModel card) async {}

  bool get canEndTurn {
    return turn.drawCount > 0;
  }

  void endTurn() {
    _turn.nextTurn();

    if (turn.currentPlayer.isBot) {
      botTurn();
    }
    notifyListeners();
  }

  void skipTurn() {
    _turn.nextTurn();
    _turn.nextTurn();

    notifyListeners();
  }

  bool get gameIsOver {
    return currentDeck!.remaining < 1;
  }

  void finishGame(){
    showToast("Game over");

    notifyListeners();
  }

  Future<void> botTurn() async {
    await Future.delayed(const Duration(milliseconds: 500));
    await drawCards(_turn.currentPlayer);
    await Future.delayed(const Duration(milliseconds: 500));

    if (_turn.currentPlayer.cards.isNotEmpty) {
      await Future.delayed(const Duration(milliseconds: 1000));
      playCard(
          player: _turn.currentPlayer, card: _turn.currentPlayer.cards.first);
    }
    if (canEndTurn) {
      endTurn();
    }
  }

  void showToast(String message, {int seconds = 3, SnackBarAction? action}) {
    rootScaffoldMessengerKey.currentState!.showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: seconds),
        action: action,
      ),
    );
  }

}
