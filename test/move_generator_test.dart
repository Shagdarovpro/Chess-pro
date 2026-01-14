import 'package:flutter_test/flutter_test.dart';
import 'package:chess_middle/core/models/board.dart';
import 'package:chess_middle/core/logic/move_generator.dart';

void main() {
  group('MoveGenerator Tests', () {
    test('Начальная позиция: у пешки должно быть 2 возможных хода', () {
      final board = ChessBoard.initial();
      // Индекс пешки e2 обычно 52 (зависит от твоей индексации)
      final moves = MoveGenerator.getValidMoves(52, board);

      expect(moves.length, 2); // e3 и e4
    });

    test('Фигура не может ходить, если игра закончена', () {
      // Здесь можно добавить тест на логику блокировки ходов при мате
    });
  });
}
