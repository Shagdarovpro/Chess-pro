class ChessCoords {
  static int toIndex(int x, int y) => y * 8 + x;
  static int getX(int index) => index % 8;
  static int getY(int index) => index ~/ 8;

  // Конвертация для записи в PGN (например, 0 -> "a8")
  static String toAlgebraic(int index) {
    int x = getX(index);
    int y = getY(index);
    return '${String.fromCharCode(97 + x)}${8 - y}';
  }
}
