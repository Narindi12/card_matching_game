// lib/screens/game_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/game_provider.dart';
import '../widgets/card_widget.dart';

class GameScreen extends StatelessWidget {
  const GameScreen({Key? key}) : super(key: key);

  String _formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Card Matching Game'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              Provider.of<GameProvider>(context, listen: false).resetGame();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Timer and Score
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Consumer<GameProvider>(
              builder: (context, gameProvider, child) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Time: ${_formatTime(gameProvider.elapsedSeconds)}',
                      style: TextStyle(fontSize: 20),
                    ),
                    Text(
                      'Score: ${gameProvider.score}',
                      style: TextStyle(fontSize: 20),
                    ),
                  ],
                );
              },
            ),
          ),
          Expanded(
            child: Consumer<GameProvider>(
              builder: (context, gameProvider, child) {
                if (gameProvider.isGameOver) {
                  // Show victory dialog after the current frame
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (_) => AlertDialog(
                        title: Text('Congratulations!'),
                        content: Text(
                            'You have matched all the cards!\nTime: ${_formatTime(gameProvider.elapsedSeconds)}\nScore: ${gameProvider.score}'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                              gameProvider.resetGame();
                            },
                            child: Text('Play Again'),
                          ),
                        ],
                      ),
                    );
                  });
                }

                return GridView.builder(
                  padding: EdgeInsets.all(16.0),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4, // 4x4 grid
                    mainAxisSpacing: 8.0,
                    crossAxisSpacing: 8.0,
                  ),
                  itemCount: gameProvider.cards.length,
                  itemBuilder: (context, index) {
                    final card = gameProvider.cards[index];
                    return CardWidget(card: card);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
