import 'package:flutter/foundation.dart';

/// فئة أدوات تحتوي وسائط ثابتة لتحليل القيم الديناميكية بأمان
/// إلى [int] أو [double] أو [String] مع قيم افتراضية احتياطية.
class SafeParser {
  /// يحلل [value] إلى [int]. يعيد 0 للقيم الخالية أو غير القابلة للتحليل.
  static int parseInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is double) return value.toInt();

    try {
      return int.tryParse(value.toString()) ?? 0;
    } catch (e) {
      return 0;
    }
  }

  /// يحلل [value] إلى [double]. يعيد 0.0 للقيم الخالية أو غير القابلة للتحليل.
  static double parseDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is double) return value;
    if (value is int) return value.toDouble();

    try {
      return double.tryParse(value.toString()) ?? 0.0;
    } catch (e) {
      return 0.0;
    }
  }

  /// يحلل [value] إلى [String]. يعيد [defaultValue] (سلسلة فارغة افتراضيًا) للقيم الخالية.
  static String parseString(dynamic value, {String defaultValue = ""}) {
    if (value == null) return defaultValue;
    return value.toString();
  }
}
