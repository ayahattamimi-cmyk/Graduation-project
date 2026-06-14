class StatisticsModel {
  final int totalSupervisors;
  final int liftingCount;
  final int sweepingCount;

  StatisticsModel({
    required this.totalSupervisors,
    required this.liftingCount,
    required this.sweepingCount,
  });

  /// ينشئ [StatisticsModel] من خريطة JSON.
  factory StatisticsModel.fromJson(Map<String, dynamic> json) {
    return StatisticsModel(
      totalSupervisors: json['total_supervisors'] ?? 0,
      liftingCount: json['lifting_count'] ?? 0,
      sweepingCount: json['sweeping_count'] ?? 0,
    );
  }
}
