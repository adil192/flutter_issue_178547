import 'dart:ui' as ui;

import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  ui.Image? _capturedImage;

  void _captureImage() async {
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);
    const size = Size(400, 400);

    // Paint the same content as in _MyPainter
    _MyPainter().paint(canvas, size);

    final picture = recorder.endRecording();
    final image = await picture.toImage(
      size.width.toInt(),
      size.height.toInt(),
    );

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
              child: CustomPaint(size: Size.infinite, painter: _MyPainter()),
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
