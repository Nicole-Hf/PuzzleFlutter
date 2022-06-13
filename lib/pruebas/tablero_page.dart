// ignore_for_file: unnecessary_this, deprecated_member_use, depend_on_referenced_packages, invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member, avoid_unnecessary_containers, sized_box_for_whitespace, unnecessary_null_comparison, prefer_conditional_assignment, avoid_function_literals_in_foreach_calls
/*
import 'dart:typed_data';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:image/image.dart' as ui;
import 'dart:math' as math;
import 'package:carousel_slider/carousel_slider.dart';

class TableroPage extends StatefulWidget {
  final int rows = 4;
  final int cols = 4;

  const TableroPage({Key? key}) : super(key: key);

  @override
  State<TableroPage> createState() => _TableroPageState();
}

class _TableroPageState extends State<TableroPage> {
   
  GlobalKey<_JigsawWidgetState> jigKey = GlobalKey<_JigsawWidgetState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/background_image.png"),
            fit: BoxFit.cover,
          )
        ),
        child: SafeArea(
          child: Center(
            child: Column(
              children: [
                //la base del puzzle widget
                Container(
                  margin: const EdgeInsets.all(10),
                  decoration: BoxDecoration(border: Border.all(width: 2)),
                  child: JigsawWidget(
                    callbackFinish: (){
                      print("callbackFinish");
                    },
                    callbackSuccess: (){
                      print("callbackSuccess");
                    },
                    key: jigKey,
                    child: const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Image(
                        fit: BoxFit.contain,
                        image: AssetImage("assets/icons/iconv1.png"),
                      ),
                    )
                  ),
                ),
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      RaisedButton(
                        child: const Text("Clear"),
                        onPressed: () {
                          jigKey.currentState!.resetJigsaw();
                        }
                      ),
                      RaisedButton(
                        child: const Text("Generate"),
                        onPressed: () async {
                          await jigKey.currentState!.generaJigsawCropImage();
                        }
                      ),
                    ]
                  ),
                ),
              ],
            ),
          )
        )
      ),
    );
  }
}

// ignore: must_be_immutable
class JigsawWidget extends StatefulWidget {
  Widget child;
  Function() callbackSuccess;
  Function() callbackFinish;

  JigsawWidget({Key? key, required this.child, required this.callbackSuccess , required this.callbackFinish}) : super(key: key);

  @override
  State<JigsawWidget> createState() => _JigsawWidgetState();
}

class _JigsawWidgetState extends State<JigsawWidget> {
  final GlobalKey _globalKey = GlobalKey();
  ui.Image? fullImage;
  Size? size;

  List<List<BlockClass>> images = <List<BlockClass>>[];
  ValueNotifier<List<BlockClass>> blocksNotifier = ValueNotifier<List<BlockClass>>(<BlockClass>[]);
  late CarouselController _carouselController;
  Offset _pos = Offset.zero;
  int _index = 0;

  _getImageFromWidget() async {
    RenderRepaintBoundary boundary = _globalKey.currentContext!.findRenderObject() as RenderRepaintBoundary;

    size = boundary.size;
    var img = await boundary.toImage();
    var byteData = await img.toByteData(format: ImageByteFormat.png);
    var pngBytes = byteData?.buffer.asUint8List();

    return ui.decodeImage(pngBytes!);
  }

  resetJigsaw() {
    images.clear();
    blocksNotifier = ValueNotifier<List<BlockClass>>(<BlockClass>[]);
    //_carouselController = CarouselController();
    blocksNotifier.notifyListeners();
    setState(() {
      
    });
  }

  Future<void> generaJigsawCropImage() async {
    images = <List<BlockClass>>[];

    //obtener la imagen
    if (fullImage == null) fullImage = await _getImageFromWidget();

    //dividir imagen
    int xSplitCount = 3;
    int ySplitCount = 3;

    double widthPerBlock = fullImage!.width/ xSplitCount;
    double heightPerBlock = fullImage!.height / ySplitCount;

    for (var y = 0; y < ySplitCount; y++) {
      //List tempImages = <BlockClass>[];
      //images.add(tempImages);
      images.add(<BlockClass>[]);

      for (var x = 0; x < xSplitCount; x++) {
        int randomPosRow = math.Random().nextInt(2) % 2 == 0 ? 1 : -1;
        int randomPosCol = math.Random().nextInt(2) % 2 == 0 ? 1 : -1;

        Offset offsetCenter = Offset(widthPerBlock / 2, heightPerBlock / 2);

        //hacer un pointer dentro o fuera
        ClassJigsawPos jigsawPosSide = ClassJigsawPos(
          bottom: y == ySplitCount - 1 ? 0 : randomPosCol,
          left: x == 0 ? 0 : -images[y][x-1].jigsawBlockWidget.imageBox.posSide.rigth,
          rigth: x == xSplitCount - 1 ? 0 : randomPosRow,
          top: y == 0 ? 0 : -images[y-1][x].jigsawBlockWidget.imageBox.posSide.bottom,
        );

        double xAxis = widthPerBlock * x;
        double yAxis = heightPerBlock * y;
        //size para ponting
        double minSize = math.min(widthPerBlock, heightPerBlock) / 15 * 4;

        offsetCenter = Offset(
          (widthPerBlock/2) + (jigsawPosSide.left == 1 ? minSize : 0),
          (heightPerBlock/2) + (jigsawPosSide.top == 1 ? minSize : 0)
        );

        //cambiar axis para el posSideEffect
        xAxis -= jigsawPosSide.left == 1 ? minSize : 0;
        yAxis -= jigsawPosSide.top == 1 ? minSize : 0;
        //obtener width y height despues del cambio
        double widthPerBlockTemp = widthPerBlock 
          + (jigsawPosSide.left == 1 ? minSize : 0) 
          + (jigsawPosSide.rigth == 1 ? minSize : 0);
        double heightPerBlockTemp = heightPerBlock 
          + (jigsawPosSide.top == 1 ? minSize : 0) 
          + (jigsawPosSide.bottom == 1 ? minSize : 0);

        //crear cropimage para cada block
        ui.Image temp = ui.copyCrop(
          fullImage!, 
          xAxis.round(), 
          yAxis.round(), 
          widthPerBlockTemp.round(), 
          heightPerBlockTemp.round()
        );

        //obtener offset para cada bloque
        Offset offset = Offset(size!.width / 2 - widthPerBlockTemp / 2, 
          size!.height / 2 - heightPerBlockTemp / 2);

        ImageBox imageBox = ImageBox(
          image: Image.memory(
            ui.encodePng(temp) as Uint8List, //review after
            fit: BoxFit.contain,
          ),
          isDone: false,
          offsetCenter: offsetCenter,
          posSide: jigsawPosSide,
          radiusPoint: minSize,
          size: Size(widthPerBlockTemp, heightPerBlockTemp),
        );
     
        images[y].add(
          BlockClass(
            jigsawBlockWidget: JigsawBlockWidget(
              imageBox: imageBox,
            ),
            offset: offset, 
            offsetDefault: Offset(xAxis, yAxis),         
          )
        );
      }
    }

    blocksNotifier.value = images.expand((image) => image).toList();
    blocksNotifier.value.shuffle();
    blocksNotifier.notifyListeners();
    //_index = 0;
    setState(() {});
  }

  @override
  void initState() {
    //generar la imagen dividida
    _index = 0;
    _carouselController = CarouselController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size sizeBox = MediaQuery.of(context).size;

    return ValueListenableBuilder(
      valueListenable: blocksNotifier,
      builder: (context, List<BlockClass> blocks, child) {
        List<BlockClass> blockNotDone = 
          blocks.where((block) => 
          !block.jigsawBlockWidget.imageBox.isDone).toList();
        List<BlockClass> blockDone = 
          blocks.where((block) => 
          block.jigsawBlockWidget.imageBox.isDone).toList();
        return Container(
          child: Container(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  height: sizeBox.width,
                  child: Listener(
                    onPointerUp: (event) {
                      if (blockNotDone.isEmpty) {
                        resetJigsaw();
                        widget.callbackFinish.call();
                      }
                      if (_index == null) {
                        _carouselController.nextPage(duration: const Duration(microseconds: 600));
                        setState(() {
                          //_index = 0;
                        });
                      }
                    },
                    onPointerMove: (event) {
                      if (_index == null) {
                        return;
                      }
                      Offset offset = event.localPosition - _pos;
                      blockNotDone[_index].offset = offset;

                      if ((blockNotDone[_index].offset - blockNotDone[_index].offsetDefault).distance < 5) {
                        blockNotDone[_index].jigsawBlockWidget.imageBox.isDone = true;
                        blockNotDone[_index].offset = blockNotDone[_index].offsetDefault;
                        
                        //_index = null;
                        _index = 0;
                        blocksNotifier.notifyListeners();
                        widget.callbackSuccess.call();
                      }

                      setState((){});
                    },
                    child: Stack(
                      children: [
                        if (blocks.isEmpty) ...[
                          RepaintBoundary(
                            key: _globalKey,
                            child: Container(
                              color: Colors.red,
                              height: double.maxFinite,
                              width: double.maxFinite,
                              child: widget.child,
                            ),
                          ),
                        ],

                        Offstage(
                          // ignore: prefer_is_empty
                          offstage: !(blocks.length > 0),
                          child: Container(
                            color: const Color.fromARGB(255, 227, 249, 248),
                            width: size?.width,
                            height: size?.height,
                            child: CustomPaint(
                              painter: JigsawPainterBackground(blocks),
                              child: Stack(
                                children: [
                                  // ignore: prefer_is_empty
                                  if (blockDone.length > 0) 
                                    ...blockDone.map((map) {
                                      return Positioned(
                                        left: map.offset.dx,
                                        top: map.offset.dy,
                                        child: Container(
                                          child: map.jigsawBlockWidget,
                                        )
                                      );
                                    }
                                  ),
                                  // ignore: prefer_is_empty
                                  if (blockNotDone.length > 0) 
                                    ...blockNotDone.asMap().entries.map((map) {
                                      return Positioned(
                                        left: map.value.offset.dx,
                                        top: map.value.offset.dy,
                                        child: Offstage(
                                          offstage: !(_index == map.key),
                                          child: GestureDetector(
                                            onTapDown: (details) {
                                              if (map.value.jigsawBlockWidget.imageBox.isDone) {
                                                return;
                                              }
                                              setState(() {
                                                _pos = details.localPosition;
                                                _index = map.key;
                                              });
                                            },
                                            child: Container(
                                              child: map.value.jigsawBlockWidget,
                                            ),
                                          ),
                                        )
                                      );
                                    }
                                  )
                                ],
                              ),
                            ),
                          )
                        )
                      ]
                    ),
                  ),
                ),
                Container(
                  color: Colors.black, 
                  height: 100,
                  child: CarouselSlider(
                    carouselController: _carouselController,
                    options: CarouselOptions(
                      initialPage: _index,
                      height: 80,
                      aspectRatio: 1,
                      viewportFraction: 0.15,
                      enlargeCenterPage: true,
                      enableInfiniteScroll: true,
                      disableCenter: false,
                      onPageChanged: (index, reason) {
                        _index = index;
                        setState(() {
                          
                        });
                      }
                    ),
                    items: blockNotDone.map((block) {
                      Size sizeBlock = block.jigsawBlockWidget.imageBox.size;
                      return FittedBox(
                        child: Container(
                          width: sizeBlock.width,
                          height: sizeBlock.height,
                          child: block.jigsawBlockWidget,
                        ),
                      );
                    }).toList(),
                  ),
                ),             
              ],
            ),
          ),
        );
      }
    );
  }
}

class JigsawPainterBackground extends CustomPainter {
  List<BlockClass> blocks = [];
  JigsawPainterBackground(this.blocks);

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..style = PaintingStyle.stroke
      ..color = Colors.black12
      ..strokeWidth = 1
      ..strokeCap = StrokeCap.round;

    Path path = Path();

    this.blocks.forEach((element) {
      Path pathTemp = getPiecePath1(
        element.jigsawBlockWidget.imageBox.size,
        element.jigsawBlockWidget.imageBox.radiusPoint,
        element.jigsawBlockWidget.imageBox.offsetCenter,
        element.jigsawBlockWidget.imageBox.posSide,
      );
      path.addPath(pathTemp, element.offsetDefault);
    });
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

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

class ClassJigsawPos {
  int top, bottom, left, rigth;

  ClassJigsawPos({
    required this.top, 
    required this.bottom, 
    required this.left, 
    required this.rigth
  });
}

// ignore: must_be_immutable
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

class JigsawBlockPainter extends CustomPainter {
  ImageBox imageBox;
  JigsawBlockPainter({required this.imageBox});

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
    ..color = this.imageBox.isDone 
      ? Colors.white.withOpacity(0.2) : Colors.white
    ..style = PaintingStyle.stroke
    ..strokeWidth = 2;

    canvas.drawPath(getPiecePath1(size, this.imageBox.radiusPoint, 
      this.imageBox.offsetCenter,
      this.imageBox.posSide), paint);
    
    if (this.imageBox.isDone) {
      Paint paintDone = Paint()
        ..color = Colors.white.withOpacity(0.2)
        ..style = PaintingStyle.fill
        ..strokeWidth = 2;

      canvas.drawPath(
        getPiecePath1(size, this.imageBox.radiusPoint, 
          this.imageBox.offsetCenter,
          this.imageBox.posSide), paintDone);
    }
  }

  @override
  bool shouldRepaint(JigsawBlockPainter oldDelegate) => false;

  @override
  bool shouldRebuildSemantics(JigsawBlockPainter oldDelegate) => false;
}

class PuzzlePieceClipper extends CustomClipper<Path> {
  ImageBox imageBox;
  PuzzlePieceClipper({required this.imageBox});

  @override
  Path getClip(Size size) {
    return getPiecePath1(
      size, 
      this.imageBox.radiusPoint, 
      this.imageBox.offsetCenter,
      this.imageBox.posSide);
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}

getPiecePath1(Size size, double radiusPoint, Offset offsetCenter, ClassJigsawPos posSide) {
  Path path = Path();

  Offset topLeft = const Offset(0, 0);
  Offset topRight = Offset(size.width, 0);
  Offset bottomLeft = Offset(0, size.height);
  Offset bottomRight = Offset(size.width, size.height);

  topLeft = Offset(posSide.left > 0 ? radiusPoint : 0, 
    (posSide.top > 0) ? radiusPoint : 0) + topLeft;
  topRight = Offset(posSide.rigth > 0 ? -radiusPoint : 0, 
    (posSide.top > 0) ? radiusPoint : 0) + topRight;
  bottomRight = Offset(posSide.rigth > 0 ? -radiusPoint : 0, 
    (posSide.bottom > 0) ? -radiusPoint : 0) + bottomRight;
  bottomLeft = Offset(posSide.left > 0 ? radiusPoint : 0, 
    (posSide.bottom > 0) ? -radiusPoint : 0) + bottomLeft;

  double topMiddle = posSide.top == 0 ? topRight.dy 
    : (posSide.top > 0 ? topRight.dy - radiusPoint : topRight.dy + radiusPoint);
  
  double bottomMiddle = posSide.bottom == 0 ? bottomRight.dy 
    : (posSide.bottom > 0 ? bottomRight.dy + radiusPoint : bottomRight.dy - radiusPoint);

  double leftMiddle = posSide.left == 0 ? topLeft.dx 
    : (posSide.left > 0 ? topLeft.dx - radiusPoint : topLeft.dx + radiusPoint);

  double rightMiddle = posSide.rigth == 0 ? topRight.dx 
    : (posSide.rigth > 0 ? topRight.dx + radiusPoint : topRight.dx - radiusPoint);

  path.moveTo(topLeft.dx, topLeft.dy);

  //top draw
  if (posSide.top != 0) {
    path.extendWithPath(
      calculatePoint(Axis.horizontal, topLeft.dy, 
        Offset(offsetCenter.dx, topMiddle), radiusPoint), Offset.zero);
  }
  path.lineTo(topRight.dx, topRight.dy);
  //rigth draw
  if (posSide.rigth != 0) {
    path.extendWithPath(
      calculatePoint(Axis.vertical, topRight.dx, 
        Offset(rightMiddle, offsetCenter.dy), radiusPoint), Offset.zero);
  }
  path.lineTo(bottomRight.dx, bottomRight.dy);
  if (posSide.bottom != 0) {
    path.extendWithPath(
      calculatePoint(Axis.horizontal, bottomRight.dy, 
        Offset(offsetCenter.dx, bottomMiddle), -radiusPoint), Offset.zero);
  }
  path.lineTo(bottomLeft.dx, bottomLeft.dy);
  if (posSide.left != 0) {
    path.extendWithPath(
      calculatePoint(Axis.vertical, bottomLeft.dx, 
        Offset(leftMiddle, offsetCenter.dy), -radiusPoint), Offset.zero);
  }
  path.lineTo(topLeft.dx, topLeft.dy);

  path.close();

  return path;
}

//design each point shape
calculatePoint(Axis axis, double fromPoint, Offset point, double radiusPoint) {
  Path path = Path();

  if (axis == Axis.horizontal) {
    path.moveTo(point.dx - radiusPoint / 2, fromPoint);
    path.lineTo(point.dx - radiusPoint / 2, point.dy);
    path.lineTo(point.dx + radiusPoint / 2, point.dy);
    path.lineTo(point.dx + radiusPoint / 2, fromPoint);
  } else if (axis == Axis.vertical) {
    path.moveTo(fromPoint, point.dy - radiusPoint / 2);
    path.lineTo(point.dx, point.dy - radiusPoint / 2);
    path.lineTo(point.dx, point.dy + radiusPoint / 2);
    path.lineTo(fromPoint, point.dy + radiusPoint / 2);
  }

  return path;
}
*/