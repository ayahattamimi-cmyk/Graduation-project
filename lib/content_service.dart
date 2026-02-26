import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/content_model.dart';

class ContentService {

  Future<List<ContentModel>> fetchContents() async {
    final prefs = await SharedPreferences.getInstance();
    final dataString = prefs.getString('contents');

    if (dataString != null) {
      final List decoded = jsonDecode(dataString);
      return decoded.map((e) => ContentModel.fromJson(e)).toList();
    }

    return [];
  }

  Future<void> addContent(ContentModel content) async {
    final contents = await fetchContents();
    contents.add(content);
    await _save(contents);
  }

  Future<void> deleteContent(String id) async {
    final contents = await fetchContents();
    contents.removeWhere((e) => e.id == id);
    await _save(contents);
  }

  Future<void> updateContent(ContentModel updated) async {
    final contents = await fetchContents();
    final index = contents.indexWhere((e) => e.id == updated.id);

    if (index != -1) {
      contents[index] = updated;
    }

    await _save(contents);
  }

  Future<void> togglePublish(ContentModel content) async {
    final contents = await fetchContents();
    final index = contents.indexWhere((e) => e.id == content.id);

    if (index != -1) {
      contents[index] =
          content.copyWith(isPublished: !content.isPublished);
    }

    await _save(contents);
  }

  Future<void> _save(List<ContentModel> contents) async {
    final prefs = await SharedPreferences.getInstance();
    final data = contents.map((e) => e.toJson()).toList();
    await prefs.setString('contents', jsonEncode(data));
  }
}
