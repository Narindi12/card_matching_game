// lib/providers/game_provider.dart

import 'package:flutter/material.dart';
import '../models/card_model.dart';
import 'dart:math';
import 'dart:async';

class GameProvider with ChangeNotifier {
  List<CardModel> _cards = [];
  CardModel? _firstSelectedCard;
  CardModel? _secondSelectedCard;
  bool _isProcessing = false;

  // Timer and Score
  Timer? _timer;
  int _elapsedSeconds = 0;
  int _score = 0;

  GameProvider() {
    _initializeGame();
    _startTimer();
  }

  List<CardModel> get cards => _cards;
  int get elapsedSeconds => _elapsedSeconds;
  int get score => _score;

  void _initializeGame() {
    // Define the images for card fronts
    List<String> images = [
      'assets/images/image1.png',
      'assets/images/image2.png',
      'assets/images/image3.png',
      'assets/images/image4.png',
      'assets/images/image5.png',
      'assets/images/image6.png',
      'assets/images/image7.png',
      'assets/images/image8.png',
    ];

    // Duplicate the images to create pairs
    List<CardModel> tempCards = [];
    for (int i = 0; i < images.length; i++) {
      tempCards.add(CardModel(id: '$i-1', imagePath: images[i]));
      tempCards.add(CardModel(id: '$i-2', imagePath: images[i]));
    }

    // Shuffle the cards
    tempCards.shuffle(Random());

    _cards = tempCards;
    _elapsedSeconds = 0;
    _score = 0;
    _firstSelectedCard = null;
    _secondSelectedCard = null;
    _isProcessing = false;
    _timer?.cancel();
    _startTimer();
    notifyListeners();
  }

  void resetGame() {
    _initializeGame();
  }

  void flipCard(CardModel card) {
    if (_isProcessing || card.isFaceUp || card.isMatched) {
      return;
    }

    card.isFaceUp = true;
    notifyListeners();

    if (_firstSelectedCard == null) {
      _firstSelectedCard = card;
    } else {
      _secondSelectedCard = card;
      _isProcessing = true;

      // Check for a match
      if (_firstSelectedCard!.imagePath == _secondSelectedCard!.imagePath) {
        _firstSelectedCard!.isMatched = true;
        _secondSelectedCard!.isMatched = true;
        _score += 10; // Award points for a match
        _resetSelection();
        if (isGameOver) {
          _timer?.cancel();
        }
      } else {
        _score -= 5; // Deduct points for a mismatch
        // Flip back after a delay
        Future.delayed(Duration(seconds: 1), () {
          _firstSelectedCard!.isFaceUp = false;
          _secondSelectedCard!.isFaceUp = false;
          _resetSelection();
          notifyListeners();
        });
      }
    }
    notifyListeners();
  }

  void _resetSelection() {
    _firstSelectedCard = null;
    _secondSelectedCard = null;
    _isProcessing = false;
    notifyListeners();
  }

  bool get isGameOver {
    return _cards.every((card) => card.isMatched);
  }

  // Timer Logic
  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      _elapsedSeconds++;
      notifyListeners();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
