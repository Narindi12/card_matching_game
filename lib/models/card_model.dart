// lib/models/card_model.dart

class CardModel {
  final String id;
  final String imagePath;
  bool isFaceUp;
  bool isMatched;

  CardModel({
    required this.id,
    required this.imagePath,
    this.isFaceUp = false,
    this.isMatched = false,
  });
}
