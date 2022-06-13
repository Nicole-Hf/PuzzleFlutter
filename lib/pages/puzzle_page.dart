// ignore_for_file: unnecessary_null_comparison

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:puzzle_kids/utils/puzzle_clipper.dart';

class PuzzlePiece extends StatefulWidget {
  final Image image;
  final Size imageSize;
  final int row;
  final int col;
  final int maxRow;
  final int maxCol;
  final Function bringToTop;
  final Function sendToBack;

  const PuzzlePiece({required Key key,
    required this.image,
    required this.imageSize,
    required this.row,
    required this.col,
    required this.maxRow,
    required this.bringToTop,
    required this.sendToBack,
    required this.maxCol}) : super(key: key);
  
  @override
  // ignore: library_private_types_in_public_api
  _PuzzlePieceState createState() => _PuzzlePieceState();
}

class _PuzzlePieceState extends State<PuzzlePiece> {
  double top = 0;
  double left = 0;
  bool isMovible = true;

  @override
  Widget build(BuildContext context) {
    final imageWidth = MediaQuery.of(context).size.width;
    final imageHeight = MediaQuery.of(context).size.height * MediaQuery.of(context).size.width / widget.imageSize.width;
    final pieceWidth = imageWidth / widget.maxCol;
    final pieceHeight = imageHeight / widget.maxRow;

    if (top == 0) {
      top = Random().nextInt((imageHeight - pieceHeight).ceil()).toDouble();
      top -= widget.row * pieceHeight;
    }

    if (left == 0) {
      left = Random().nextInt((imageWidth - pieceWidth).ceil()).toDouble();
      left -= widget.col * pieceWidth;
    }

    return Positioned(
      top: top,
      left: left,
      width: imageWidth,
      child: GestureDetector(
        onTap: () {
          if (isMovible) {
            widget.bringToTop(widget);
          }
        },
        onPanStart: (_) {
          if (isMovible) {
            widget.bringToTop(widget);
          }
        },
        onPanUpdate: (dragUpdateDetails) {
          if (isMovible) {
            setState(() {
              top += dragUpdateDetails.delta.dy;
              left += dragUpdateDetails.delta.dx;
              if(-10 < top && top < 10 && -10 < left && left < 10) {
                top = 0;
                left = 0;
                isMovible = false;
                widget.sendToBack(widget);
              }
            });
          }
        },
        child: ClipPath(
          /*child: CustomPaint(
            foregroundPainter: PuzzlePiecePainter(widget.row, widget.col, widget.maxRow, widget.maxCol),
            child: widget.image
          ),*/
          // ignore: sort_child_properties_last
          child: widget.image,
          clipper: PuzzlePieceClipper(widget.row, widget.col, widget.maxRow, widget.maxCol),
        ),
      )
    );
  }
}
