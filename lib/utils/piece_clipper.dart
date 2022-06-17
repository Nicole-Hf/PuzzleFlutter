import 'package:flutter/material.dart';
import 'package:puzzle_kids/models/imagebox_model.dart';
import 'package:puzzle_kids/utils/block_painter_widget.dart';

class PuzzlePieceClipper extends CustomClipper<Path> {
  ImageBox imageBox;
  PuzzlePieceClipper({required this.imageBox});

  @override
  Path getClip(Size size) {
    return getPiecePath1(
      size, 
      imageBox.radiusPoint, 
      imageBox.offsetCenter,
      imageBox.posSide);
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}