import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapMarkerHelper {
  static Future<BitmapDescriptor> getMarkerIconFromIcon(
    IconData iconData,
    Color color,
    double size, {
    bool hasBackground = false, // ميزة جديدة: التحكم بالخلفية البيضاء
  }) async {
    final ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
    final Canvas canvas = Canvas(pictureRecorder);
    final double iconSize = size;

    // إذا كان المطلوب خلفية (مثل الحاويات)، يتم رسم الدائرة البيضاء والإطار
    if (hasBackground) {
      // رسم دائرة بيضاء كخلفية للأيقونة لتبرز على الخريطة
      final Paint paint = Paint()..color = Colors.white;
      canvas.drawCircle(
        Offset(iconSize / 2, iconSize / 2),
        iconSize / 2,
        paint,
      );

      // رسم إطار دائري ملون
      final Paint borderPaint =
          Paint()
            ..color = color
            ..style = PaintingStyle.stroke
            ..strokeWidth = iconSize * 0.05;
      canvas.drawCircle(
        Offset(iconSize / 2, iconSize / 2),
        iconSize / 2,
        borderPaint,
      );
    }

    final TextPainter textPainter = TextPainter(
      textDirection: TextDirection.rtl,
    );
    textPainter.text = TextSpan(
      text: String.fromCharCode(iconData.codePoint),
      style: TextStyle(
        // إذا لم تكن هناك خلفية، نكبر حجم الأيقونة قليلاً ليأخذ المساحة كاملة
        fontSize: hasBackground ? iconSize * 0.6 : iconSize,
        fontFamily: iconData.fontFamily,
        color: color,
        package: iconData.fontPackage,
        fontWeight: FontWeight.bold,
      ),
    );

    textPainter.layout();

    // وضع الأيقونة في المنتصف تماماً
    textPainter.paint(
      canvas,
      Offset(
        (iconSize - textPainter.width) / 2,
        (iconSize - textPainter.height) / 2,
      ),
    );

    final ui.Image image = await pictureRecorder.endRecording().toImage(
      iconSize.toInt(),
      iconSize.toInt(),
    );
    final data = await image.toByteData(format: ui.ImageByteFormat.png);

    return BitmapDescriptor.fromBytes(data!.buffer.asUint8List());
  }
}
