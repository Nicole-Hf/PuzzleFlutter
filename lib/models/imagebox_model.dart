import 'package:flutter/material.dart';
import 'package:puzzle_kids/models/puzzlepos_model.dart';

class ImageBox {
  Widget image;
  ClassJigsawPos posSide;
  Offset offsetCenter;
  Size size;
  double radiusPoint;
  bool isDone;

  ImageBox({
    required this.image,
    required this.posSide,
    required this.offsetCenter,
    required this.size,
    required this.radiusPoint,
    required this.isDone,
  });
}