class StatisticsModel {
  final int totalContent;
  final int dynamicCount;
  final int staticCount;

  StatisticsModel({
    required this.totalContent,
    required this.dynamicCount,
    required this.staticCount,
  });

  factory StatisticsModel.fromJson(Map<String, dynamic> json) {
    return StatisticsModel(
      totalContent: json['total_content'] ?? 0,
      dynamicCount: json['dynamic_count'] ?? 0,
      staticCount: json['static_count'] ?? 0,
    );
  }
}
