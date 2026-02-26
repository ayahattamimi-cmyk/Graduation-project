import 'dart:convert';

enum ContentType { news, tip }

class ContentModel {
  final String id;
  final String title;
  final String description;
  final ContentType type;
  final String? imageBase64;
  final DateTime date;
  final bool isPublished;
  final String? tipCategory;
  final String authorName;

  ContentModel({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    this.imageBase64,
    required this.date,
    required this.isPublished,
    this.tipCategory,
    required this.authorName,
  });

  ContentModel copyWith({
    String? title,
    String? description,
    bool? isPublished,
  }) {
    return ContentModel(
      id: id,
      title: title ?? this.title,
      description: description ?? this.description,
      type: type,
      imageBase64: imageBase64,
      date: date,
      isPublished: isPublished ?? this.isPublished,
      tipCategory: tipCategory,
      authorName: authorName,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'type': type.index,
      'imageBase64': imageBase64,
      'date': date.toIso8601String(),
      'isPublished': isPublished,
      'tipCategory': tipCategory,
      'authorName': authorName,
    };
  }

  factory ContentModel.fromJson(Map<String, dynamic> json) {
    return ContentModel(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      type: ContentType.values[json['type']],
      imageBase64: json['imageBase64'],
      date: DateTime.parse(json['date']),
      isPublished: json['isPublished'],
      tipCategory: json['tipCategory'],
      authorName: json['authorName'],
    );
  }
}
