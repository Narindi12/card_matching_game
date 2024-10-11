// lib/widgets/card_widget.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/card_model.dart';
import '../providers/game_provider.dart';

class CardWidget extends StatelessWidget {
  final CardModel card;

  const CardWidget({Key? key, required this.card}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final gameProvider = Provider.of<GameProvider>(context, listen: false);

    return GestureDetector(
      onTap: () {
        gameProvider.flipCard(card);
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.blueGrey,
          borderRadius: BorderRadius.circular(8.0),
          image: DecorationImage(
            image: AssetImage(card.isFaceUp ? card.imagePath : 'assets/images/back.png'),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
