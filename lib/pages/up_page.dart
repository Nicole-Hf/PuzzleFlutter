// ignore_for_file: depend_on_referenced_packages, avoid_print, avoid_unnecessary_containers, deprecated_member_use, must_be_immutable, invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member, sized_box_for_whitespace

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:puzzle_kids/models/block_model.dart';
import 'package:puzzle_kids/models/puzzlepos_model.dart';
import 'dart:typed_data';
import 'dart:ui';
import 'package:flutter/rendering.dart';
import 'package:image/image.dart' as ui;
import 'dart:math' as math;
import 'package:carousel_slider/carousel_slider.dart';
import 'package:puzzle_kids/models/imagebox_model.dart';
import 'package:puzzle_kids/utils/block_widget.dart';
import 'package:puzzle_kids/utils/painter_background.dart';

class TableroPage extends StatefulWidget {
  const TableroPage({Key? key}) : super(key: key);

  @override
  State<TableroPage> createState() => _TableroPageState();
}

class _TableroPageState extends State<TableroPage> { 
  GlobalKey<_JigsawWidgetState> jigKey = GlobalKey<_JigsawWidgetState>();

  XFile? _image;
  final ImagePicker _picker = ImagePicker();

  Future getImage(ImageSource source) async {
    var image = await _picker.pickImage(source: source);
    if (image != null) {
      setState(() {
        _image = image;
      });
    }
  }
  
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
                //Tablero del rompecabezas
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
                    child: Padding(
                      padding: const EdgeInsets.all(0.0),
                      child: _image == null 
                      ? const Text(
                          'Suba una imagen', 
                          textAlign: TextAlign.center, 
                          style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.grey),
                        ) 
                        : Image.file(
                            File(_image!.path), 
                            width: 500, 
                            height: 500,
                            fit: BoxFit.cover
                          ),
                    )
                  ),
                ),
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        child: const Text("Clear"),
                        onPressed: () {
                          jigKey.currentState!.resetJigsaw();
                        }
                      ),
                      ElevatedButton(
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
      floatingActionButton: ClipRect(
        child: Container(
          width: 150.0,
          height: 100.0,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/buttons/add_image.png'),
              fit: BoxFit.cover
            )
          ),
          child: TextButton(
              onPressed: () {
                showModalBottomSheet(
                  context: context, 
                  builder: (BuildContext context) {
                    return SafeArea(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ListTile(
                            leading: const Icon(Icons.camera),
                            title: const Text('Camera'),
                            onTap: () {
                              getImage(ImageSource.camera);
                              Navigator.pop(context);
                            },
                          ),
                          ListTile(
                            leading: const Icon(Icons.image),
                            title: const Text('Gallery'),
                            onTap: () {
                              getImage(ImageSource.gallery);
                              Navigator.pop(context);
                            },
                          )
                        ],
                      )
                    );
                  }
                );
              },
            child: Container(),
          ),
        ),
      ),
    );
  }
}

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
    blocksNotifier.notifyListeners();
    setState(() {});
  }

  Future<void> generaJigsawCropImage() async {
    images = <List<BlockClass>>[];

    //obtener la imagen
    // ignore: prefer_conditional_assignment
    if (fullImage == null) fullImage = await _getImageFromWidget();

    //dividir imagen, datos de entrada (Facil, Medio, Dificil)
    int xSplitCount = 2;
    int ySplitCount = 2;

    double widthPerBlock = fullImage!.width/ xSplitCount;
    double heightPerBlock = fullImage!.height / ySplitCount;

    for (var y = 0; y < ySplitCount; y++) {
      images.add(<BlockClass>[]);

      for (var x = 0; x < xSplitCount; x++) {
        int randomPosRow = math.Random().nextInt(2) % 2 == 0 ? 1 : -1;
        int randomPosCol = math.Random().nextInt(2) % 2 == 0 ? 1 : -1;

        Offset offsetCenter = Offset(widthPerBlock / 2, heightPerBlock / 2);

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
                      // ignore: unnecessary_null_comparison
                      if (_index == null) {
                        _carouselController.nextPage(duration: const Duration(microseconds: 600));
                        setState(() {});
                      }
                    },
                    onPointerMove: (event) {
                      if (_index == -1) {
                        return;
                      }
                      Offset offset = event.localPosition - _pos;
                      blockNotDone[_index].offset = offset;

                      if ((blockNotDone[_index].offset - blockNotDone[_index].offsetDefault).distance < 5) {
                        blockNotDone[_index].jigsawBlockWidget.imageBox.isDone = true;
                        blockNotDone[_index].offset = blockNotDone[_index].offsetDefault;
                        
                        _index = -1;
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
                              color: Colors.white38,
                              height: double.maxFinite,
                              width: double.maxFinite,
                              child: widget.child,
                            ),
                          ),
                        ],

                        Offstage(
                          offstage: !(blocks.isNotEmpty),
                          child: Container(
                            color: const Color.fromARGB(255, 227, 249, 248),
                            width: size?.width,
                            height: size?.height,
                            child: CustomPaint(
                              painter: JigsawPainterBackground(blocks),
                              child: Stack(
                                children: [
                                  if (blockDone.isNotEmpty) 
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
                                  if (blockNotDone.isNotEmpty) 
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