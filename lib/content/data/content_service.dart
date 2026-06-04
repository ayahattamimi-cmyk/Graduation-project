/// ============================================================
/// 📁 content_service.dart — طبقة الشبكة (Network Layer)
/// ============================================================
/// المسؤولية:
///   يتعامل مباشرةً مع الـ API لتنفيذ عمليات المحتوى البيئي
///   (الأخبار والنصائح). يستخدم مكتبة Dio لإرسال الطلبات.
///
/// العمليات المدعومة:
///   - جلب قائمة المحتوى (GET)
///   - إضافة محتوى جديد (POST - FormData)
///   - تعديل محتوى (POST - FormData)
///   - تفعيل/تعطيل محتوى (POST)
///   - جلب إحصائيات المحتوى
/// ============================================================
import 'dart:convert';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:web2/content/data/models/content_stats_model.dart';
import 'package:web2/core/network/api_service.dart';
import 'models/content_model.dart';

class ContentService {
  final ApiService _apiService;

  ContentService(this._apiService);

  /// جلب الأخبار والنصائح
  Future<List<ContentModel>> fetchContents() async {
    try {
      final response = await _apiService.get('ShowTip');
      debugPrint(
        "📚 [CountStatistics.fetchContents] Status: ${response.statusCode}, Data: ${response.data}",
      );

      if (response.statusCode == 200 && response.data != null) {
        final List data = response.data['data'] ?? [];
        return data.map((json) => ContentModel.fromJson(json)).toList();
      }
    } catch (e) {
      debugPrint("❌ [ContentService.fetchContents] Error: $e");
    }
    return [];
  }

  /// إضافة محتوى جديد (مع دعم الصور)
  Future<void> addContent(ContentModel content, {dynamic imageFile}) async {
    final Map<String, dynamic> data = content.toJson();

    // التعامل مع صورة Base64 إذا وجدت
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
      data['image'] = imageFile; // يفترض أن يكون MultipartFile
    }

    final formData = FormData.fromMap(data);
    await _apiService.post('addNewTip', data: formData);
  }

  /// حذف محتوى
  Future<void> deleteContent(int id) async {
    await _apiService.delete('DestroyTip/$id');
  }

  /// تحديث محتوى موجود
  Future<void> updateContent(ContentModel content, {dynamic imageFile}) async {
    final Map<String, dynamic> data = content.toJson();

    // التعامل مع صورة Base64 إذا وجدت
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

  /// تغيير حالة النشر (نشر / إلغاء نشر)
  Future<void> toggleStatus(int id, bool currentStatus) async {
    final formData = FormData.fromMap({'is_active': currentStatus ? 0 : 1});
    await _apiService.patch('TipStatusPublish/$id', data: formData);
  }

  /// جلب الإحصائيات
  Future<ContentStatsModel> fetchStats() async {
    try {
      final response = await _apiService.get('EnvironmentalStatistics');
      debugPrint(
        "📊 [ContentService.fetchStats] Status: ${response.statusCode}, Data: ${response.data}",
      );

      if (response.statusCode == 200 && response.data != null) {
        final data = response.data;
        if (data['status'] == 'success' && data['data'] != null) {
          final Map<String, dynamic> statsData = data['data'];
          return ContentStatsModel.fromJson(statsData);
        }
      }
    } catch (e) {
      debugPrint("❌ [ContentService.fetchStats] Error: $e");
    }

    return ContentStatsModel.empty();
  }
}
