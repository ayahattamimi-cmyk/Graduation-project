class SupervisorPerformanceModel {
  final int id;
  final String name;
  final String type;
  final int receivedCount;
  final int completedCount;
  final String completionRate;
  final int avgResponseTime;
  final int avgProcessingTime;

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
      id: json['supervisor_id'] ?? 0,
      name: json['name'] ?? '',
      type: json['type'] ?? '',
      receivedCount: json['received_count'] ?? 0,
      completedCount: json['completed_count'] ?? 0,
      completionRate: json['completion_rate'] ?? '0%',
      avgResponseTime: json['avg_response_time_min'] ?? 0,
      avgProcessingTime: json['avg_processing_time_min'] ?? 0,
    );
  }
}
