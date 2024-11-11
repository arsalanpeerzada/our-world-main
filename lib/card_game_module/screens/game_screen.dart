
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../live_screen/model/streaming_request_model.dart';
import '../components/game_board.dart';
import '../models/player_model.dart';
import '../providers/thirty_one_game_provider.dart';

class CardGameScreen extends StatefulWidget {
  const CardGameScreen({super.key, required this.streamingRequestsModelList});
  final List<StreamingRequestsModel> streamingRequestsModelList;

  @override
  State<CardGameScreen> createState() => _CardGameScreenState();
}

class _CardGameScreenState extends State<CardGameScreen> {
  late final ThirtyOneGameProvider _gameProvider;

  @override
  void initState() {
    _gameProvider = Provider.of<ThirtyOneGameProvider>(context, listen: false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Card Game"),
        actions: [
          TextButton(
            onPressed: () async {
              final players = [
                PlayerModel(name: "Tester1", isHuman: true),
                PlayerModel(name: "Tester", isHuman: false),
              ];

              await _gameProvider.newGame(players);
            },
            child: const Text(
              "New Game",
              style: TextStyle(color: Colors.black),
            ),
          )
        ],
      ),
      body: const GameBoard(),
    );
  }
}
