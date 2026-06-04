///   يعمل كحلقة وصل بين [ContentService] (الشبكة) وبين الـ ViewModel.
///   يستقبل البيانات الخام من الـ API، ويحولها إلى كائنات [ContentModel]
///   و[ContentStatsModel] جاهزة للاستخدام في واجهة المستخدم.
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

  Future<void> createContent(ContentModel content, {dynamic imageFile}) async =>
      await _service.addContent(content, imageFile: imageFile);

  Future<void> deleteContent(int id) async => await _service.deleteContent(id);

  Future<void> updateContent(ContentModel content, {dynamic imageFile}) async =>
      await _service.updateContent(content, imageFile: imageFile);

  Future<void> toggleStatus(int id, bool currentStatus) async =>
      await _service.toggleStatus(id, currentStatus);

  Future<ContentStatsModel> getStats() async {
    try {
      final ContentStatsModel stats = await _service.fetchStats();
      return stats;
    } catch (e) {
      return ContentStatsModel.empty();
    }
  }
}
