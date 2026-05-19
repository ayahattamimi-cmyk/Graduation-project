class DashboardModel {
  final StatisticsModel statistics;
  final List<ClassificationModel> classifications;
  final List<MonthlyStatModel> monthlyStats;
  final List<TopAreaModel> topAreas;

  DashboardModel({
    required this.statistics,
    required this.classifications,
    required this.monthlyStats,
    required this.topAreas,
  });

  factory DashboardModel.fromJson(Map<String, dynamic> json) {
    return DashboardModel(
      statistics: StatisticsModel.fromJson(json['statistics']),
      classifications:
          (json['classification'] as List)
              .map((i) => ClassificationModel.fromJson(i))
              .toList(),
      monthlyStats:
          (json['monthly_stats'] as List)
              .map((i) => MonthlyStatModel.fromJson(i))
              .toList(),
      topAreas:
          (json['top_areas'] as List)
              .map((i) => TopAreaModel.fromJson(i))
              .toList(),
    );
  }
}

class StatisticsModel {
  final int totalReports;
  final StatDetail resolved;
  final StatDetail inProgress;
  final StatDetail pending;

  StatisticsModel({
    required this.totalReports,
    required this.resolved,
    required this.inProgress,
    required this.pending,
  });

  factory StatisticsModel.fromJson(Map<String, dynamic> json) {
    return StatisticsModel(
      totalReports: json['total_reports'] ?? 0,
      resolved: StatDetail.fromJson(json['resolved']),
      inProgress: StatDetail.fromJson(json['in_progress']),
      pending: StatDetail.fromJson(json['pending']),
    );
  }
}

class StatDetail {
  final int count;
  final int percentage;

  StatDetail({required this.count, required this.percentage});

  factory StatDetail.fromJson(Map<String, dynamic> json) {
    return StatDetail(
      count: json['count'] ?? 0,
      percentage: json['percentage'] ?? 0,
    );
  }
}

class ClassificationModel {
  final String type;
  final int count;
  final double percentage;

  ClassificationModel({
    required this.type,
    required this.count,
    required this.percentage,
  });

  factory ClassificationModel.fromJson(Map<String, dynamic> json) {
    return ClassificationModel(
      type: json['type'] ?? '',
      count: json['count'] ?? 0,
      percentage: (json['percentage'] as num).toDouble(),
    );
  }
}

class MonthlyStatModel {
  final String month;
  final int count;

  MonthlyStatModel({required this.month, required this.count});

  factory MonthlyStatModel.fromJson(Map<String, dynamic> json) {
    return MonthlyStatModel(
      month: json['month'] ?? '',
      count: json['count'] ?? 0,
    );
  }
}

class TopAreaModel {
  final String name;
  final int count;

  TopAreaModel({required this.name, required this.count});

  factory TopAreaModel.fromJson(Map<String, dynamic> json) {
    return TopAreaModel(name: json['name'] ?? '', count: json['count'] ?? 0);
  }
}
