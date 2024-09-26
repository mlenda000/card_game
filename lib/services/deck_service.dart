import 'package:card_game/models/deck_model.dart';
import 'package:card_game/models/draw_model.dart';
import 'package:card_game/services/api_service.dart';

class DeckService extends ApiService {
  //Future is needed because it is an async function
  //deckCount is an optional parameter with a default value of 1 with the option for more decks if the game requires it 
  Future<DeckModel> newDeck([int deckCount = 1]) async {
    final data = await httpGet(
      '/deck/new/shuffle',
      params: {'deck_count': deckCount},
    );

    return DeckModel.fromJson(data);
  }

  Future<DrawModel> drawCards(DeckModel deck, {int count = 1}) async {
    final data = await httpGet(
      '/deck/${deck.deck_id}/draw', 
      params: {'count': count});

      return DrawModel.fromJson(data);
  }
}
