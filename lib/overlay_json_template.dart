import 'package:flutter/material.dart';

class OverlayJsonTemplate extends StatefulWidget {
  const OverlayJsonTemplate({super.key});

  @override
  State<OverlayJsonTemplate> createState() => _OverlayJsonTemplateState();
}

class _OverlayJsonTemplateState extends State<OverlayJsonTemplate> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Overlay json template'),
      ),
      body: Container(
        color: Colors.grey.withOpacity(0.3),
        child: Center(
          child: AspectRatio(
            aspectRatio: 1.0,
            child: Container(
              color: Colors.white,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    'https://img.freepik.com/free-photo/blue-wall-background_53876-88663.jpg?w=740&t=st=1706849199~exp=1706849799~hmac=8d50b1869dcaa518eaadb637f5de92cd0edc1e3ae59d1ee88d9377e258d1b91a',
                    fit: BoxFit.cover,
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
