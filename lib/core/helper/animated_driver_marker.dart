import 'dart:math' as math;
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

/// Builds a high-quality animated car marker bitmap with rotation support.
/// The car icon is drawn via Canvas so no asset is required.
class AnimatedDriverMarker {
  /// Renders a car-shaped BitmapDescriptor rotated to [bearingDegrees].
  /// [color] is the fill color of the car body.
  static Future<BitmapDescriptor> build({
    double bearingDegrees = 0,
    Color color = const Color(0xFF00C853),
    double size = 80,
  }) async {
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(
      recorder,
      Rect.fromLTWH(0, 0, size, size),
    );

    final center = Offset(size / 2, size / 2);

    // ── Outer glow ring ────────────────────────────────────────────────────
    final glowPaint = Paint()
      ..color = color.withOpacity(0.18)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10);
    canvas.drawCircle(center, size / 2 - 2, glowPaint);

    // ── White background circle ─────────────────────────────────────────────
    final bgPaint = Paint()..color = Colors.white;
    canvas.drawCircle(center, size / 2 - 8, bgPaint);

    // ── Thin accent ring ────────────────────────────────────────────────────
    final ringPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    canvas.drawCircle(center, size / 2 - 8, ringPaint);

    // ── Rotate canvas to bearing ────────────────────────────────────────────
    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate((bearingDegrees - 90) * math.pi / 180);
    canvas.translate(-center.dx, -center.dy);

    // ── Draw car body ───────────────────────────────────────────────────────
    _drawCar(canvas, center, size, color);

    canvas.restore();

    // ── Convert to BitmapDescriptor ─────────────────────────────────────────
    final picture = recorder.endRecording();
    final image = await picture.toImage(size.toInt(), size.toInt());
    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    final bytes = byteData!.buffer.asUint8List();

    return BitmapDescriptor.fromBytes(bytes);
  }

  static void _drawCar(
      Canvas canvas, Offset center, double size, Color color) {
    final s = size * 0.5; // scale factor
    final cx = center.dx;
    final cy = center.dy;

    final bodyPaint = Paint()..color = color;
    final darkPaint = Paint()..color = color.withOpacity(0.75);
    final windowPaint = Paint()..color = const Color(0xFFB3E5FC);
    final lightPaint = Paint()..color = const Color(0xFFFFF9C4);
    final whitePaint = Paint()..color = Colors.white;

    // Body
    final bodyRect = RRect.fromRectAndRadius(
      Rect.fromCenter(center: Offset(cx, cy + s * 0.05), width: s * 0.7, height: s * 1.1),
      const Radius.circular(8),
    );
    canvas.drawRRect(bodyRect, bodyPaint);

    // Cabin (roof)
    final cabinPath = Path();
    cabinPath.moveTo(cx - s * 0.22, cy - s * 0.05);
    cabinPath.lineTo(cx - s * 0.15, cy - s * 0.38);
    cabinPath.lineTo(cx + s * 0.15, cy - s * 0.38);
    cabinPath.lineTo(cx + s * 0.22, cy - s * 0.05);
    cabinPath.close();
    canvas.drawPath(cabinPath, darkPaint);

    // Windshield
    final windshieldPath = Path();
    windshieldPath.moveTo(cx - s * 0.17, cy - s * 0.07);
    windshieldPath.lineTo(cx - s * 0.12, cy - s * 0.35);
    windshieldPath.lineTo(cx + s * 0.12, cy - s * 0.35);
    windshieldPath.lineTo(cx + s * 0.17, cy - s * 0.07);
    windshieldPath.close();
    canvas.drawPath(windshieldPath, windowPaint);

    // Rear window
    final rearPath = Path();
    rearPath.moveTo(cx - s * 0.17, cy + s * 0.12);
    rearPath.lineTo(cx - s * 0.12, cy + s * 0.28);
    rearPath.lineTo(cx + s * 0.12, cy + s * 0.28);
    rearPath.lineTo(cx + s * 0.17, cy + s * 0.12);
    rearPath.close();
    canvas.drawPath(rearPath, windowPaint);

    // Headlights (front)
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(center: Offset(cx - s * 0.18, cy - s * 0.48), width: s * 0.14, height: s * 0.08),
        const Radius.circular(3),
      ),
      lightPaint,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(center: Offset(cx + s * 0.18, cy - s * 0.48), width: s * 0.14, height: s * 0.08),
        const Radius.circular(3),
      ),
      lightPaint,
    );

    // Tail lights
    final tailPaint = Paint()..color = const Color(0xFFEF5350);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(center: Offset(cx - s * 0.18, cy + s * 0.5), width: s * 0.14, height: s * 0.07),
        const Radius.circular(3),
      ),
      tailPaint,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(center: Offset(cx + s * 0.18, cy + s * 0.5), width: s * 0.14, height: s * 0.07),
        const Radius.circular(3),
      ),
      tailPaint,
    );

    // Wheels
    final wheelPaint = Paint()..color = const Color(0xFF37474F);
    for (final dx in [-s * 0.33, s * 0.33]) {
      for (final dy in [-s * 0.3, s * 0.32]) {
        canvas.drawRRect(
          RRect.fromRectAndRadius(
            Rect.fromCenter(center: Offset(cx + dx, cy + dy), width: s * 0.18, height: s * 0.22),
            const Radius.circular(4),
          ),
          wheelPaint,
        );
        // Hubcap
        canvas.drawCircle(Offset(cx + dx, cy + dy), s * 0.06, whitePaint);
      }
    }
  }
}

/// Calculates the compass bearing between two LatLng points (in degrees, 0=North).
double calculateBearing(LatLng from, LatLng to) {
  final lat1 = from.latitude * math.pi / 180;
  final lat2 = to.latitude * math.pi / 180;
  final dLng = (to.longitude - from.longitude) * math.pi / 180;

  final y = math.sin(dLng) * math.cos(lat2);
  final x = math.cos(lat1) * math.sin(lat2) -
      math.sin(lat1) * math.cos(lat2) * math.cos(dLng);

  return (math.atan2(y, x) * 180 / math.pi + 360) % 360;
}

/// Smoothly interpolates between two LatLng positions.
LatLng lerpLatLng(LatLng a, LatLng b, double t) {
  return LatLng(
    a.latitude + (b.latitude - a.latitude) * t,
    a.longitude + (b.longitude - a.longitude) * t,
  );
}
