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
            ),
          ),
        ),
      ),
    );
  }
}
