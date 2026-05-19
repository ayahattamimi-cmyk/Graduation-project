class ReportStatisticsModel {
  final int total;
  final int active;
  final int resolved;
  final String resolutionRate;

  ReportStatisticsModel({
    required this.total,
    required this.active,
    required this.resolved,
    required this.resolutionRate,
  });

  factory ReportStatisticsModel.fromJson(Map<String, dynamic> json) {
    return ReportStatisticsModel(
      total: json['total'] ?? 0,
      active: json['active'] ?? 0,
      resolved: json['resolved'] ?? 0,
      resolutionRate: json['resolution_rate'] ?? '0%',
    );
  }
}
