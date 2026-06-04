///   يحمل كافة تفاصيل بلاغ بيئي بعينه، يتضمن بيانات
///   المبلّغ والموقع والصور وتاريخ الإنشاء.
///   يتضمن [ReporterModel] ككائن فرعي يمثّل بيانات صاحب البلاغ.
import 'reporter_model.dart'; // استيراد مودل المبلّغ

class ReportDetailsModel {
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
  final ReporterModel reporter; // ربط المودلين ببعض
  final String? cancelReason;
  final bool isPublished;

  ReportDetailsModel({
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

  factory ReportDetailsModel.fromJson(Map<String, dynamic> json) {
    return ReportDetailsModel(
      reportNumber: _parseInt(
        json['report_number'] ?? json['id'],
      ), // fallback to id if report_number is missing
      description: json['description'] ?? "",
      status: json['status'] ?? "",
      priority: json['priority'] ?? "",
      type:
          json['type'] ?? json['report_type'] ?? "", // fallback to report_type
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
              ), // fallback to citizen_name
      cancelReason: json['cancel_reason'] ?? json['reason'],
      isPublished:
          _parseInt(
            json['is_published'] ?? json['is_publish'] ?? json['isPublished'],
          ) ==
          1,
    );
  }

  static int _parseInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is double) return value.toInt();
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

    // إذا كان الرابط يبدأ بـ uploads أو storage، ندمجه مباشرة مع الـ baseUrl
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
