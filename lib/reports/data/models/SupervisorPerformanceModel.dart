class SupervisorPerformanceModel {
  final int id;
  final String name;
  final String type;
  final int receivedCount;
  final int completedCount;
  final String completionRate;
  final num avgResponseTime;
  final num avgProcessingTime;

  SupervisorPerformanceModel({
    required this.id,
    required this.name,
    required this.type,
    required this.receivedCount,
    required this.completedCount,
    required this.completionRate,
    required this.avgResponseTime,
    required this.avgProcessingTime,
  });

  factory SupervisorPerformanceModel.fromJson(Map<String, dynamic> json) {
    return SupervisorPerformanceModel(
      id: _parseInt(json['supervisor_id']),
      name: json['name']?.toString() ?? '',
      type: json['type']?.toString() ?? '',
      receivedCount: _parseInt(json['received_count']),
      completedCount: _parseInt(json['completed_count']),
      completionRate: json['completion_rate']?.toString() ?? '0%',
      avgResponseTime: _parseNum(json['avg_response_time_min']),
      avgProcessingTime: _parseNum(json['avg_processing_time_min']),
    );
  }

  static int _parseInt(dynamic v) {
    if (v == null) return 0;
    if (v is int) return v;
    return int.tryParse(v.toString()) ?? 0;
  }

  static num _parseNum(dynamic v) {
    if (v == null) return 0;
    if (v is num) return v;
    return num.tryParse(v.toString()) ?? 0;
  }
}
