import 'package:flutter/foundation.dart';
import 'area_model.dart'; // تأكدي من صحة المسارات لديكِ
import 'container_model.dart';
import 'container_service.dart';
import 'statistics_model.dart';

class ContainerRepository {
  final ContainerService _service;
  ContainerRepository(this._service);

  /// جلب المربعات مع حاوياتها (الهيكل الهرمي)
  Future<List<AreaModel>> fetchAreasWithContainers() async {
    final response = await _service.getAllContainers();

    debugPrint("📦 [ContainerRepo] Response status: ${response.statusCode}");
    debugPrint(
      "📦 [ContainerRepo] Response type: ${response.data.runtimeType}",
    );
    debugPrint("📦 [ContainerRepo] Response data: ${response.data}");

    // التعامل مع أشكال الاستجابة المختلفة
    List data;
    if (response.data is List) {
      // إذا كانت الاستجابة قائمة مباشرة
      data = response.data;
    } else if (response.data is Map && response.data['data'] != null) {
      // إذا كانت الاستجابة مغلفة في حقل 'data'
      data = response.data['data'];
    } else {
      debugPrint(
        "❌ [ContainerRepo] Unexpected response structure: ${response.data}",
      );
      throw Exception("هيكل الاستجابة غير متوقع من السيرفر");
    }

    debugPrint("✅ [ContainerRepo] Parsed ${data.length} areas");

    // تحويل كل عنصر في القائمة إلى AreaModel
    return data.map((json) => AreaModel.fromJson(json)).toList();
  }

  /// جلب الإحصائيات للكروت العلوية
  Future<StatisticsModel> fetchStatistics() async {
    final response = await _service.getStatistics();

    debugPrint("📊 [ContainerRepo] Statistics response: ${response.data}");

    // التعامل مع أشكال الاستجابة المختلفة
    Map<String, dynamic> statsData;
    if (response.data is Map && response.data['data'] != null) {
      statsData = response.data['data'];
    } else if (response.data is Map) {
      statsData = response.data;
    } else {
      debugPrint(
        "❌ [ContainerRepo] Unexpected statistics structure: ${response.data}",
      );
      throw Exception("هيكل استجابة الإحصائيات غير متوقع");
    }

    return StatisticsModel.fromJson(statsData);
  }

  // --- أضفتُ لكِ هذه الدالة المفقودة لربط عملية الإضافة بالسيرفر ---
  Future<void> addContainer(ContainerModel container) async {
    await _service.createContainer(container.toJson());
  }

  /// حذف حاوية عبر المعرف
  Future<void> removeContainer(int id) async {
    await _service.deleteContainer(id);
  }

  Future<void> updateContainer(int id, ContainerModel container) async {
    await _service.updateContainer(id, container.toJson());
  }
}
