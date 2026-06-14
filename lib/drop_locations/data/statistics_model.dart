class StatisticsModel {
  final int totalContent;
  final int dynamicCount;
  final int staticCount;

  /// ينشئ [StatisticsModel] بالأعداد المحددة.
  StatisticsModel({
    required this.totalContent,
    required this.dynamicCount,
    required this.staticCount,
  });

  /// ينشئ [StatisticsModel] من خريطة JSON.
  factory StatisticsModel.fromJson(Map<String, dynamic> json) {
    return StatisticsModel(
      totalContent: json['total_content'] ?? 0,
      dynamicCount: json['dynamic_count'] ?? 0,
      staticCount: json['static_count'] ?? 0,
    );
  }
}
