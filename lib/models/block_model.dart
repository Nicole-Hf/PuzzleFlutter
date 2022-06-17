import 'package:flutter/material.dart';
import 'package:puzzle_kids/utils/block_widget.dart';

class BlockClass {
  Offset offset;
  Offset offsetDefault;
  JigsawBlockWidget jigsawBlockWidget;

  BlockClass({
    required this.offset,
    required this.offsetDefault,
    required this.jigsawBlockWidget
  });
}