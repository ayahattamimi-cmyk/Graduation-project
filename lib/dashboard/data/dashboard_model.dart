class DashboardModel {
  final StatisticsModel statistics;
  final List<ClassificationModel> classifications;
  final List<MonthlyStatModel> monthlyStats;
  final List<TopAreaModel> topAreas;

  /// ينشئ [DashboardModel] الرئيسي الذي يغلّف جميع بيانات لوحة التحكم.
  DashboardModel({
    required this.statistics,
    required this.classifications,
    required this.monthlyStats,
    required this.topAreas,
  });

  /// ينشئ [DashboardModel] من خريطة JSON التي أرجعها API.
  factory DashboardModel.fromJson(Map<String, dynamic> json) {
    return DashboardModel(
      statistics: StatisticsModel.fromJson(json['statistics'] ?? {}),
      classifications:
          (json['classification'] as List?)
              ?.map((i) => ClassificationModel.fromJson(i))
              .toList() ??
          [],
      monthlyStats:
          (json['monthly_stats'] as List?)
              ?.map((i) => MonthlyStatModel.fromJson(i))
              .toList() ??
          [],
      topAreas:
          (json['top_areas'] as List?)
              ?.map((i) => TopAreaModel.fromJson(i))
              .toList() ??
          [],
    );
  }
}

class StatisticsModel {
  final int totalReports;
  final StatDetail resolved;
  final StatDetail inProgress;
  final StatDetail pending;

  /// ينشئ [StatisticsModel] يحمل إحصائيات البلاغات الإجمالية.
  StatisticsModel({
    required this.totalReports,
    required this.resolved,
    required this.inProgress,
    required this.pending,
  });

  /// ينشئ [StatisticsModel] من خريطة JSON.
  factory StatisticsModel.fromJson(Map<String, dynamic> json) {
    return StatisticsModel(
      totalReports: _parseInt(json['total_reports']),
      resolved: StatDetail.fromJson(json['resolved'] ?? {}),
      inProgress: StatDetail.fromJson(json['in_progress'] ?? {}),
      pending: StatDetail.fromJson(json['pending'] ?? {}),
    );
  }
}

class StatDetail {
  final int count;
  final double percentage;

  /// ينشئ [StatDetail] بعدد ونسبة مئوية.
  StatDetail({required this.count, required this.percentage});

  /// ينشئ [StatDetail] من خريطة JSON.
  factory StatDetail.fromJson(Map<String, dynamic> json) {
    return StatDetail(
      count: _parseInt(json['count']),
      percentage: _toDouble(json['percentage']),
    );
  }
}

class ClassificationModel {
  final String type;
  final int count;
  final double percentage;

  /// ينشئ [ClassificationModel] لتوزيع أنواع البلاغات.
  ClassificationModel({
    required this.type,
    required this.count,
    required this.percentage,
  });

  /// ينشئ [ClassificationModel] من خريطة JSON.
  factory ClassificationModel.fromJson(Map<String, dynamic> json) {
    return ClassificationModel(
      type: json['type']?.toString() ?? '',
      count: _parseInt(json['count']),
      percentage: _toDouble(json['percentage']),
    );
  }
}

class MonthlyStatModel {
  final String month;
  final int count;

  /// ينشئ [MonthlyStatModel] لإحصائيات البلاغات الشهرية.
  MonthlyStatModel({required this.month, required this.count});

  /// ينشئ [MonthlyStatModel] من خريطة JSON.
  factory MonthlyStatModel.fromJson(Map<String, dynamic> json) {
    return MonthlyStatModel(
      month: json['month']?.toString() ?? '',
      count: _parseInt(json['count']),
    );
  }
}

class TopAreaModel {
  final String name;
  final int count;

  /// ينشئ [TopAreaModel] لأكثر المناطق تفاعلاً.
  TopAreaModel({required this.name, required this.count});

  /// ينشئ [TopAreaModel] من خريطة JSON.
  factory TopAreaModel.fromJson(Map<String, dynamic> json) {
    return TopAreaModel(
      name: json['name']?.toString() ?? '',
      count: _parseInt(json['count']),
    );
  }
}

int _parseInt(dynamic v) {
  if (v == null) return 0;
  if (v is int) return v;
  if (v is double) return v.toInt();
  return int.tryParse(v.toString()) ?? 0;
}

double _toDouble(dynamic v) {
  if (v == null) return 0.0;
  if (v is double) return v;
  if (v is int) return v.toDouble();
  return double.tryParse(v.toString()) ?? 0.0;
}
