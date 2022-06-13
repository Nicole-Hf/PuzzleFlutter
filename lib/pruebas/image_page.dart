// ignore_for_file: unnecessary_this
import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:puzzle_kids/pages/puzzle_page.dart';
import 'package:puzzle_kids/pages/up_page.dart';
import 'package:puzzle_kids/utils/variables.dart';

class UploadImagePage extends StatefulWidget {
  final int rows = 4;
  final int cols = 4;

  const UploadImagePage({Key? key}) : super(key: key);

  @override
  State<UploadImagePage> createState() => _UploadImagePageState();
}

class _UploadImagePageState extends State<UploadImagePage> {
  XFile? _image;
  final ImagePicker _picker = ImagePicker();

  Future getImage(ImageSource source) async {
    var image = await _picker.pickImage(source: source);
    if (image != null) {
      setState(() {
        _image = image;
        pieces.clear();
      });
      splitImage(Image.file(File(image.path)));
    }
  }

  Future<Size> getImageSize(Image image) async {
    final Completer<Size> completer = Completer<Size>();

    image.image.resolve(const ImageConfiguration()).addListener(
      ImageStreamListener((ImageInfo info, bool _) {
        completer.complete(Size(
          info.image.width.toDouble(), 
          info.image.height.toDouble()
        ));
    }));

    final Size imageSize = await completer.future;
    return imageSize;
  }

  void splitImage(Image image) async {
    Size imageSize = await getImageSize(image);

    for (int x = 0; x < widget.rows; x++) {
      for (int y = 0; y < widget.cols; y++) {
        setState(() {
          pieces.add(PuzzlePiece(
            key: GlobalKey(), 
            image: image, 
            imageSize: imageSize, 
            row: x, 
            col: y, 
            maxRow: widget.rows, 
            maxCol: widget.cols,
            bringToTop: this.bringToTop,
            sendToBack: this.sendToBack,
          ));
        });
      }
    }
  }

  void bringToTop(Widget widget) {
    setState(() {
      pieces.remove(widget);
      pieces.add(widget);
    });
  }

  void sendToBack(Widget widget) {
    setState(() {
      pieces.remove(widget);
      pieces.insert(0, widget);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/background_image.png"),
                fit: BoxFit.cover,
              )
            )
          ),
          SafeArea(
            child: Center(
              // ignore: unnecessary_null_comparison
              child: _image == null
                ? const Text('No image selected')
                : Image.file(File(_image!.path), width: 500, height: 500),
            )
          ),
        ]
      ),
      floatingActionButton: ClipRect(
        child: _image == null 
          ? Container(
              width: 150.0, height: 100.0,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/buttons/add_image.png'),
                  fit: BoxFit.cover
                )
              ),
              // ignore: deprecated_member_use
              child: FlatButton(
                padding: const EdgeInsets.all(0.0),
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
                child: const Text(''),
              ),
            )
          : Container(
              width: 150.0, height: 150.0,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/buttons/next_button.png'),
                  fit: BoxFit.cover
                )
              ),
              // ignore: deprecated_member_use
              child: FlatButton(
                padding: const EdgeInsets.all(0.0),
                onPressed: () {
                  imageUpload = File(_image!.path);
                  // ignore: avoid_print
                  print('Imagen $imageUpload');
                  Navigator.push(context, MaterialPageRoute(
                    builder: (BuildContext context) => const TableroPage()));
                },
                child: const Text(''),
              ),
            ),
        ),
    );
  }
}
