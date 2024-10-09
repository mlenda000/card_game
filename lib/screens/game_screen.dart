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

  void _startNewGame(player1, selectedGame) async {
    final players = [
      PlayerModel(name: player1, isHuman: true),
      PlayerModel(name: "Bot", isHuman: false),
    ];
    if (selectedGame == "Crazy Eights") {
      await Provider.of<CrazyEightsGameProvider>(context, listen: false)
          .newGame(players);
    } else {
      await Provider.of<ThirtyOneGameProvider>(context, listen: false)
          .newGame(players);
    }
  }

  void _showNewGameDialog() {
    String? playerName = '';
    String? selectedGame = _selectedGame;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateSB) => AlertDialog(
            title: const Text("Start a New Game"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DropdownButton<String>(
                  value: selectedGame,
                  onChanged: (String? newValue) {
                    setStateSB(() {
                      selectedGame = newValue;
                    });
                    setState(() {
                      _selectedGame = newValue;
                    });
                  },
                  items: _gameOptions
                      .map<DropdownMenuItem<String>>((String value) {
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
                TextField(
                  decoration: const InputDecoration(
                    labelText: 'Player 1 Name',
                  ),
                  onChanged: (value) {
                    playerName = value;
                  },
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  if (playerName != null && playerName!.isNotEmpty) {
                    Navigator.of(context).pop();
                    _startNewGame(playerName!, _selectedGame!);
                  }
                },
                child: const Text("Start Game"),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text("Cancel"),
              ),
            ],
          ),
        );
      },
    );
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
        
          TextButton(
            onPressed: () async {
              _showNewGameDialog();
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
