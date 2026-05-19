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
  });

  factory ReportDetailsModel.fromJson(Map<String, dynamic> json) {
    return ReportDetailsModel(
      reportNumber: _parseInt(json['report_number'] ?? json['id']), // fallback to id if report_number is missing
      description: json['description'] ?? "",
      status: json['status'] ?? "",
      priority: json['priority'] ?? "",
      type: json['type'] ?? json['report_type'] ?? "", // fallback to report_type
      title: json['title'] ?? "",
      createdAt: json['created_at'] ?? "",
      createdTime: json['created_time'] ?? "",
      imageUrl: _formatImageUrl(json['image_url'] ?? json['image']),
      area: json['location']?['area'] ?? json['area_name'] ?? json['area'] ?? "غير محدد",
      square: json['location']?['square'] ?? json['square_name'] ?? json['square'] ?? "غير محدد",
      reporter: json['reporter'] != null 
          ? ReporterModel.fromJson(json['reporter']) 
          : ReporterModel(name: json['citizen_name'] ?? "غير معروف", phone: "غير متوفر"), // fallback to citizen_name
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
    if (url.startsWith('http')) return url;
    
    // إزالة السلاش البادئ إذا وجد لتجنب التكرار
    if (url.startsWith('/')) {
      url = url.substring(1);
    }
    
    String baseUrl = "https://medicalhouse-ye.net";
    
    // إذا كان الرابط يحتوي بالفعل على http، نرجعه كما هو
    if (url.startsWith('http')) return url;

    // تنظيف السلاشات الزائدة
    while (url.startsWith('/')) {
      url = url.substring(1);
    }
    
    // إذا كان الرابط يحتوي على public/ في بدايته (خطأ شائع في Laravel)
    if (url.startsWith('public/')) {
      url = url.replaceFirst('public/', '');
    }

    // إذا كان لا يبدأ بـ storage/، نضيفه
    if (!url.startsWith('storage/')) {
      url = "storage/$url";
    }
    
    return "$baseUrl/$url";
  }
}
