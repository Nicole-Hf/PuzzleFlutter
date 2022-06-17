// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:puzzle_kids/models/imagebox_model.dart';
import 'package:puzzle_kids/utils/block_painter_widget.dart';
import 'package:puzzle_kids/utils/piece_clipper.dart';

class JigsawBlockWidget extends StatefulWidget {
  ImageBox imageBox;

  JigsawBlockWidget({Key? key, required this.imageBox}) : super(key: key);

  @override
  State<JigsawBlockWidget> createState() => _JigsawBlockWidgetState();
}

class _JigsawBlockWidgetState extends State<JigsawBlockWidget> {
  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: PuzzlePieceClipper(imageBox: widget.imageBox),
      child: CustomPaint(
        foregroundPainter: JigsawBlockPainter(
          imageBox: widget.imageBox
        ),
        child: widget.imageBox.image
      ),
    );
  }
}