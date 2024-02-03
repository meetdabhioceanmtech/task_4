import 'package:flutter/material.dart';

class ZoomExample extends StatefulWidget {
  const ZoomExample({Key? key}) : super(key: key);

  @override
  State<ZoomExample> createState() => _ZoomExampleState();
}

class _ZoomExampleState extends State<ZoomExample> {
  final List<Offset> _positions = [const Offset(0.0, 0.0), const Offset(100.0, 100.0), const Offset(200.0, 200.0)];
  final List<double> _imageScales = [1.0, 1.0, 1.0];
  final List<double> _imageSizes = [100.0, 150.0, 200.0];
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
}
