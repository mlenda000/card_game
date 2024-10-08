import 'package:card_game/components/game_board.dart';
import 'package:card_game/models/player_model.dart';
import 'package:card_game/providers/crazy_eights_game_provider.dart';
import 'package:card_game/providers/game_provider.dart';
import 'package:card_game/providers/thirty_one_game_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  String? _selectedGame;

  final List<String> _gameOptions = [
    "Crazy Eights",
    "Thirty One",
  ];

  @override
  void initState() {
    super.initState();
    _selectedGame = _gameOptions[0]; // Default to Crazy Eights
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey[800],
        foregroundColor: Colors.white,
        title: Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: const Text("Get ready to play!"),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            child: DropdownButton<String>(
              dropdownColor: Colors.blueGrey[800],
              style: const TextStyle(color: Colors.white),
              value: _selectedGame,
              onChanged: (String? newValue) {
                setState(() {
                  _selectedGame = newValue;
                });
              },
              items: _gameOptions.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Padding(
                    padding: const EdgeInsets.only(
                        top: 4, bottom: 4, left: 12, right: 12),
                    child: Text(value),
                  ),
                );
              }).toList(),
            ),
          ),
          TextButton(
            onPressed: () async {
              final players = [
                PlayerModel(name: "Mark", isHuman: true),
                PlayerModel(name: "Bot", isHuman: false),
              ];
              if (_selectedGame == "Crazy Eights") {
                await Provider.of<CrazyEightsGameProvider>(context, listen: false).newGame(players);
              } else {
                await Provider.of<ThirtyOneGameProvider>(context, listen: false).newGame(players);
              }
            },
            child: const Text(
              "New game",
              style: TextStyle(color: Color.fromARGB(255, 244, 115, 214)),
            ),
          ),
        ],
      ),
      body: Builder(
        builder: (context) {
          // Decide which provider to use based on selected game
          GameProvider model;
          if (_selectedGame == "Crazy Eights") {
            model = Provider.of<CrazyEightsGameProvider>(context);
          } else {
            model = Provider.of<ThirtyOneGameProvider>(context);
          }
          return GameBoard(provider: model);
        },
      ),
    );
  }
}
