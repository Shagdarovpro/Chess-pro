import 'dart:developer' as dev;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'game_state.dart';
import '../../../core/models/board.dart';
import '../../../core/models/piece.dart';
import '../../../core/logic/move_generator.dart';

class GameCubit extends Cubit<GameState> {
  GameCubit() : super(GameState(board: ChessBoard.initial()));

  /// Главная точка входа: обработка нажатия на клетку
  void onSquareTap(int index) {
    // Если игра уже закончена, клики не обрабатываем
    if (state.winner != null) return;

    final clickedPiece = state.board.squares[index];
    
    // 1. Выбор своей фигуры
    if (clickedPiece != null && clickedPiece.side == state.activeSide) {
      _selectPiece(index);
    } 
    // 2. Попытка сделать ход выбранной фигурой
    else if (state.selectedIndex != null && state.validMoves.contains(index)) {
      _makeMove(state.selectedIndex!, index);
    } 
    // 3. Сброс выделения при клике "мимо"
    else {
      _clearSelection();
    }
  }

  /// Логика выделения фигуры
  void _selectPiece(int index) {
    // Получаем ходы, которые уже отфильтрованы MoveGenerator на наличие шаха
    final moves = MoveGenerator.getValidMoves(index, state.board);
    
    dev.log('Selected $index. Moves found: ${moves.length}', name: 'Chess.Cubit');
    
    emit(state.copyWith(
      selectedIndex: index,
      validMoves: moves,
    ));
  }

  /// Логика выполнения хода
  void _makeMove(int from, int to) {
    final List<ChessPiece?> newSquares = List.from(state.board.squares);
    final targetPiece = newSquares[to];
    
    // Передвигаем фигуру в массиве
    newSquares[to] = newSquares[from];
    newSquares[from] = null;

    final nextSide = state.activeSide == Side.white ? Side.black : Side.white;
    final newBoard = ChessBoard(newSquares);

    dev.log('Move: $from to $to. Next turn: $nextSide', name: 'Chess.Cubit');

    // Обновляем состояние
    emit(state.copyWith(
      board: newBoard,
      selectedIndex: null,
      validMoves: [],
      activeSide: nextSide,
    ));

    // Проверяем, не привел ли этот ход к завершению игры
    _checkGameStatus(nextSide, newBoard, targetPiece);
  }

  /// Проверка на мат или взятие короля
  void _checkGameStatus(Side nextSide, ChessBoard board, ChessPiece? capturedPiece) {
    // 1. Если съеден король (упрощенный вариант победы)
    if (capturedPiece != null && capturedPiece.type == PieceType.king) {
      final winnerName = (nextSide == Side.white) ? "Черные" : "Белые";
      _finishGame(winnerName);
      return;
    }

    // 2. Проверка на мат: ищем, есть ли хоть один легальный ход у следующего игрока
    bool hasAnyMove = false;
    for (int i = 0; i < 64; i++) {
      final piece = board.squares[i];
      if (piece != null && piece.side == nextSide) {
        if (MoveGenerator.getValidMoves(i, board).isNotEmpty) {
          hasAnyMove = true;
          break;
        }
      }
    }

    // Если ходов нет — это мат (или пат)
    if (!hasAnyMove) {
      final winnerName = (nextSide == Side.white) ? "Черные" : "Белые";
      _finishGame(winnerName);
    }
  }

  /// Завершение игры
  void _finishGame(String winnerName) {
    dev.log('GAME OVER. Winner: $winnerName', name: 'Chess.Logic');
    emit(state.copyWith(winner: winnerName));
  }

  /// Очистка выделения
  void _clearSelection() {
    emit(state.copyWith(
      selectedIndex: null,
      validMoves: [],
    ));
  }

  /// Новая игра
  void resetGame() {
    dev.log('Restarting game...', name: 'Chess.Cubit');
    emit(GameState(
      board: ChessBoard.initial(),
      activeSide: Side.white,
      selectedIndex: null,
      validMoves: [],
      winner: null,
    ));
  }
}