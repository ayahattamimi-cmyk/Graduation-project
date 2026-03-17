import 'package:flutter/material.dart';
import '../data/content_service.dart';
import '../view/content_model.dart';

class ContentViewModel extends ChangeNotifier {

  final ContentService _service = ContentService();

  List<ContentModel> contents = [];

  bool isLoading = false;

  Future<void> loadContents() async {
    isLoading = true;
    notifyListeners();

    contents = await _service.fetchContents();

    isLoading = false;
    notifyListeners();
  }

  Future<void> addContent(ContentModel content) async {
    await _service.addContent(content);
    await loadContents();
  }

  Future<void> deleteContent(String id) async {
    await _service.deleteContent(id);
    await loadContents();
  }

  Future<void> editContent(ContentModel updated) async {
    await _service.updateContent(updated);
    await loadContents();
  }

  Future<void> togglePublish(ContentModel content) async {
    await _service.togglePublish(content);
    await loadContents();
  }

  int get tipsCount =>
      contents.where((e) => e.type == ContentType.tip).length;

  int get newsCount =>
      contents.where((e) => e.type == ContentType.news).length;

  int get publishedCount =>
      contents.where((e) => e.isPublished).length;
}