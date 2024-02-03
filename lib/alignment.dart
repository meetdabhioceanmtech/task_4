// import 'package:flutter/material.dart';

// class DottedLinePainter extends CustomPainter {
//   final double horizontalLineY;
//   final double verticalLineX;

//   DottedLinePainter(this.horizontalLineY, this.verticalLineX);

//   @override
//   void paint(Canvas canvas, Size size) {
//     final Paint paint = Paint()
//       ..color = Colors.red
//       ..strokeWidth = 5
//       ..strokeCap = StrokeCap.round
//       ..style = PaintingStyle.stroke;

//     const double dashWidth = 5;
//     const double dashSpace = 5;

//     if (horizontalLineY > 0) {
//       double currentX = 0;
//       while (currentX < size.width) {
//         canvas.drawLine(Offset(currentX, horizontalLineY), Offset(currentX + dashWidth, horizontalLineY), paint);
//         currentX += dashWidth + dashSpace;
//       }
//     }

//     if (verticalLineX > 0) {
//       double currentY = 0;
//       while (currentY < size.height) {
//         canvas.drawLine(Offset(verticalLineX, currentY), Offset(verticalLineX, currentY + dashWidth), paint);
//         currentY += dashWidth + dashSpace;
//       }
//     }
//   }

//   @override
//   bool shouldRepaint(covariant CustomPainter oldDelegate) {
//     return true;
//   }
// }

// class ZoomExample extends StatefulWidget {
//   const ZoomExample({Key? key}) : super(key: key);

//   @override
//   State<ZoomExample> createState() => _ZoomExampleState();
// }

// class _ZoomExampleState extends State<ZoomExample> {
//   final List<Offset> _positions = [const Offset(0.0, 0.0), const Offset(100.0, 100.0), const Offset(200.0, 200.0)];
//   final List<double> _imageScales = [1.0, 1.0, 1.0];
//   final List<double> _imageSizes = [100.0, 150.0, 200.0];
//   final double alignmentThreshold = 10.0; // Adjust the threshold as needed
//   double _horizontalLineY = 0;
//   double _verticalLineX = 0;
//   bool isShow = false;
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(),
//       body: Padding(
//         padding: const EdgeInsets.all(8.0),
//         child: AspectRatio(
//           aspectRatio: 1.0,
//           child: Stack(
//             children: [
//               Container(color: Colors.grey),
//               // CustomPaint(
//               //   painter: DottedLinePainter(_horizontalLineY, _verticalLineX),
//               // ),
//               Visibility(
//                 visible: isShow,
//                 child: CustomPaint(
//                   painter: DottedLinePainter(_horizontalLineY, _verticalLineX),
//                   size: const Size(double.infinity, double.infinity), // Set a large size
//                 ),
//               ),

//               for (int i = 0; i < _positions.length; i++)
//                 Positioned(
//                   left: _positions[i].dx,
//                   top: _positions[i].dy,
//                   child: GestureDetector(
//                     onScaleStart: (details) {
//                       _showAlignmentLines(i);
//                       _imageScales[i] = 1.0;
//                     },
//                     onScaleUpdate: (details) {
//                       _showAlignmentLines(i);

//                       if (details.pointerCount == 2) {
//                         double newSize = _imageSizes[i] * details.scale;
//                         double newScale = details.scale;

//                         if (newSize >= 100.0 && newSize <= 400.0) {
//                           setState(() {
//                             _imageScales[i] = newScale.clamp(1.0, 4.0);
//                             _imageSizes[i] = newSize;
//                           });
//                         }
//                       } else {
//                         setState(() {
//                           _positions[i] += details.focalPointDelta;

//                           double clampedX = _positions[i].dx;
//                           double clampedY = _positions[i].dy;

//                           _positions[i] = Offset(clampedX, clampedY);
//                         });
//                       }
//                     },
//                     onScaleEnd: (details) {
//                       _imageScales[i] = 1.0;
//                       isShow = false;
//                       setState(() {});
//                     },
//                     child: Transform.scale(
//                       scale: _imageScales[i],
//                       child: SizedBox(
//                         height: _imageSizes[i],
//                         width: _imageSizes[i],
//                         child: Image.network(
//                           'https://img.freepik.com/free-photo/blue-wall-background_53876-88663.jpg?w=740&t=st=1706849199~exp=1706849799~hmac=8d50b1869dcaa518eaadb637f5de92cd0edc1e3ae59d1ee88d9377e258d1b91a',
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   void _showAlignmentLines(int currentIndex) {
//     isShow = true;
//     double currentX = _positions[currentIndex].dx + _imageSizes[currentIndex] / 2;
//     double currentY = _positions[currentIndex].dy + _imageSizes[currentIndex] / 2;

//     _horizontalLineY = 0;
//     _verticalLineX = 0;

//     for (int i = 0; i < _positions.length; i++) {
//       if (i != currentIndex) {
//         double targetX = _positions[i].dx + _imageSizes[i] / 2;
//         double targetY = _positions[i].dy + _imageSizes[i] / 2;

//         double distanceX = (targetX - currentX).abs();
//         double distanceY = (targetY - currentY).abs();

//         if (distanceX < alignmentThreshold) {
//           _horizontalLineY = (currentY + targetY) / 2;
//         }

//         if (distanceY < alignmentThreshold) {
//           _verticalLineX = (currentX + targetX) / 2;
//         }
//       }
//     }
//     setState(() {});
//   }
// }

import 'package:flutter/material.dart';

class DottedLinePainter extends CustomPainter {
  final double horizontalLineY;
  final double verticalLineX;

  DottedLinePainter(this.horizontalLineY, this.verticalLineX);

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = Colors.red
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    const double dashWidth = 5;
    const double dashSpace = 5;

    if (horizontalLineY > 0) {
      double currentX = 0;
      while (currentX < size.width) {
        canvas.drawLine(Offset(currentX, horizontalLineY), Offset(currentX + dashWidth, horizontalLineY), paint);
        currentX += dashWidth + dashSpace;
      }
    }

    if (verticalLineX > 0) {
      double currentY = 0;
      while (currentY < size.height) {
        canvas.drawLine(Offset(verticalLineX, currentY), Offset(verticalLineX, currentY + dashWidth), paint);
        currentY += dashWidth + dashSpace;
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class ZoomExample extends StatefulWidget {
  const ZoomExample({Key? key}) : super(key: key);

  @override
  State<ZoomExample> createState() => _ZoomExampleState();
}

class _ZoomExampleState extends State<ZoomExample> {
  final List<Offset> _positions = [const Offset(0.0, 0.0), const Offset(100.0, 100.0)];
  final List<double> _imageScales = [1.0, 1.0];
  final List<double> _imageSizes = [100.0, 150.0];
  final double alignmentThreshold = 0.0; // Adjust the threshold as needed
  double _horizontalLineY = 0;
  double _verticalLineX = 0;
  bool isShow = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: AspectRatio(
          aspectRatio: 1.0,
          child: Stack(
            children: [
              Container(color: Colors.grey),
              // CustomPaint(
              //   painter: DottedLinePainter(_horizontalLineY, _verticalLineX),
              // ),
              Visibility(
                visible: isShow,
                child: CustomPaint(
                  painter: DottedLinePainter(_horizontalLineY, _verticalLineX),
                  size: const Size(double.infinity, double.infinity), // Set a large size
                ),
              ),

              for (int i = 0; i < _positions.length; i++)
                Positioned(
                  left: _positions[i].dx,
                  top: _positions[i].dy,
                  child: GestureDetector(
                    onScaleStart: (details) {
                      _showAlignmentLines(i);
                      _imageScales[i] = 1.0;
                    },
                    onScaleUpdate: (details) {
                      _showAlignmentLines(i);

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
                      // isShow = false;
                      setState(() {});
                    },
                    child: Transform.scale(
                      scale: _imageScales[i],
                      child: SizedBox(
                        height: _imageSizes[i],
                        width: _imageSizes[i],
                        child: Image.network(
                          'https://img.freepik.com/free-photo/blue-wall-background_53876-88663.jpg?w=740&t=st=1706849199~exp=1706849799~hmac=8d50b1869dcaa518eaadb637f5de92cd0edc1e3ae59d1ee88d9377e258d1b91a',
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  void _showAlignmentLines(int currentIndex) {
    isShow = true;
    double currentX = _positions[currentIndex].dy + _imageSizes[currentIndex] / 2;
    double currentY = _positions[currentIndex].dx + _imageSizes[currentIndex] / 2;

    _horizontalLineY = 0;
    _verticalLineX = 0;

    for (int i = 0; i < _positions.length; i++) {
      if (i != currentIndex) {
        double targetX = _positions[i].dx + _imageSizes[i] / 2;
        double targetY = _positions[i].dy + _imageSizes[i] / 2;

        double distanceX = (targetX - currentX).abs();
        double distanceY = (targetY - currentY).abs();

        if (distanceX < alignmentThreshold) {
          _horizontalLineY = (currentY + targetY) / 2;
        }

        if (distanceY < alignmentThreshold) {
          _verticalLineX = (currentX + targetX) / 2;
        }
      }
    }
    setState(() {});
  }
}
