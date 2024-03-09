import 'package:flutter/material.dart';

class AlignmentTask5 extends StatefulWidget {
  const AlignmentTask5({Key? key}) : super(key: key);

  @override
  State<AlignmentTask5> createState() => _AlignmentTask5State();
}

class _AlignmentTask5State extends State<AlignmentTask5> {
  final List<Offset> _positions = [const Offset(0.0, 0.0), const Offset(100.0, 100.0)];
  final List<double> _imageScales = [1.0, 1.0];
  final List<Size> _imageSizes = [const Size(100.0, 100.0), const Size(150.0, 150.0)];
  final int alignmentThreshold = 2;
  double horizontalHighlightLineY = 0;
  double verticalHighlightLineX = 0;
  double lineLeft = 0;
  double lineRight = 0;
  double lineTop = 0;
  double lineBottom = 0;

  bool isShow = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Element Alignment'),
      ),
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
                  Visibility(
                    visible: isShow,
                    child: CustomPaint(
                      painter: HighlightDottedLinePainter(
                        horizontalLineY: horizontalHighlightLineY,
                        verticalLineX: verticalHighlightLineX,
                      ),
                      size: const Size(double.infinity, double.infinity), // Set a large size
                    ),
                  ),
                  Visibility(
                    visible: isShow,
                    child: CustomPaint(
                      painter: DottedLinePainter(
                        lineBottom: lineBottom,
                        lineLeft: lineLeft,
                        lineRight: lineRight,
                        lineTop: lineTop,
                      ),
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
                            // double newSize = (_imageSizes[i].height / _imageSizes[i].width) * details.scale;
                            // double newScale = details.scale;

                            // if (newSize >= 100.0 && newSize <= 400.0) {
                            //   setState(() {
                            //     _imageScales[i] = newScale.clamp(1.0, 4.0);
                            //     _imageSizes[i] = newSize;
                            //   });
                            // }
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
                          isShow = false;
                          setState(() {});
                        },
                        child: Transform.scale(
                          scale: _imageScales[i],
                          child: SizedBox(
                            height: _imageSizes[i].height,
                            width: _imageSizes[i].width,
                            child: Image.asset(
                              'assets/image/summer-lettering-with-photo_23-2148520683.jpg',
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

    horizontalHighlightLineY = 0;
    verticalHighlightLineX = 0;

    double currentXcenter = _positions[currentIndex].dx + _imageSizes[currentIndex].width / 2;
    double currentXright = _positions[currentIndex].dx + _imageSizes[currentIndex].width;
    double currentXleft = _positions[currentIndex].dx;

    double currentYcenter = _positions[currentIndex].dy + _imageSizes[currentIndex].height / 2;
    double currentYbottom = _positions[currentIndex].dy + _imageSizes[currentIndex].height;
    double currentYtop = _positions[currentIndex].dy;

    lineLeft = currentXleft;
    lineRight = currentXright;
    lineTop = currentYtop;
    lineBottom = currentYbottom;

    for (int i = 0; i < _positions.length; i++) {
      if (i != currentIndex) {
        // Horizontal
        double targetXcenter = _positions[i].dx + _imageSizes[i].width / 2;
        double targetXright = _positions[i].dx + _imageSizes[i].width;
        double targetXleft = _positions[i].dx;

        _xAlignment(currentXleft, targetXleft);
        _xAlignment(currentXleft, targetXcenter);
        _xAlignment(currentXleft, targetXright);
        _xAlignment(currentXcenter, targetXleft);
        _xAlignment(currentXcenter, targetXcenter);
        _xAlignment(currentXcenter, targetXright);
        _xAlignment(currentXright, targetXleft);
        _xAlignment(currentXright, targetXcenter);
        _xAlignment(currentXright, targetXright);

        // Horizontal
        double targetYcenter = _positions[i].dy + _imageSizes[i].height / 2;
        double targetYbottom = _positions[i].dy + _imageSizes[i].height;
        double targetYtop = _positions[i].dy;

        _yAlignment(currentYtop, targetYtop);
        _yAlignment(currentYtop, targetYcenter);
        _yAlignment(currentYtop, targetYbottom);
        _yAlignment(currentYcenter, targetYtop);
        _yAlignment(currentYcenter, targetYcenter);
        _yAlignment(currentYcenter, targetYbottom);
        _yAlignment(currentYbottom, targetYtop);
        _yAlignment(currentYbottom, targetYcenter);
        _yAlignment(currentYbottom, targetYbottom);
      }
    }
    setState(() {});
  }

  void _xAlignment(double currentXcenter, double targetXcenter) {
    return updateAlignment(
      current: currentXcenter,
      target: targetXcenter,
      alignmentThreshold: alignmentThreshold,
      onDateSelected: (current) => verticalHighlightLineX = current,
    );
  }

  void _yAlignment(double currentYcenter, double targetYcenter) {
    return updateAlignment(
      current: currentYcenter,
      target: targetYcenter,
      vertical: true,
      alignmentThreshold: alignmentThreshold,
      onDateSelected: (current) => horizontalHighlightLineY = current,
    );
  }
}

void updateAlignment({
  required double current,
  required double target,
  bool vertical = false,
  required int alignmentThreshold,
  required void Function(double) onDateSelected,
}) {
  if (target.toInt() >= current.toInt() - alignmentThreshold &&
      target.toInt() <= current.toInt() + alignmentThreshold) {
    if (vertical) {
      print('>>>>>>>>>>>>>>> VVVV');
      onDateSelected(current);
    } else {
      print('>>>>>>>>>>>>>>> HHH');

      onDateSelected(current);
    }
  }
}

class HighlightDottedLinePainter extends CustomPainter {
  final double horizontalLineY;
  final double verticalLineX;

  HighlightDottedLinePainter({
    required this.horizontalLineY,
    required this.verticalLineX,
  });

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

class DottedLinePainter extends CustomPainter {
  final double lineLeft;
  final double lineRight;
  final double lineTop;
  final double lineBottom;
  DottedLinePainter({
    required this.lineLeft,
    required this.lineRight,
    required this.lineBottom,
    required this.lineTop,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = Colors.grey.withOpacity(0.3)
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    const double dashWidth = 5;
    const double dashSpace = 7;
    if (lineTop > 0) {
      double currentX = 0;
      while (currentX < size.width) {
        canvas.drawLine(Offset(currentX, lineTop), Offset(currentX + dashWidth, lineTop), paint);
        currentX += dashWidth + dashSpace;
      }
    }
    if (lineBottom > 0) {
      double currentX = 0;
      while (currentX < size.width) {
        canvas.drawLine(Offset(currentX, lineBottom), Offset(currentX + dashWidth, lineBottom), paint);
        currentX += dashWidth + dashSpace;
      }
    }

    if (lineLeft > 0) {
      double currentY = 0;
      while (currentY < size.height) {
        canvas.drawLine(Offset(lineLeft, currentY), Offset(lineLeft, currentY + dashWidth), paint);
        currentY += dashWidth + dashSpace;
      }
    }
    if (lineRight > 0) {
      double currentY = 0;
      while (currentY < size.height) {
        canvas.drawLine(Offset(lineRight, currentY), Offset(lineRight, currentY + dashWidth), paint);
        currentY += dashWidth + dashSpace;
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
