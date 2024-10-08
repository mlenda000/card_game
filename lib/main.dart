import 'package:card_game/providers/game_provider.dart';
import 'package:card_game/providers/crazy_eights_game_provider.dart';
import 'package:card_game/providers/thirty_one_game_provider.dart';
import 'package:card_game/screens/game_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

final navigatorKey = GlobalKey<NavigatorState>();
final rootScaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

void main() {
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (_) => CrazyEightsGameProvider()),
    ChangeNotifierProvider(create: (_) => ThirtyOneGameProvider()),
  ], child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      scaffoldMessengerKey: rootScaffoldMessengerKey,
      title: 'Card Game',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const GameScreen(),
    );
  }
}
