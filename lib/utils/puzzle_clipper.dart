import 'package:flutter/material.dart';
import 'package:puzzle_kids/utils/puzzle_painter.dart';

class PuzzlePieceClipper extends CustomClipper<Path> {
  final int row;
  final int col;
  final int maxRow;
  final int maxCol;

  PuzzlePieceClipper(
    this.row,
    this.col,
    this.maxRow,
    this.maxCol
  );

  @override
  Path getClip(Size size) {
    return getPiecePath(size, row, col, maxRow, maxCol);
  }


  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
  
}