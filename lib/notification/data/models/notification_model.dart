///   يمثّل إشعار واحدًا مرتبطًا ببلاغ بيئي، ويحتوي على
///   معلومات الحالة والتوقيت ونوع البلاغ.
class NotificationModel {
  final String id;
  final String title;
  final int reportId;
  final String createdAt;
  final String reportType;
  final String priority;
  final String status;
  final String image;
  final bool isRead;
  final String? supervisor;
  final String? note;
  final bool isPublished;

  NotificationModel({
    required this.id,
    required this.title,
    required this.reportId,
    required this.createdAt,
    required this.reportType,
    required this.priority,
    required this.status,
    required this.image,
    required this.isRead,
    this.isPublished = false,
    this.supervisor,
    this.note,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    // محاولة جلب الحالة الحقيقية للبلاغ من البيانات المتداخلة
    String currentStatus = json['status']?.toString() ?? '';

    // فحص إذا كانت الحالة موجودة داخل حقل report أو data (في إشعارات Laravel)
    if (json['data'] != null &&
        json['data'] is Map &&
        json['data']['status'] != null) {
      currentStatus = json['data']['status'].toString();
    } else if (json['report'] != null &&
        json['report'] is Map &&
        json['report']['status'] != null) {
      currentStatus = json['report']['status'].toString();
    }

    // إذا لم توجد حالة صريحة، نستنتجها من نوع الإشعار (type)
    if (currentStatus.isEmpty) {
      final String type = json['type']?.toString() ?? '';
      if (type == 'report_cancelled') {
        currentStatus = 'ملغي';
      } else if (type == 'new_report') {
        currentStatus = 'قيد الانتظار';
      } else if (type == 'report_completed') {
        currentStatus = 'تم الإنجاز';
      }
    }

    return NotificationModel(
      id: json['id']?.toString() ?? '',
      title: json['title'] ?? '',
      reportId: _parseInt(json['report_id'] ?? json['id']),
      createdAt: json['created_at'] ?? '',
      reportType: json['report_type'] ?? json['type'] ?? "بلاغ",
      priority: json['priority'] ?? 'عادي',
      status: currentStatus,
      image: _formatImageUrl(json['image'] ?? json['image_url']),
      isRead: json['is_read'] ?? false,
      isPublished:
          _parseInt(
            json['is_published'] ?? json['is_publish'] ?? json['isPublished'],
          ) ==
          1,
      supervisor: json['supervisor'],
      note: json['note'],
    );
  }

  static int _parseInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    return int.tryParse(value.toString()) ?? 0;
  }

  static String _formatImageUrl(dynamic path) {
    if (path == null || path.toString().isEmpty) return "";
    String url = path.toString();
    if (url.startsWith('http')) {
      return "https://images.weserv.nl/?url=$url";
    }

    while (url.startsWith('/')) {
      url = url.substring(1);
    }

    String baseUrl = "https://medicalhouse-ye.net";

    String finalUrl = "";
    if (url.startsWith('uploads/') || url.startsWith('storage/')) {
      finalUrl = "$baseUrl/$url";
    } else if (!url.contains('/')) {
      finalUrl = "$baseUrl/storage/$url";
    } else {
      finalUrl = "$baseUrl/$url";
    }

    return "https://images.weserv.nl/?url=$finalUrl";
  }
}
