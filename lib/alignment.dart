import 'package:flutter/material.dart';

class AlignmentTask5 extends StatefulWidget {
  const AlignmentTask5({Key? key}) : super(key: key);

  @override
  State<AlignmentTask5> createState() => _AlignmentTask5State();
}

class _AlignmentTask5State extends State<AlignmentTask5> {
  final List<Offset> _positions = [const Offset(0.0, 0.0), const Offset(100.0, 100.0)];
  final List<double> _imageScales = [1.0, 1.0];
  final List<double> _imageSizes = [100.0, 150.0];
  final int alignmentThreshold = 2; // Adjust the threshold as needed
  double _horizontalLineY = 0;
  double _verticalLineX = 0;
  bool isShow = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(),
      body: Container(
        color: Colors.grey.withOpacity(0.3),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: AspectRatio(
              aspectRatio: 1.0,
              child: Stack(
                children: [
                  Container(color: Colors.white),
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
                              fit: BoxFit.cover,
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
    );
  }

  void _showAlignmentLines(int currentIndex) {
    isShow = true;

    _horizontalLineY = 0;
    _verticalLineX = 0;

    for (int i = 0; i < _positions.length; i++) {
      if (i != currentIndex) {
        // Horizontal
        double targetXcenter = _positions[i].dx + _imageSizes[i] / 2;
        double targetXright = _positions[i].dx + _imageSizes[i];
        double targetXleft = _positions[i].dx;

        double currentXcenter = _positions[currentIndex].dx + _imageSizes[currentIndex] / 2;
        double currentXbottom = _positions[currentIndex].dx + _imageSizes[currentIndex];
        double currentXtop = _positions[currentIndex].dx;

        //Top
        if (targetXcenter.toInt() >= currentXtop.toInt() - alignmentThreshold &&
            targetXcenter.toInt() <= currentXtop.toInt() + alignmentThreshold) {
          _verticalLineX = currentXtop;
        }
        if (targetXright.toInt() >= currentXtop.toInt() - alignmentThreshold &&
            targetXright.toInt() <= currentXtop.toInt() + alignmentThreshold) {
          _verticalLineX = currentXtop;
        }
        if (targetXleft.toInt() >= currentXtop.toInt() - alignmentThreshold &&
            targetXleft.toInt() <= currentXtop.toInt() + alignmentThreshold) {
          _verticalLineX = currentXtop;
        }

        //Center
        if (targetXcenter.toInt() >= currentXcenter.toInt() - alignmentThreshold &&
            targetXcenter.toInt() <= currentXcenter.toInt() + alignmentThreshold) {
          _verticalLineX = currentXcenter;
        }
        if (targetXright.toInt() >= currentXcenter.toInt() - alignmentThreshold &&
            targetXright.toInt() <= currentXcenter.toInt() + alignmentThreshold) {
          _verticalLineX = currentXcenter;
        }
        if (targetXleft.toInt() >= currentXcenter.toInt() - alignmentThreshold &&
            targetXleft.toInt() <= currentXcenter.toInt() + alignmentThreshold) {
          _verticalLineX = currentXcenter;
        }

        //Bottom
        if (targetXcenter.toInt() >= currentXbottom.toInt() - alignmentThreshold &&
            targetXcenter.toInt() <= currentXbottom.toInt() + alignmentThreshold) {
          _verticalLineX = currentXbottom;
        }
        if (targetXright.toInt() >= currentXbottom.toInt() - alignmentThreshold &&
            targetXright.toInt() <= currentXbottom.toInt() + alignmentThreshold) {
          _verticalLineX = currentXbottom;
        }
        if (targetXleft.toInt() >= currentXbottom.toInt() - alignmentThreshold &&
            targetXleft.toInt() <= currentXbottom.toInt() + alignmentThreshold) {
          _verticalLineX = currentXbottom;
        }

        // Horizontal
        double targetYcenter = _positions[i].dy + _imageSizes[i] / 2;
        double targetYbottom = _positions[i].dy + _imageSizes[i];
        double targetYtop = _positions[i].dy;

        double currentYcenter = _positions[currentIndex].dy + _imageSizes[currentIndex] / 2;
        double currentYbottom = _positions[currentIndex].dy + _imageSizes[currentIndex];
        double currentYtop = _positions[currentIndex].dy;

        //TOP
        if (targetYtop.toInt() >= currentYcenter.toInt() - alignmentThreshold &&
            targetYtop.toInt() <= currentYcenter.toInt() + alignmentThreshold) {
          _horizontalLineY = currentYcenter;
        }
        if (targetYtop.toInt() >= currentYtop.toInt() - alignmentThreshold &&
            targetYtop.toInt() <= currentYtop.toInt() + alignmentThreshold) {
          _horizontalLineY = currentYtop;
        }
        if (targetYtop.toInt() >= currentYbottom.toInt() - alignmentThreshold &&
            targetYtop.toInt() <= currentYbottom.toInt() + alignmentThreshold) {
          _horizontalLineY = currentYbottom;
        }

        //Center
        if (targetYcenter.toInt() >= currentYcenter.toInt() - alignmentThreshold &&
            targetYcenter.toInt() <= currentYcenter.toInt() + alignmentThreshold) {
          _horizontalLineY = currentYcenter;
        }
        if (targetYcenter.toInt() >= currentYtop.toInt() - alignmentThreshold &&
            targetYcenter.toInt() <= currentYtop.toInt() + alignmentThreshold) {
          _horizontalLineY = currentYtop;
        }
        if (targetYcenter.toInt() >= currentYbottom.toInt() - alignmentThreshold &&
            targetYcenter.toInt() <= currentYbottom.toInt() + alignmentThreshold) {
          _horizontalLineY = currentYbottom;
        }

        //Bottom
        if (targetYbottom.toInt() >= currentYcenter.toInt() - alignmentThreshold &&
            targetYbottom.toInt() <= currentYcenter.toInt() + alignmentThreshold) {
          _horizontalLineY = currentYcenter;
        }
        if (targetYbottom.toInt() >= currentYtop.toInt() - alignmentThreshold &&
            targetYbottom.toInt() <= currentYtop.toInt() + alignmentThreshold) {
          _horizontalLineY = currentYtop;
        }
        if (targetYbottom.toInt() >= currentYbottom.toInt() - alignmentThreshold &&
            targetYbottom.toInt() <= currentYbottom.toInt() + alignmentThreshold) {
          _horizontalLineY = currentYbottom;
        }

        // List<Offset> temPositions = [];
        // temPositions.addAll(_positions);
        // temPositions.removeAt(currentIndex);
        // if (temPositions.any((element) => element.dy == _positions[currentIndex].dy)) {
        //   _verticalLineX = (currentY + targetY) / 2;
        // }
        // if (distanceX < alignmentThreshold) {
        //   _verticalLineX = (currentY + targetY) / 2;
        //   print(_verticalLineX);
        // }

        // if (distanceY < alignmentThreshold) {
        //   _horizontalLineY = (currentX + targetX) / 2;
        //   print(_horizontalLineY);
        // }
      }
    }
    setState(() {});
  }
}

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
    const double dashSpace = 7;

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
