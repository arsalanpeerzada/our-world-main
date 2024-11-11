import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:simple_chess_board/models/board_arrow.dart';
import 'package:chess/chess.dart' as chesslib;
import 'package:simple_chess_board/models/piece_type.dart';
import 'package:simple_chess_board/models/short_move.dart';
import 'package:simple_chess_board/widgets/chessboard.dart';
import 'package:streaming_post_demo/game_screens/game_lost.dart';

class ChessGameRoom extends StatefulWidget {
  const ChessGameRoom({
    Key? key,
  }) : super(key: key);

  @override
  State<ChessGameRoom> createState() => _ChessGameRoomState();
}

class _ChessGameRoomState extends State<ChessGameRoom> {
  final _chess = chesslib.Chess.fromFEN(chesslib.Chess.DEFAULT_POSITION);
  var _blackAtBottom = false;
  BoardArrow? _lastMoveArrowCoordinates;
  late ChessBoardColors _boardColors;

  @override
  void initState() {
    _boardColors = ChessBoardColors()
      ..lightSquaresColor = const Color(0xFFf6e1c0)
      ..darkSquaresColor = const Color(0xFFB88667)
      ..coordinatesZoneColor = Color(0xFFB88667)
      ..lastMoveArrowColor = const Color.fromARGB(255, 180, 195, 197)
      ..startSquareColor = Colors.orange
      ..endSquareColor = Colors.green
      ..circularProgressBarColor = Colors.yellow
      ..coordinatesColor = Colors.black;
    super.initState();
  }

  void _checkForCheckmate() {
    if (_chess.in_checkmate) {
      showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            title: const Text('Checkmate'),
            content: Text(_chess.turn == chesslib.Color.WHITE
                ? 'Black wins!'
                : 'White wins!'),
            actions: <Widget>[
              TextButton(
                child: const Text('Restart Game'),
                onPressed: () {
                  // Restart the game here
                  _chess.reset();
                  Navigator.of(context).pop(); // Close the dialog
                  setState(() {}); // Refresh the UI
                },
              ),
            ],
          );
        },
      );
    }
  }

  void tryMakingMove({required ShortMove move}) {
    final success = _chess.move(<String, String?>{
      'from': move.from,
      'to': move.to,
      'promotion': move.promotion?.name,
    });
    if (success) {
      setState(() {
        _lastMoveArrowCoordinates = BoardArrow(from: move.from, to: move.to);
      });
      _checkForCheckmate();
    }
  }

  Future<PieceType?> handlePromotion(BuildContext context) {
    final navigator = Navigator.of(context);
    return showDialog<PieceType>(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: const Text('Promotion'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: const Text("Queen"),
                onTap: () => navigator.pop(PieceType.queen),
              ),
              ListTile(
                title: const Text("Rook"),
                onTap: () => navigator.pop(PieceType.rook),
              ),
              ListTile(
                title: const Text("Bishop"),
                onTap: () => navigator.pop(PieceType.bishop),
              ),
              ListTile(
                title: const Text("Knight"),
                onTap: () => navigator.pop(PieceType.knight),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return
      // Scaffold(
      // backgroundColor: Color(0xFFf6e1c0),
      // // appBar: AppBar(
      // //   backgroundColor: Color(0xFFf6e1c0),
      // //   title: Text('Chess Game'),
      // //   centerTitle: true,
      // //   automaticallyImplyLeading: false,
      // //   actions: [
      // //     IconButton(
      // //       onPressed: () {
      // //         setState(() {
      // //           _blackAtBottom = !_blackAtBottom;
      // //         });
      // //       },
      // //       icon: const Icon(Icons.swap_vert),
      // //     ),
      // //     TextButton(
      // //         onPressed: () {
      // //           Get.to(const GameLossScreen());
      // //           // Navigator.push(
      // //           //     context,
      // //           //     MaterialPageRoute(builder: (context)=>GameLossScreen())
      // //           // );
      // //         },
      // //         child: Text("Quit"))
      // //   ],
      // // ),
      // body:
      Center(
        child:
        SizedBox(
          height: MediaQuery.of(context).size.height/2,
          // child: SimpleChessBoard(
          //     chessBoardColors: _boardColors,
          //     engineThinking: false,
          //     fen: _chess.fen,
          //     onMove: tryMakingMove,
          //     blackSideAtBottom: _blackAtBottom,
          //     whitePlayerType: PlayerType.human,
          //     blackPlayerType: PlayerType.human,
          //     lastMoveToHighlight: _lastMoveArrowCoordinates,
          //     onPromote: () => handlePromotion(context),
          //     onPromotionCommited: ({
          //       required ShortMove moveDone,
          //       required PieceType pieceType,
          //     }) {
          //       moveDone.promotion = pieceType;
          //       tryMakingMove(move: moveDone);
          //     }),
        ),
      // ),
    );
  }
}
