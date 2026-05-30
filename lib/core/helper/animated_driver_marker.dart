// ignore_for_file: deprecated_member_use

import 'dart:math' as math;
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class AnimatedDriverMarker {
  static Future<BitmapDescriptor> build({
    double bearingDegrees = 0,
    Color color = const Color(0xFF00C853),
    double size = 80,
  }) async {
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder, Rect.fromLTWH(0, 0, size, size));

    final center = Offset(size / 2, size / 2);

    final glowPaint = Paint()
      ..color = color.withValues(alpha: 0.18)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10);
    canvas.drawCircle(center, size / 2 - 2, glowPaint);

    final bgPaint = Paint()..color = Colors.white;
    canvas.drawCircle(center, size / 2 - 8, bgPaint);

    final ringPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    canvas.drawCircle(center, size / 2 - 8, ringPaint);

    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate((bearingDegrees - 90) * math.pi / 180);
    canvas.translate(-center.dx, -center.dy);

    _drawCar(canvas, center, size, color);

    canvas.restore();

    final picture = recorder.endRecording();
    final image = await picture.toImage(size.toInt(), size.toInt());
    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    final bytes = byteData!.buffer.asUint8List();

    return BitmapDescriptor.fromBytes(bytes);
  }

  static void _drawCar(Canvas canvas, Offset center, double size, Color color) {
    final s = size * 0.5;
    final cx = center.dx;
    final cy = center.dy;

    final bodyPaint = Paint()..color = color;
    final darkPaint = Paint()..color = color.withValues(alpha: 0.75);
    final windowPaint = Paint()..color = const Color(0xFFB3E5FC);
    final lightPaint = Paint()..color = const Color(0xFFFFF9C4);
    final whitePaint = Paint()..color = Colors.white;

    final bodyRect = RRect.fromRectAndRadius(
      Rect.fromCenter(
        center: Offset(cx, cy + s * 0.05),
        width: s * 0.7,
        height: s * 1.1,
      ),
      const Radius.circular(8),
    );
    canvas.drawRRect(bodyRect, bodyPaint);

    final cabinPath = Path();
    cabinPath.moveTo(cx - s * 0.22, cy - s * 0.05);
    cabinPath.lineTo(cx - s * 0.15, cy - s * 0.38);
    cabinPath.lineTo(cx + s * 0.15, cy - s * 0.38);
    cabinPath.lineTo(cx + s * 0.22, cy - s * 0.05);
    cabinPath.close();
    canvas.drawPath(cabinPath, darkPaint);

    final windshieldPath = Path();
    windshieldPath.moveTo(cx - s * 0.17, cy - s * 0.07);
    windshieldPath.lineTo(cx - s * 0.12, cy - s * 0.35);
    windshieldPath.lineTo(cx + s * 0.12, cy - s * 0.35);
    windshieldPath.lineTo(cx + s * 0.17, cy - s * 0.07);
    windshieldPath.close();
    canvas.drawPath(windshieldPath, windowPaint);

    final rearPath = Path();
    rearPath.moveTo(cx - s * 0.17, cy + s * 0.12);
    rearPath.lineTo(cx - s * 0.12, cy + s * 0.28);
    rearPath.lineTo(cx + s * 0.12, cy + s * 0.28);
    rearPath.lineTo(cx + s * 0.17, cy + s * 0.12);
    rearPath.close();
    canvas.drawPath(rearPath, windowPaint);

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: Offset(cx - s * 0.18, cy - s * 0.48),
          width: s * 0.14,
          height: s * 0.08,
        ),
        const Radius.circular(3),
      ),
      lightPaint,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: Offset(cx + s * 0.18, cy - s * 0.48),
          width: s * 0.14,
          height: s * 0.08,
        ),
        const Radius.circular(3),
      ),
      lightPaint,
    );

    final tailPaint = Paint()..color = const Color(0xFFEF5350);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: Offset(cx - s * 0.18, cy + s * 0.5),
          width: s * 0.14,
          height: s * 0.07,
        ),
        const Radius.circular(3),
      ),
      tailPaint,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: Offset(cx + s * 0.18, cy + s * 0.5),
          width: s * 0.14,
          height: s * 0.07,
        ),
        const Radius.circular(3),
      ),
      tailPaint,
    );

    final wheelPaint = Paint()..color = const Color(0xFF37474F);
    for (final dx in [-s * 0.33, s * 0.33]) {
      for (final dy in [-s * 0.3, s * 0.32]) {
        canvas.drawRRect(
          RRect.fromRectAndRadius(
            Rect.fromCenter(
              center: Offset(cx + dx, cy + dy),
              width: s * 0.18,
              height: s * 0.22,
            ),
            const Radius.circular(4),
          ),
          wheelPaint,
        );
        canvas.drawCircle(Offset(cx + dx, cy + dy), s * 0.06, whitePaint);
      }
    }
  }
}

double calculateBearing(LatLng from, LatLng to) {
  final lat1 = from.latitude * math.pi / 180;
  final lat2 = to.latitude * math.pi / 180;
  final dLng = (to.longitude - from.longitude) * math.pi / 180;

  final y = math.sin(dLng) * math.cos(lat2);
  final x =
      math.cos(lat1) * math.sin(lat2) -
      math.sin(lat1) * math.cos(lat2) * math.cos(dLng);

  return (math.atan2(y, x) * 180 / math.pi + 360) % 360;
}

LatLng lerpLatLng(LatLng a, LatLng b, double t) {
  return LatLng(
    a.latitude + (b.latitude - a.latitude) * t,
    a.longitude + (b.longitude - a.longitude) * t,
  );
}
