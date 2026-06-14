import 'dart:convert';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:web2/content/data/models/content_stats_model.dart';
import 'package:web2/core/network/api_service.dart';
import 'models/content_model.dart';

class ContentService {
  final ApiService _apiService;

  /// ينشئ [ContentService] مع [ApiService] المحدد.
  ContentService(this._apiService);

  /// يجلب قائمة عناصر المحتوى (أخبار/نصائح) من API.
  Future<List<ContentModel>> fetchContents() async {
    try {
      final response = await _apiService.get('ShowTip');

      if (response.statusCode == 200 && response.data != null) {
        final List data = response.data['data'] ?? [];
        return data.map((json) => ContentModel.fromJson(json)).toList();
      }
    } catch (e) {
      // إرجاع قائمة فارغة بصمت عند الفشل
    }
    return [];
  }

  /// يضيف محتوى جديداً مع دعم اختياري للصورة.
  Future<void> addContent(ContentModel content, {dynamic imageFile}) async {
    final Map<String, dynamic> data = content.toJson();

    if (data['image'] != null &&
        data['image'] is String &&
        (data['image'] as String).length > 200) {
      final String base64Str = data['image'];
      final Uint8List bytes = base64Decode(base64Str);
      data['image'] = MultipartFile.fromBytes(
        bytes,
        filename: 'upload_${DateTime.now().millisecondsSinceEpoch}.jpg',
      );
    }

    if (imageFile != null) {
      data['image'] = imageFile;
    }

    final formData = FormData.fromMap(data);
    await _apiService.post('addNewTip', data: formData);
  }

  /// يحذف عنصر محتوى بواسطة معرفه.
  Future<void> deleteContent(int id) async {
    await _apiService.delete('DestroyTip/$id');
  }

  /// يحدّث عنصر محتوى موجود، مع إمكانية إضافة صورة جديدة.
  Future<void> updateContent(ContentModel content, {dynamic imageFile}) async {
    final Map<String, dynamic> data = content.toJson();

    if (data['image'] != null &&
        data['image'] is String &&
        (data['image'] as String).length > 200) {
      final String base64Str = data['image'];
      final Uint8List bytes = base64Decode(base64Str);
      data['image'] = MultipartFile.fromBytes(
        bytes,
        filename: 'update_${DateTime.now().millisecondsSinceEpoch}.jpg',
      );
    }

    if (imageFile != null) {
      data['image'] = imageFile;
    }

    final formData = FormData.fromMap(data);
    await _apiService.post('UpdateTip/${content.id}', data: formData);
  }

  /// يبدّل حالة النشر/إلغاء النشر لعنصر محتوى.
  Future<void> toggleStatus(int id, bool currentStatus) async {
    final formData = FormData.fromMap({'is_active': currentStatus ? 0 : 1});
    await _apiService.patch('TipStatusPublish/$id', data: formData);
  }

  /// يجلب إحصائيات المحتوى من API.
  Future<ContentStatsModel> fetchStats() async {
    try {
      final response = await _apiService.get('EnvironmentalStatistics');

      if (response.statusCode == 200 && response.data != null) {
        final data = response.data;
        if (data['status'] == 'success' && data['data'] != null) {
          final Map<String, dynamic> statsData = data['data'];
          return ContentStatsModel.fromJson(statsData);
        }
      }
    } catch (e) {
      // إرجاع إحصائيات فارغة عند الفشل
    }

    return ContentStatsModel.empty();
  }
}
