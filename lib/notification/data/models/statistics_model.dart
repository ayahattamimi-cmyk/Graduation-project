///   يمثّل ملخص إحصائيات البلاغات للعرض في بطاقات صفحة

class StatisticModel {
  final int total;
  final int active;
  final int resolved;
  final String resolutionRate;

  StatisticModel({
    required this.total,
    required this.active,
    required this.resolved,
    required this.resolutionRate,
  });

  factory StatisticModel.fromJson(Map<String, dynamic> json) {
    return StatisticModel(
      total: _parseInt(json['total']),
      active: _parseInt(json['active']),
      resolved: _parseInt(json['resolved']),
      resolutionRate: json['resolution_rate']?.toString() ?? '0%',
    );
  }

  static int _parseInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is double) return value.toInt();
    return int.tryParse(value.toString()) ?? 0;
  }
}
