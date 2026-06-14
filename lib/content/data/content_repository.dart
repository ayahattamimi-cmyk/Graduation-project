import 'package:web2/content/data/models/content_stats_model.dart';

import 'models/content_model.dart';
import 'content_service.dart';

class NewsRepository {
  final ContentService _service;

  /// ينشئ [NewsRepository] مع [ContentService] المحدد.
  NewsRepository(this._service);

  /// يجلب جميع عناصر المحتوى من API.
  Future<List<ContentModel>> getAllContent() async {
    try {
      return await _service.fetchContents();
    } catch (e) {
      throw Exception("خطأ في جلب البيانات من المستودع: $e");
    }
  }

  /// ينشئ محتوى جديداً، مع إمكانية إضافة ملف صورة.
  Future<void> createContent(ContentModel content, {dynamic imageFile}) async =>
      await _service.addContent(content, imageFile: imageFile);

  /// يحذف عنصر محتوى بواسطة معرفه.
  Future<void> deleteContent(int id) async => await _service.deleteContent(id);

  /// يحدّث عنصر محتوى موجود، مع إمكانية إضافة ملف صورة جديد.
  Future<void> updateContent(ContentModel content, {dynamic imageFile}) async =>
      await _service.updateContent(content, imageFile: imageFile);

  /// يبدّل حالة النشر/إلغاء النشر لعنصر محتوى.
  Future<void> toggleStatus(int id, bool currentStatus) async =>
      await _service.toggleStatus(id, currentStatus);

  /// يجلب إحصائيات المحتوى من API.
  Future<ContentStatsModel> getStats() async {
    try {
      final ContentStatsModel stats = await _service.fetchStats();
      return stats;
    } catch (e) {
      return ContentStatsModel.empty();
    }
  }
}
