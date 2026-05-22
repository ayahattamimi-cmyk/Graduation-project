class ContentStatsModel {
  final int totalContent;
  final int newsCount;
  final int tipsCount;
  final int publishCount;

  ContentStatsModel({
    required this.totalContent,
    required this.newsCount,
    required this.tipsCount,
    required this.publishCount,
  });

  // مصنع (Factory) لتحويل الـ JSON القادم من السيرفر إلى كائن فلاتر
  factory ContentStatsModel.fromJson(Map<String, dynamic> json) {
    return ContentStatsModel(
      totalContent: _parseInt(json['total_content']),
      newsCount: _parseInt(json['news_count']),
      tipsCount: _parseInt(json['tips_count']),
      publishCount: _parseInt(json['publish_count']),
    );
  }

  static int _parseInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is double) return value.toInt();
    return int.tryParse(value.toString()) ?? 0;
  }

  // كائن افتراضي فارغ لاستخدامه قبل اكتمال التحميل من السيرفر
  factory ContentStatsModel.empty() {
    return ContentStatsModel(
      totalContent: 0,
      newsCount: 0,
      tipsCount: 0,
      publishCount: 0,
    );
  }
}
