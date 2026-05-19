import 'package:web2/content/data/models/content_stats_model.dart';

import 'models/content_model.dart';
import 'content_service.dart';

class NewsRepository {
  final ContentService _service;

  NewsRepository(this._service);

  Future<List<ContentModel>> getAllContent() async {
    try {
      return await _service.fetchContents();
    } catch (e) {
      throw Exception("خطأ في جلب البيانات من المستودع: $e");
    }
  }

  Future<void> createContent(ContentModel content) async =>
      await _service.addContent(content);

  Future<void> deleteContent(int id) async => await _service.deleteContent(id);

  Future<void> updateContent(ContentModel content) async =>
      await _service.updateContent(content);

  Future<void> toggleStatus(int id) async => await _service.toggleStatus(id);

  Future<ContentStatsModel> getStats() async {
    try {
      final ContentStatsModel stats = await _service.fetchStats();
      return stats;
    } catch (e) {
      return ContentStatsModel.empty();
    }
  }
}
