import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:screenshot/screenshot.dart';
import 'package:task_4_college/utils/snack_bar.dart';

class ZoomableImage extends StatefulWidget {
  const ZoomableImage({Key? key}) : super(key: key);

  @override
  State<ZoomableImage> createState() => _ZoomableImageState();
}

class _ZoomableImageState extends State<ZoomableImage> with SingleTickerProviderStateMixin {
  final List<Offset> _positions = [const Offset(0.0, 0.0), const Offset(100.0, 100.0)];
  final List<double> _imageScales = [1.0, 1.0];
  final List<double> _imageSizes = [100.0, 150.0];
  ScreenshotController screenshotController = ScreenshotController();
  final AssetImage _imageAsset =
      const AssetImage('assets/image/flat-tropical-summer-background-with-flamingos_23-2149435799.jpg');

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
                child: Container(
                  color: Colors.white,
                  child: Stack(
                    children: List.generate(
                      _positions.length,
                      (index) => _buildZoomableImage(index),
                    ),
                  ),
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

  final List<TransformationController> _transformationControllers = [
    TransformationController(),
    TransformationController(),
  ];
  Widget _buildZoomableImage(int index) {
    return Positioned(
      left: _positions[index].dx,
      top: _positions[index].dy,
      child: GestureDetector(
        onScaleStart: (details) {
          _imageScales[index] = 1.0;
        },
        onScaleUpdate: (details) {
          _handleScaleAndPosition(index, details);
        },
        onScaleEnd: (details) {
          _imageScales[index] = 1.0;
        },
        child: Transform(
          transform: _transformationControllers[index].value,
          child: SizedBox(
            height: _imageSizes[index],
            width: _imageSizes[index],
            child: Image(image: _imageAsset),
          ),
        ),
      ),
    );
  }

  void _handleScaleAndPosition(int index, ScaleUpdateDetails details) {
    if (details.pointerCount == 2) {
      double newSize = _imageSizes[index] * details.scale;
      double newScale = _imageScales[index] * details.scale;
      final double imageSize;

      if (_imageScales[index] < newScale) {
        imageSize = newSize / _imageScales[index] + _imageScales[index];
      } else {
        imageSize = newSize / _imageScales[index] - _imageScales[index];
      }
      final double scaleChange = newScale / _imageScales[index];

      // Check the pointer count outside this condition
      if (newSize >= 100.0 && newSize <= 400.0) {
        setState(() {
          for (int i = 0; i < _positions.length; i++) {
            if (i == index) {
              _positions[index] += details.focalPointDelta;

              double clampedX = _positions[index].dx;
              double clampedY = _positions[index].dy;
              _positions[index] = Offset(clampedX, clampedY);

              _imageScales[i] = scaleChange;
              _imageSizes[i] = imageSize;
            }
          }
        });
      }
    } else {
      setState(() {
        _positions[index] += details.focalPointDelta;

        double clampedX = _positions[index].dx;
        double clampedY = _positions[index].dy;

        _positions[index] = Offset(clampedX, clampedY);
      });
    }
  }
}

// class MyZoomableImage extends StatefulWidget {
//   const MyZoomableImage({Key? key}) : super(key: key);

//   @override
//   State<MyZoomableImage> createState() => _MyZoomableImageState();
// }

// class _MyZoomableImageState extends State<MyZoomableImage> {
//   final String imageUrl = 'assets/image/flat-tropical-summer-background-with-flamingos_23-2149435799.jpg';

//   double _scale = 1.0;
//   double _previousScale = 1.0;
//   Offset _imageOffset = Offset.zero;
//   double photoSize = 150;
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Zoomable Image Viewer'),
//       ),
//       body: Center(
//         child: AspectRatio(
//           aspectRatio: 1.0,
//           child: Container(
//             decoration: BoxDecoration(
//               border: Border.all(color: Colors.black),
//             ),
//             child: GestureDetector(
//               onScaleStart: (details) {
//                 setState(() {
//                   // _initialFocalPoint = details.focalPoint;
//                   // _focalPoint = details.focalPoint;
//                 });
//               },
//               onScaleUpdate: (details) {
//                 if (details.pointerCount == 2) {
//                   setState(() {
//                     _scale = _previousScale * details.scale;
//                     // _focalPoint = details.focalPoint;

//                     // Calculate the new offset based on the scale and focal point changes
//                     // _imageOffset = Offset(
//                     //   (_focalPoint.dx - _initialFocalPoint.dx) + (_imageOffset.dx * details.scale),
//                     //   (_focalPoint.dy - _initialFocalPoint.dy) + (_imageOffset.dy * details.scale),
//                     // );
//                   });
//                 } else {
//                   setState(() {
//                     // If there is only one pointer, treat it as dragging
//                     // _imageOffset += details.focalPointDelta;
//                     _imageOffset += details.focalPointDelta;

//                     double clampedX = _imageOffset.dx;
//                     double clampedY = _imageOffset.dy;

//                     _imageOffset = Offset(clampedX, clampedY);
//                   });
//                 }
//               },
//               onScaleEnd: (details) {
//                 if (details.pointerCount == 2) {
//                   setState(() {
//                     _previousScale = _scale;
//                   });
//                 }
//               },
//               child: Transform(
//                 transform: Matrix4.identity()
//                   ..translate(_imageOffset.dx, _imageOffset.dy)
//                   ..scale(_scale),
//                 child: Image.asset(
//                   imageUrl,
//                   height: photoSize,
//                   width: photoSize,
//                   fit: BoxFit.contain,
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

// class MyZoomableImage extends StatefulWidget {
//   const MyZoomableImage({Key? key}) : super(key: key);

//   @override
//   State<MyZoomableImage> createState() => _MyZoomableImageState();
// }

// class _MyZoomableImageState extends State<MyZoomableImage> {
//   final String imageUrl = 'assets/image/flat-tropical-summer-background-with-flamingos_23-2149435799.jpg';

//   double _scale = 1.0;
//   double _previousScale = 1.0;
//   Offset _imageOffset = Offset.zero;
//   double photoSize = 150;
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Zoomable Image Viewer'),
//       ),
//       body: Center(
//         child: AspectRatio(
//           aspectRatio: 1.0,
//           child: Container(
//             decoration: BoxDecoration(
//               border: Border.all(color: Colors.black),
//             ),
//             child: GestureDetector(
//               onScaleStart: (details) {
//                 setState(() {
//                   // _initialFocalPoint = details.focalPoint;
//                   // _focalPoint = details.focalPoint;
//                 });
//               },
//               onScaleUpdate: (details) {
//                 if (details.pointerCount == 2) {
//                   setState(() {
//                     _scale = _previousScale * details.scale;
//                     // _focalPoint = details.focalPoint;

//                     // Calculate the new offset based on the scale and focal point changes
//                     // _imageOffset = Offset(
//                     //   (_focalPoint.dx - _initialFocalPoint.dx) + (_imageOffset.dx * details.scale),
//                     //   (_focalPoint.dy - _initialFocalPoint.dy) + (_imageOffset.dy * details.scale),
//                     // );
//                   });
//                 } else {
//                   setState(() {
//                     // If there is only one pointer, treat it as dragging
//                     // _imageOffset += details.focalPointDelta;
//                     _imageOffset += details.focalPointDelta;

//                     double clampedX = _imageOffset.dx;
//                     double clampedY = _imageOffset.dy;

//                     _imageOffset = Offset(clampedX, clampedY);
//                   });
//                 }
//               },
//               onScaleEnd: (details) {
//                 if (details.pointerCount == 2) {
//                   setState(() {
//                     _previousScale = _scale;
//                   });
//                 }
//               },
//               child: Transform(
//                 transform: Matrix4.identity()
//                   ..translate(_imageOffset.dx, _imageOffset.dy)
//                   ..scale(_scale),
//                 child: Image.asset(
//                   imageUrl,
//                   height: photoSize,
//                   width: photoSize,
//                   fit: BoxFit.contain,
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
