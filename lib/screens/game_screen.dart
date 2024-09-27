import 'package:card_game/components/game_board.dart';
import 'package:card_game/models/player_model.dart';
import 'package:card_game/providers/crazy_eights_game_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

late final CrazyEightsGameProvider _gameProvider;

class _GameScreenState extends State<GameScreen> {
  @override
  void initState() {
    _gameProvider = Provider.of<CrazyEightsGameProvider>(context, listen: false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey[800],
        foregroundColor: Colors.white,
        title: const Text("Crazy Eights"),
        actions: [
          TextButton(
            onPressed: () async {
              final players = [
                PlayerModel(name: "Mark", isHuman: true),
                PlayerModel(name: "Bot", isHuman: false)
              ];

              await _gameProvider.newGame(players);
            },
            child: const Text(
              "New game",
              style: TextStyle(color: Color.fromARGB(255, 244, 115, 214)),
            ),
          ),
        ],
      ),
      body: const GameBoard(),
    );
  }
}
