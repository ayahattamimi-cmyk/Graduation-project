class NotificationModel {
  final String id;
  final String type;
  final String title;
  final int reportId;
  final bool isRead;
  final String createdAt;
  final String reportType;
  final String priority;
  final String status;
  final String image;

  NotificationModel({
    required this.id,
    required this.type,
    required this.title,
    required this.reportId,
    required this.isRead,
    required this.createdAt,
    required this.reportType,
    required this.priority,
    required this.status,
    required this.image,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'] ?? '',
      type: json['type'] ?? '',
      title: json['title'] ?? '',
      reportId:
          json['report_id'] is int
              ? json['report_id']
              : int.tryParse(json['report_id'].toString()) ??
                  0, // تحويل الرقم لنص للامان
      createdAt: json['created_at'] ?? '', // السيرفر يرسل "5 days ago"
      reportType: json['report_type'] ?? '', // تأكدي من هذا الاسم
      priority: json['priority'] ?? '',
      status: json['status'] ?? '',
      image: _formatImageUrl(json['image'] ?? json['image_url']),
      isRead: json['is_read'] ?? false,
    );
  }

  static String _formatImageUrl(dynamic path) {
    if (path == null || path.toString().isEmpty) return "";
    String url = path.toString();
    if (url.startsWith('http')) return url;
    
    while (url.startsWith('/')) {
      url = url.substring(1);
    }
    
    String baseUrl = "https://medicalhouse-ye.net";
    
    if (url.startsWith('public/')) {
      url = url.replaceFirst('public/', '');
    }

    if (!url.startsWith('storage/')) {
      url = "storage/$url";
    }
    return "$baseUrl/$url";
  }
}
