import 'package:flutter/material.dart';
import 'package:web2/content/data/content_repository.dart';
import 'package:web2/content/data/models/content_stats_model.dart';
import 'package:web2/core/network/api_service.dart';
import 'package:web2/core/network/dio_client.dart';
import '../data/content_service.dart';
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

    // تشغيل جلب المحتوى وجلب الإحصائيات بالتوازي لمنع تأثر أي منهما بالآخر ولتحميل البيانات بأسرع وقت
    await Future.wait([
      _repository.getAllContent().then((value) {
        contents = value;
      }).catchError((e) {
        debugPrint("❌ Error fetching content list: $e");
      }),
      _repository.getStats().then((value) {
        stats = value;
      }).catchError((e) {
        debugPrint("❌ Error fetching content stats: $e");
      }),
    ]);

    isLoading = false;
    notifyListeners();
  }

  Future<void> addContent(ContentModel content) async {
    try {
      await _repository.createContent(content);
      await loadData();
    } catch (e) {
      debugPrint("Add Error: $e");
    }
  }

  Future<void> deleteContent(int id) async {
    try {
      await _repository.deleteContent(id);
      await loadData();
      debugPrint("Delete Success for ID: $id");
    } catch (e) {
      debugPrint("Delete Error for ID $id: $e");
    }
  }

  Future<void> editContent(ContentModel updated) async {
    try {
      await _repository.updateContent(updated);
      await loadData();
      debugPrint("Edit Success for ID: ${updated.id}");
    } catch (e) {
      debugPrint("Edit Error: $e");
    }
  }

  Future<void> togglePublish(int id) async {
    try {
      await _repository.toggleStatus(id);
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
