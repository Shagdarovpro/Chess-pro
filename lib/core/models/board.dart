import 'piece.dart';

class ChessBoard {
  final List<ChessPiece?> squares;

  ChessBoard(this.squares);

  /// Начальная расстановка шахматной доски
  factory ChessBoard.initial() {
    // Создаем пустую доску (64 клетки)
    final squares = List<ChessPiece?>.filled(64, null);

    // --- ЧЕРНЫЕ ФИГУРЫ (Верх доски) ---

    // Тыл: Ладья, Конь, Слон, Ферзь, Король, Слон, Конь, Ладья
    _setRow(squares, 0, Side.black, [
      PieceType.rook,
      PieceType.knight,
      PieceType.bishop,
      PieceType.queen,
      PieceType.king,
      PieceType.bishop,
      PieceType.knight,
      PieceType.rook,
    ]);

    // Пешки (ряд 1, индексы 8-15)
    for (int i = 8; i < 16; i++) {
      squares[i] = ChessPiece(PieceType.pawn, Side.black);
    }

    // --- БЕЛЫЕ ФИГУРЫ (Низ доски) ---

    // Пешки (ряд 6, индексы 48-55)
    for (int i = 48; i < 56; i++) {
      squares[i] = ChessPiece(PieceType.pawn, Side.white);
    }

    // Тыл: Ладья, Конь, Слон, Ферзь, Король, Слон, Конь, Ладья
    _setRow(squares, 56, Side.white, [
      PieceType.rook,
      PieceType.knight,
      PieceType.bishop,
      PieceType.queen,
      PieceType.king,
      PieceType.bishop,
      PieceType.knight,
      PieceType.rook,
    ]);

    return ChessBoard(squares);
  }

  /// Вспомогательный метод для заполнения целого ряда фигур
  static void _setRow(
    List<ChessPiece?> squares,
    int start,
    Side side,
    List<PieceType> types,
  ) {
    for (int i = 0; i < 8; i++) {
      squares[start + i] = ChessPiece(types[i], side);
    }
  }

  // Проверка: находится ли координата в пределах доски 8x8
  bool isOnBoard(int x, int y) => x >= 0 && x < 8 && y >= 0 && y < 8;

  // Получение фигуры по координатам X и Y
  ChessPiece? getPieceAt(int x, int y) => squares[y * 8 + x];
}
