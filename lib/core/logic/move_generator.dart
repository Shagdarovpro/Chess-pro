import '../models/board.dart';
import '../models/piece.dart';

class MoveGenerator {
  /// Основной метод: возвращает только ТЕ ходы, которые не оставляют своего короля под ударом
  static List<int> getValidMoves(int index, ChessBoard board) {
    final piece = board.squares[index];
    if (piece == null) return [];

    // 1. Получаем все теоретически возможные ходы фигуры
    List<int> pseudoLegalMoves = _getRawMoves(index, board);
    List<int> legalMoves = [];

    // 2. Фильтруем их: имитируем ход и проверяем, не под шахом ли король
    for (int targetIndex in pseudoLegalMoves) {
      if (!_isKingUnderAttackAfterMove(index, targetIndex, board)) {
        legalMoves.add(targetIndex);
      }
    }

    return legalMoves;
  }

  /// Получение всех ходов без проверки на шах (псевдо-легальные ходы)
  static List<int> _getRawMoves(int index, ChessBoard board) {
    final piece = board.squares[index];
    if (piece == null) return [];

    final int x = index % 8;
    final int y = index ~/ 8;
    final Side side = piece.side;

    return switch (piece.type) {
      PieceType.pawn   => _getPawnMoves(x, y, side, board),
      PieceType.knight => _getKnightMoves(x, y, side, board),
      PieceType.bishop => _getSlidingMoves(x, y, side, board, [[-1, -1], [-1, 1], [1, -1], [1, 1]]),
      PieceType.rook   => _getSlidingMoves(x, y, side, board, [[0, 1], [0, -1], [1, 0], [-1, 0]]),
      PieceType.queen  => _getSlidingMoves(x, y, side, board, [[0, 1], [0, -1], [1, 0], [-1, 0], [-1, -1], [-1, 1], [1, -1], [1, 1]]),
      PieceType.king   => _getKingMoves(x, y, side, board),
    };
  }

  // --- ПРОВЕРКА ШАХА ---

  static bool _isKingUnderAttackAfterMove(int from, int to, ChessBoard board) {
    final side = board.squares[from]!.side;
    
    // Создаем временную копию доски для симуляции хода
    List<ChessPiece?> tempSquares = List.from(board.squares);
    tempSquares[to] = tempSquares[from];
    tempSquares[from] = null;
    final tempBoard = ChessBoard(tempSquares);

    // Ищем, где сейчас король этого цвета
    int kingIndex = -1;
    for (int i = 0; i < 64; i++) {
      final p = tempBoard.squares[i];
      if (p != null && p.type == PieceType.king && p.side == side) {
        kingIndex = i;
        break;
      }
    }

    if (kingIndex == -1) return false; // Король уже съеден (в нормальной игре не бывает)

    // Проверяем, может ли любая фигура противника ударить по клетке короля
    final opponentSide = (side == Side.white) ? Side.black : Side.white;
    for (int i = 0; i < 64; i++) {
      final p = tempBoard.squares[i];
      if (p != null && p.side == opponentSide) {
        // Важно: используем _getRawMoves, чтобы не уйти в бесконечную рекурсию
        if (_getRawMoves(i, tempBoard).contains(kingIndex)) {
          return true;
        }
      }
    }
    return false;
  }

  // --- ЛОГИКА ФИГУР ---

  static List<int> _getSlidingMoves(int x, int y, Side side, ChessBoard board, List<List<int>> dirs) {
    List<int> moves = [];
    for (var d in dirs) {
      int nx = x + d[0], ny = y + d[1];
      while (board.isOnBoard(nx, ny)) {
        final t = board.getPieceAt(nx, ny);
        if (t == null) {
          moves.add(ny * 8 + nx);
        } else {
          if (t.side != side) moves.add(ny * 8 + nx);
          break;
        }
        nx += d[0]; ny += d[1];
      }
    }
    return moves;
  }

  static List<int> _getPawnMoves(int x, int y, Side side, ChessBoard board) {
    List<int> moves = [];
    int dir = (side == Side.white) ? -1 : 1;
    if (board.isOnBoard(x, y + dir) && board.getPieceAt(x, y + dir) == null) {
      moves.add((y + dir) * 8 + x);
      bool isStart = (side == Side.white && y == 6) || (side == Side.black && y == 1);
      if (isStart && board.getPieceAt(x, y + 2 * dir) == null) moves.add((y + 2 * dir) * 8 + x);
    }
    for (int dx in [-1, 1]) {
      int nx = x + dx, ny = y + dir;
      if (board.isOnBoard(nx, ny)) {
        final t = board.getPieceAt(nx, ny);
        if (t != null && t.side != side) moves.add(ny * 8 + nx);
      }
    }
    return moves;
  }

  static List<int> _getKnightMoves(int x, int y, Side side, ChessBoard board) {
    List<int> moves = [];
    final offsets = [[-2,-1],[-2,1],[-1,-2],[-1,2],[1,-2],[1,2],[2,-1],[2,1]];
    for (var o in offsets) {
      int nx = x + o[0], ny = y + o[1];
      if (board.isOnBoard(nx, ny)) {
        final t = board.getPieceAt(nx, ny);
        if (t == null || t.side != side) moves.add(ny * 8 + nx);
      }
    }
    return moves;
  }

  static List<int> _getKingMoves(int x, int y, Side side, ChessBoard board) {
    List<int> moves = [];
    for (int dx = -1; dx <= 1; dx++) {
      for (int dy = -1; dy <= 1; dy++) {
        if (dx == 0 && dy == 0) continue;
        int nx = x + dx, ny = y + dy;
        if (board.isOnBoard(nx, ny)) {
          final t = board.getPieceAt(nx, ny);
          if (t == null || t.side != side) moves.add(ny * 8 + nx);
        }
      }
    }
    return moves;
  }
}