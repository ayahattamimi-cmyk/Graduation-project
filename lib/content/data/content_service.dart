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

  /// إضافة محتوى
  Future<void> addContent(ContentModel content) async {
    await _apiService.post('addNewTip', data: content.toJson());
  }

  /// حذف محتوى
  Future<void> deleteContent(int id) async {
    await _apiService.delete('DestroyTip/$id');
  }

  /// تحديث محتوى
  Future<void> updateContent(ContentModel content) async {
    await _apiService.post('UpdateTip/${content.id}', data: content.toJson());
  }

  /// تغيير حالة النشر
  Future<void> toggleStatus(int id) async {
    await _apiService.put('TipStatusPublish/$id');
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
