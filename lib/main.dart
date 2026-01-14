import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:chess_middle/core/models/piece.dart';
import 'package:chess_middle/features/game/bloc/game_cubit.dart';
import 'package:chess_middle/features/game/bloc/game_state.dart';

void main() => runApp(const ChessApp());

class ChessApp extends StatelessWidget {
  const ChessApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: const ChessGamePage(),
    );
  }
}

class ChessGamePage extends StatelessWidget {
  const ChessGamePage({super.key});

  void _showWinDialog(BuildContext context, String winner) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        title: const Text("Мат!"),
        content: Text("Победитель: $winner"),
        actions: [
          TextButton(
            onPressed: () {
              context.read<GameCubit>().resetGame();
              Navigator.pop(ctx);
            },
            child: const Text("Новая игра"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => GameCubit(),
      child: BlocListener<GameCubit, GameState>(
        listenWhen: (prev, curr) =>
            prev.winner == null && curr.winner != null,
        listener: (context, state) =>
            _showWinDialog(context, state.winner!),
        child: Scaffold(
          backgroundColor: const Color(0xFF262421),
          appBar: AppBar(
            title: const Text('Chess Middle Engine'),
            backgroundColor: Colors.black26,
            centerTitle: true,
          ),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const _TurnIndicator(),
              const SizedBox(height: 20),
              const Center(child: _ChessBoardWidget()),
              const SizedBox(height: 30),
              _ResetButton(),
            ],
          ),
        ),
      ),
    );
  }
}

class _ChessBoardWidget extends StatelessWidget {
  const _ChessBoardWidget();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size.width * 0.96;

    return BlocBuilder<GameCubit, GameState>(
      builder: (context, state) {
        return Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black, width: 2),
          ),
          child: GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate:
                const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 8,
            ),
            itemCount: 64,
            itemBuilder: (context, index) {
              final x = index % 8;
              final y = index ~/ 8;
              final isDark = (x + y) % 2 != 0;

              final isSelected = state.selectedIndex == index;
              final isValidMove = state.validMoves.contains(index);
              final piece = state.board.squares[index];

              return GestureDetector(
                onTap: () =>
                    context.read<GameCubit>().onSquareTap(index),
                child: Container(
                  color: isSelected
                      ? Colors.yellow.withValues(alpha: 0.5)
                      : (isDark
                          ? const Color(0xFF7D945D)
                          : const Color(0xFFEEEED2)),
                  child: Stack(
                    children: [
                      if (x == 0)
                        _Coord(
                          text: '${8 - y}',
                          align: Alignment.topLeft,
                          isDark: isDark,
                        ),
                      if (y == 7)
                        _Coord(
                          text:
                              String.fromCharCode(97 + x),
                          align: Alignment.bottomRight,
                          isDark: isDark,
                        ),
                      if (piece != null)
                        Center(
                          child: _PieceWidget(piece: piece),
                        ),
                      if (isValidMove)
                        Center(
                          child: Container(
                            width: 16,
                            height: 16,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: piece == null
                                  ? Colors.black
                                      .withValues(alpha: 0.2)
                                  : Colors.red
                                      .withValues(alpha: 0.4),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}

class _PieceWidget extends StatelessWidget {
  final ChessPiece piece;
  const _PieceWidget({required this.piece});

  @override
  Widget build(BuildContext context) {
    final isWhite = piece.side == Side.white;

    return Text(
      _unicode(piece.type, piece.side),
      style: TextStyle(
        fontSize: 40,
        color: isWhite ? Colors.white : Colors.black,
        shadows: [
          if (isWhite)
            const Shadow(
              offset: Offset(1, 1),
              blurRadius: 1,
              color: Colors.black,
            ),
        ],
      ),
    );
  }

  String _unicode(PieceType type, Side side) {
    final w = side == Side.white;
    return switch (type) {
      PieceType.pawn   => w ? '♙' : '♟',
      PieceType.knight => w ? '♘' : '♞',
      PieceType.bishop => w ? '♗' : '♝',
      PieceType.rook   => w ? '♖' : '♜',
      PieceType.queen  => w ? '♕' : '♛',
      PieceType.king   => w ? '♔' : '♚',
    };
  }
}

class _TurnIndicator extends StatelessWidget {
  const _TurnIndicator();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GameCubit, GameState>(
      builder: (context, state) {
        final isWhite = state.activeSide == Side.white;
        return Container(
          padding:
              const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
          decoration: BoxDecoration(
            color: isWhite ? Colors.white : Colors.black,
            borderRadius: BorderRadius.circular(25),
            border: Border.all(color: Colors.brown, width: 2),
          ),
          child: Text(
            isWhite ? "ХОД БЕЛЫХ" : "ХОД ЧЕРНЫХ",
            style: TextStyle(
              color: isWhite ? Colors.black : Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        );
      },
    );
  }
}

class _Coord extends StatelessWidget {
  final String text;
  final Alignment align;
  final bool isDark;

  const _Coord({
    required this.text,
    required this.align,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: align,
      child: Padding(
        padding: const EdgeInsets.all(2),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 9,
            color: isDark ? Colors.white30 : Colors.black26,
          ),
        ),
      ),
    );
  }
}

class _ResetButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () =>
          context.read<GameCubit>().resetGame(),
      icon: const Icon(Icons.refresh),
      label: const Text("Новая игра"),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.brown[700],
      ),
    );
  }
}
