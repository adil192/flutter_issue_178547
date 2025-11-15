import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  final _repaintBoundaryKey = GlobalKey();

  ui.Image? _capturedImage;

  void _captureImage() async {
    final renderObject =
        _repaintBoundaryKey.currentContext?.findRenderObject()
            as RenderRepaintBoundary?;
    if (renderObject == null) return;

    final image = await renderObject.toImage();
    _capturedImage?.dispose();
    setState(() {
      _capturedImage = image;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Column(
          children: [
            Expanded(
              child: RepaintBoundary(
                key: _repaintBoundaryKey,
                child: CustomPaint(size: Size.infinite, painter: _MyPainter()),
              ),
            ),
            ElevatedButton(
              onPressed: _captureImage,
              child: Text('Capture Image'),
            ),
            Expanded(
              child: _capturedImage != null
                  ? RawImage(image: _capturedImage)
                  : Placeholder(),
            ),
          ],
        ),
      ),
    );
  }
}

class _MyPainter extends CustomPainter {
  const _MyPainter();

  @override
  void paint(Canvas canvas, Size size) {
    // Draw green background
    canvas.drawRect(Offset.zero & size, Paint()..color = Color(0xFFAAFFAA));

    // Draw a stroke
    final path = Path()
      ..moveTo(size.width * 0.2, size.height * 0.2)
      ..lineTo(size.width * 0.8, size.height * 0.2)
      ..lineTo(size.width * 0.8, size.height * 0.8)
      ..close();
    canvas.drawPath(
      path,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 8
        ..strokeJoin = StrokeJoin.round,
    );
  }

  @override
  bool shouldRepaint(_) => false;
}
