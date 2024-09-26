enum Suit {
  Hearts,
  Clubs,
  Diamonds,
  Spades,
  Other,
}

class CardModel {
  final String image;
  final String suit;
  final String value;

  CardModel({required this.image, required this.suit, required this.value});
}
