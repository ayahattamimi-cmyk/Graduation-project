import 'reporter_model.dart';

/// يحمل التفاصيل الكاملة لبلاغ بيئي واحد،
/// بما في ذلك معلومات المبلّغ والموقع والصور والطوابع الزمنية.
class ReportDetailsModel {
  final int id;
  final int reportNumber;
  final String description;
  final String status;
  final String priority;
  final String type;
  final String title;
  final String createdAt;
  final String createdTime;
  final String imageUrl;
  final String area;
  final String square;
  final ReporterModel reporter;
  final String? cancelReason;
  final bool isPublished;

  ReportDetailsModel({
    required this.id,
    required this.reportNumber,
    required this.description,
    required this.status,
    required this.priority,
    required this.type,
    required this.title,
    required this.createdAt,
    required this.createdTime,
    required this.imageUrl,
    required this.area,
    required this.square,
    required this.reporter,
    this.cancelReason,
    this.isPublished = false,
  });

  /// يُرجع نسخة مع قيمة [isPublished] محدّثة اختيارياً.
  ReportDetailsModel copyWith({bool? isPublished}) {
    return ReportDetailsModel(
      id: id,
      reportNumber: reportNumber,
      description: description,
      status: status,
      priority: priority,
      type: type,
      title: title,
      createdAt: createdAt,
      createdTime: createdTime,
      imageUrl: imageUrl,
      area: area,
      square: square,
      reporter: reporter,
      cancelReason: cancelReason,
      isPublished: isPublished ?? this.isPublished,
    );
  }

  /// ينشيء [ReportDetailsModel] من خريطة JSON مع سلاسل احتياطية.
  factory ReportDetailsModel.fromJson(Map<String, dynamic> json) {
    return ReportDetailsModel(
      id: _parseInt(json['id'] ?? json['report_id'] ?? json['report_number']),
      reportNumber: _parseInt(
        json['report_number'] ?? json['id'] ?? json['report_id'],
      ),
      description: json['description'] ?? "",
      status: json['status'] ?? "",
      priority: json['priority'] ?? "",
      type: json['type'] ?? json['report_type'] ?? "",
      title: json['title'] ?? "",
      createdAt: json['created_at'] ?? "",
      createdTime: json['created_time'] ?? "",
      imageUrl: _formatImageUrl(json['image_url'] ?? json['image']),
      area:
          json['location']?['area'] ??
          json['area_name'] ??
          json['area'] ??
          "غير محدد",
      square:
          json['location']?['square'] ??
          json['square_name'] ??
          json['square'] ??
          "غير محدد",
      reporter:
          json['reporter'] != null
              ? ReporterModel.fromJson(json['reporter'])
              : ReporterModel(
                name: json['citizen_name'] ?? "غير معروف",
                phone: "غير متوفر",
              ),
      cancelReason: json['cancel_reason'] ?? json['reason'],
      isPublished: _parseBool(
        json['is_published'] ?? json['is_publish'] ?? json['isPublished'],
      ),
    );
  }

  /// يحلل قيمة منطقية (Boolean) بأمان من أنواع مختلفة.
  static bool _parseBool(dynamic value) {
    if (value == null) return false;
    if (value is bool) return value;
    if (value is int) return value == 1;
    if (value is double) return value.toInt() == 1;
    final str = value.toString().toLowerCase();
    return str == '1' || str == 'true';
  }

  /// يحلل عدداً صحيحاً من قيمة ديناميكية بأمان.
  static int _parseInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is double) return value.toInt();
    return int.tryParse(value.toString()) ?? 0;
  }

  /// ينسّق رابط الصورة، مع تمريرها عبر weserv لـ HTTPS إذا لزم الأمر.
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

    if (url.startsWith('uploads/') || url.startsWith('storage/')) {
      return "https://images.weserv.nl/?url=$baseUrl/$url";
    }

    if (url.startsWith('public/')) {
      url = url.replaceFirst('public/', '');
    }

    String finalUrl = "";
    if (!url.contains('/')) {
      finalUrl = "$baseUrl/storage/$url";
    } else {
      finalUrl = "$baseUrl/$url";
    }

    return "https://images.weserv.nl/?url=$finalUrl";
  }
}
