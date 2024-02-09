import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:screenshot/screenshot.dart';
import 'package:task_4_college/utils/snack_bar.dart';

class ZoomExample extends StatefulWidget {
  const ZoomExample({Key? key}) : super(key: key);

  @override
  State<ZoomExample> createState() => _ZoomExampleState();
}

class _ZoomExampleState extends State<ZoomExample> {
  final List<Offset> _positions = [const Offset(0.0, 0.0), const Offset(100.0, 100.0)];
  final List<double> _imageScales = [1.0, 1.0];
  final List<double> _imageSizes = [100.0, 150.0];
  ScreenshotController screenshotController = ScreenshotController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Two Finger Image Zoom',
          overflow: TextOverflow.ellipsis,
        ),
      ),
      body: Container(
        color: Colors.grey.withOpacity(0.3),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Screenshot(
              controller: screenshotController,
              child: AspectRatio(
                aspectRatio: 1.0,
                child: Stack(
                  children: [
                    Container(color: Colors.white),
                    for (int i = 0; i < _positions.length; i++)
                      Positioned(
                        left: _positions[i].dx,
                        top: _positions[i].dy,
                        child: GestureDetector(
                          onScaleStart: (details) {
                            _imageScales[i] = 1.0;
                          },
                          onScaleUpdate: (details) {
                            if (details.pointerCount == 2) {
                              double newSize = _imageSizes[i] * details.scale;
                              double newScale = details.scale;

                              if (newSize >= 100.0 && newSize <= 400.0) {
                                setState(() {
                                  _imageScales[i] = newScale.clamp(1.0, 4.0);
                                  _imageSizes[i] = newSize;
                                });
                              }
                            } else {
                              setState(() {
                                _positions[i] += details.focalPointDelta;

                                double clampedX = _positions[i].dx;
                                double clampedY = _positions[i].dy;

                                _positions[i] = Offset(clampedX, clampedY);
                              });
                            }
                          },
                          onScaleEnd: (details) {
                            _imageScales[i] = 1.0;
                          },
                          child: Transform.scale(
                            scale: _imageScales[i],
                            child: SizedBox(
                              height: _imageSizes[i],
                              width: _imageSizes[i],
                              child: Image.asset(
                                'assets/image/flat-tropical-summer-background-with-flamingos_23-2149435799.jpg',
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await screenshotController.capture().then(
            (value) async {
              if (value != null) {
                var isDone = await ImageGallerySaver.saveImage(
                  Uint8List.fromList(value),
                  quality: 100,
                );
                if (isDone != null) {
                  CustomSnackbar.show(snackbarType: SnackbarType.SUCCESS, message: 'File saved successfully');
                } else {
                  CustomSnackbar.show(snackbarType: SnackbarType.SUCCESS, message: 'Can\'t save the file? Try again.');
                }
              }
            },
          );
        },
        child: const Icon(Icons.save),
      ),
    );
  }
}
