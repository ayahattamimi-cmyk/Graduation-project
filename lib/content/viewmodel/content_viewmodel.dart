import 'package:flutter/material.dart';
import 'package:web2/content/data/content_repository.dart';
import 'package:web2/content/data/models/content_stats_model.dart';
import '../data/models/content_model.dart';

class NewsTipsViewModel extends ChangeNotifier {
  final NewsRepository _repository;

  /// ينشئ [NewsTipsViewModel] مع [NewsRepository] المحدد.
  NewsTipsViewModel(this._repository);

  List<ContentModel> contents = [];
  ContentStatsModel stats = ContentStatsModel.empty();
  bool isLoading = false;

  /// يحمّل قائمة المحتوى والإحصائيات بالتوازي.
  Future<void> loadData() async {
    isLoading = true;
    notifyListeners();

    try {
      await Future.wait([
        _repository.getAllContent().then((value) {
          contents = value;
        }),
        _repository.getStats().then((value) {
          stats = value;
        }),
      ]);
    } catch (e) {
      // التعامل مع الخطأ بصمت
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  /// يضيف محتوى جديداً مع إمكانية إضافة ملف صورة، ثم يحدّث البيانات.
  Future<void> addContent(ContentModel content, {dynamic imageFile}) async {
    try {
      await _repository.createContent(content, imageFile: imageFile);
      await loadData();
    } catch (e) {
      rethrow;
    }
  }

  /// يحذف عنصر محتوى بواسطة المعرف، ثم يحدّث البيانات.
  Future<void> deleteContent(int id) async {
    try {
      await _repository.deleteContent(id);
      await loadData();
    } catch (e) {
      rethrow;
    }
  }

  /// يعدّل عنصر محتوى موجود مع إمكانية إضافة صورة، ثم يحدّث البيانات.
  Future<void> editContent(ContentModel updated, {dynamic imageFile}) async {
    try {
      await _repository.updateContent(updated, imageFile: imageFile);
      await loadData();
    } catch (e) {
      rethrow;
    }
  }

  /// يبدّل حالة النشر لعنصر محتوى، ثم يحدّث البيانات.
  Future<void> togglePublish(int id, bool currentStatus) async {
    try {
      await _repository.toggleStatus(id, currentStatus);
      await loadData();
    } catch (e) {
      // التعامل مع الخطأ بصمت
    }
  }

  /// عدد النصائح من الإحصائيات.
  int get tipsCount => stats.tipsCount;

  /// عدد الأخبار من الإحصائيات.
  int get newsCount => stats.newsCount;

  /// العدد الإجمالي للمحتوى من الإحصائيات.
  int get totalCount => stats.totalContent;
}
