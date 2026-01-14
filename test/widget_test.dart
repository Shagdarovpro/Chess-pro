import 'package:flutter_test/flutter_test.dart';
import 'package:chess_middle/core/models/board.dart';
import 'package:chess_middle/core/models/piece.dart';

void main() {
  test('Начальная расстановка должна содержать 32 фигуры', () {
    final board = ChessBoard.initial();
    final piecesCount = board.squares.where((s) => s != null).length;
    
    expect(piecesCount, 32);
  });

  test('Белый король должен быть на своем месте (индекс 60)', () {
    final board = ChessBoard.initial();
    final piece = board.squares[60];
    
    expect(piece?.type, PieceType.king);
    expect(piece?.side, Side.white);
  });
}