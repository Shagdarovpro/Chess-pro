enum PieceType { pawn, knight, bishop, rook, queen, king }

enum Side { white, black }

class ChessPiece {
  final PieceType type;
  final Side side;

  // Позиционный конструктор: сначала тип, потом сторона
  ChessPiece(this.type, this.side);
}
