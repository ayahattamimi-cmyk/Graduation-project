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

  factory ContentModel.fromJson(Map<String, dynamic> json) {
    return ContentModel(
      id: json['id'],
      title: json['title'] ?? '',
      content: json['content'] ?? '',
      type: json['type'] == 'news' ? ContentType.news : ContentType.tips,
      image: json['image'],
      category: json['category'],
      publishDate: json['publish_date'],
      adminName: json['admin_name'],
      isPublished: json['is_active'].toString() == "1" || json['is_active'] == true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'content': content,
      'type': type == ContentType.news ? 'news' : 'tips',
      'is_active': isPublished ? 1 : 0,
    };
  }
}
