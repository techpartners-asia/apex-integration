import 'dart:math' as math;
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:mini_app_sdk/mini_app_sdk.dart';

class SignatureUploadService {
  final MiniAppProfileRepository appApi;

  const SignatureUploadService({required this.appApi});

  Future<void> uploadSignature(
    List<Offset?> points, {
    double strokeWidth = 2.6,
    String fileName = 'signature.png',
  }) async {
    final Uint8List bytes = await renderSignaturePngBytes(
      points,
      strokeWidth: strokeWidth,
    );

    await appApi.updateSignature(bytes: bytes, fileName: fileName);
  }
}

Future<Uint8List> renderSignaturePngBytes(
  List<Offset?> points, {
  double strokeWidth = 2.6,
}) async {
  final List<Offset> offsets = points.whereType<Offset>().toList(
    growable: false,
  );
  if (offsets.isEmpty) {
    throw ArgumentError('Signature points are empty.');
  }

  final double maxX = offsets.fold<double>(
    0,
    (double previous, Offset point) => math.max(previous, point.dx),
  );
  final double maxY = offsets.fold<double>(
    0,
    (double previous, Offset point) => math.max(previous, point.dy),
  );
  const double padding = 24;
  final double width = math.max(maxX + padding, 320);
  final double height = math.max(maxY + padding, 180);

  final ui.PictureRecorder recorder = ui.PictureRecorder();
  final Canvas canvas = Canvas(recorder);
  final Rect rect = Rect.fromLTWH(0, 0, width, height);
  canvas.drawRect(rect, Paint()..color = Colors.white);

  final Paint strokePaint = Paint()
    ..color = const Color(0xFF1F2937)
    ..strokeWidth = strokeWidth
    ..strokeCap = StrokeCap.round
    ..style = PaintingStyle.stroke;

  for (int index = 0; index < points.length - 1; index += 1) {
    final Offset? current = points[index];
    final Offset? next = points[index + 1];
    if (current == null || next == null) {
      continue;
    }
    canvas.drawLine(current, next, strokePaint);
  }

  final ui.Image image = await recorder.endRecording().toImage(
    width.ceil(),
    height.ceil(),
  );
  final ByteData? data = await image.toByteData(format: ui.ImageByteFormat.png);
  if (data == null) {
    throw StateError('Failed to encode signature image.');
  }
  return data.buffer.asUint8List();
}
