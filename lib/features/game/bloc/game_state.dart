import '../../../core/models/board.dart';
import '../../../core/models/piece.dart';

class GameState {
  final ChessBoard board;
  final Side activeSide;
  final int? selectedIndex;
  final List<int> validMoves;

  // 1. Добавляем новое поле для победителя
  final String? winner;

  GameState({
    required this.board,
    this.activeSide = Side.white,
    this.selectedIndex,
    this.validMoves = const [],
    this.winner, // Передаем в конструктор
  });

  // 2. Метод copyWith — это "магия" обновления.
  // Он берет текущие значения и заменяет только те, что ты передал.
  GameState copyWith({
    ChessBoard? board,
    Side? activeSide,
    int? selectedIndex,
    List<int>? validMoves,
    String? winner,
  }) {
    return GameState(
      board: board ?? this.board,
      activeSide: activeSide ?? this.activeSide,
      // Тут важно: если мы передаем null в selectedIndex,
      // это значит, что мы хотим снять выделение.
      selectedIndex: selectedIndex,
      validMoves: validMoves ?? this.validMoves,
      winner: winner ?? this.winner,
    );
  }
}
