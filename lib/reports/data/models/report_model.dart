class ReportModel {
  final int id;
  final String title;
  final String description;
  final String image;
  final String status;
  final String reportType;
  final String priority;
  final String citizenName;
  final String areaName;
  final String createdAt;

  ReportModel({
    required this.id,
    required this.title,
    required this.description,
    required this.image,
    required this.status,
    required this.reportType,
    required this.priority,
    required this.citizenName,
    required this.areaName,
    required this.createdAt,
  });

  factory ReportModel.fromJson(Map<String, dynamic> json) {
    return ReportModel(
      id: json['id'],
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      image: json['image'] ?? '',
      status: json['status'] ?? '',
      reportType: json['report_type'] ?? '',
      priority: json['priority'] ?? '',
      citizenName: json['citizen_name'] ?? 'مواطن',
      areaName: json['area_name'] ?? 'غير محدد',
      createdAt: json['created_at'] ?? '',
    );
  }
}
