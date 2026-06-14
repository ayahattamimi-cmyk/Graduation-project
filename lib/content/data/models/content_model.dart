enum ContentType { news, tips }

class ContentModel {
  final int? id;
  final String title;
  final String content;
  final ContentType type;
  final String? image;
  final String? category;
  final String? publishDate;
  final String? adminName;
  final bool isPublished;

  /// ينشئ [ContentModel] يمثل عنصر خبر أو نصيحة.
  ContentModel({
    this.id,
    required this.title,
    required this.content,
    required this.type,
    this.image,
    this.category,
    this.publishDate,
    this.adminName,
    this.isPublished = true,
  });

  /// يعيد نسخة من هذا النموذج مع استبدال الحقول المحددة.
  ContentModel copyWith({
    int? id,
    String? title,
    String? content,
    ContentType? type,
    String? image,
    String? category,
    String? publishDate,
    String? adminName,
    bool? isPublished,
  }) {
    return ContentModel(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      type: type ?? this.type,
      image: image ?? this.image,
      category: category ?? this.category,
      publishDate: publishDate ?? this.publishDate,
      adminName: adminName ?? this.adminName,
      isPublished: isPublished ?? this.isPublished,
    );
  }

  /// ينشئ [ContentModel] من خريطة JSON التي أرجعها API.
  factory ContentModel.fromJson(Map<String, dynamic> json) {
    return ContentModel(
      id: json['id'],
      title: json['title'] ?? '',
      content: json['content'] ?? '',
      type: json['type'] == 'news' ? ContentType.news : ContentType.tips,
      image: _formatImageUrl(json['image']),
      category: json['category'],
      publishDate: json['publish_date'],
      adminName: json['admin_name'],
      isPublished:
          json['is_active'].toString() == "1" || json['is_active'] == true,
    );
  }

  static String _formatImageUrl(dynamic path) {
    if (path == null || path.toString().isEmpty) return "";
    String url = path.toString();
    if (url.startsWith('http')) {
      return "https://images.weserv.nl/?url=$url";
    }

    String baseUrl = "https://medicalhouse-ye.net";

    while (url.startsWith('/')) {
      url = url.substring(1);
    }

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

  /// يحوّل هذا النموذج إلى خريطة JSON لاستخدامها في طلبات API.
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'content': content,
      'type': type == ContentType.news ? 'news' : 'tips',
      'category': category,
      'is_active': isPublished ? 1 : 0,
      'image': image,
    };
  }
}
