import 'package:flutter/foundation.dart';

class SafeParser {
  /// تحويل أي قيمة إلى int بشكل آمن (يعالج النصوص، الأرقام المكسورة، والـ Null)
  static int parseInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is double) return value.toInt();

    try {
      return int.tryParse(value.toString()) ?? 0;
    } catch (e) {
      debugPrint("⚠️ SafeParser: Error parsing int from $value");
      return 0;
    }
  }

  /// تحويل أي قيمة إلى double بشكل آمن
  static double parseDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is double) return value;
    if (value is int) return value.toDouble();

    try {
      return double.tryParse(value.toString()) ?? 0.0;
    } catch (e) {
      debugPrint("⚠️ SafeParser: Error parsing double from $value");
      return 0.0;
    }
  }

  /// تحويل القيمة إلى String بشكل آمن (يعالج الـ Null)
  static String parseString(dynamic value, {String defaultValue = ""}) {
    if (value == null) return defaultValue;
    return value.toString();
  }
}
