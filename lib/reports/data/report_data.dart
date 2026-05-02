class ReportData {
  final String id;
  final String date;
  final String area;
  final String type;
  final String status;
  final String supervisor;
  final double duration;

  ReportData({
    required this.id,
    required this.date,
    required this.area,
    required this.type,
    required this.status,
    required this.supervisor,
    required this.duration,
  });

  factory ReportData.fromJson(Map<String, dynamic> json) {
    return ReportData(
      id: json["id"],
      date: json["date"],
      area: json["area"],
      type: json["type"],
      status: json["status"],
      supervisor: json["supervisor"],
      duration: (json["duration"] ?? 0).toDouble(),
    );
  }
}