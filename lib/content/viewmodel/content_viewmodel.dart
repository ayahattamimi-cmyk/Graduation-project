import 'package:flutter/material.dart';
import 'package:web2/content/data/content_repository.dart';
import 'package:web2/content/data/models/content_stats_model.dart';
import '../data/models/content_model.dart';

class NewsTipsViewModel extends ChangeNotifier {
  final NewsRepository _repository;

  NewsTipsViewModel(this._repository);

  List<ContentModel> contents = [];
  ContentStatsModel stats = ContentStatsModel.empty();
  bool isLoading = false;

  Future<void> loadData() async {
    isLoading = true;
    notifyListeners();

    try {
      // تشغيل جلب المحتوى وجلب الإحصائيات بالتوازي
      await Future.wait([
        _repository.getAllContent().then((value) {
          contents = value;
        }),
        _repository.getStats().then((value) {
          stats = value;
        }),
      ]);
    } catch (e) {
      debugPrint("❌ Error loading news/tips data: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // إضافة محتوى جديد مع دعم الصورة
  Future<void> addContent(ContentModel content, {dynamic imageFile}) async {
    try {
      await _repository.createContent(content, imageFile: imageFile);
      await loadData();
    } catch (e) {
      debugPrint("Add Error: $e");
      rethrow;
    }
  }

  Future<void> deleteContent(int id) async {
    try {
      await _repository.deleteContent(id);
      await loadData();
      debugPrint("Delete Success for ID: $id");
    } catch (e) {
      debugPrint("Delete Error for ID $id: $e");
      rethrow;
    }
  }

  // تعديل محتوى مع دعم تحديث الصورة
  Future<void> editContent(ContentModel updated, {dynamic imageFile}) async {
    try {
      await _repository.updateContent(updated, imageFile: imageFile);
      await loadData();
      debugPrint("Edit Success for ID: ${updated.id}");
    } catch (e) {
      debugPrint("Edit Error: $e");
      rethrow;
    }
  }

  // تبديل حالة النشر (Active/Inactive)
  Future<void> togglePublish(int id, bool currentStatus) async {
    try {
      await _repository.toggleStatus(id, currentStatus);
      await loadData();
      debugPrint("Toggle Success for ID: $id");
    } catch (e) {
      debugPrint("Toggle Error for ID $id: $e");
    }
  }

  int get tipsCount => stats.tipsCount;
  int get newsCount => stats.newsCount;
  int get totalCount => stats.totalContent;
}
