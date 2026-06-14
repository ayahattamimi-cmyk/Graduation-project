/// يعمل كوسيط بين [ContainerService] وبقية التطبيق،
/// ويتولى تحويل بيانات المناطق والحاويات والإحصائيات.

import 'package:flutter/foundation.dart';
import 'area_model.dart';
import 'container_model.dart';
import 'container_service.dart';
import 'statistics_model.dart';

class ContainerRepository {
  final ContainerService _service;

  /// ينشئ [ContainerRepository] مع [ContainerService] المحدد.
  ContainerRepository(this._service);

  /// يجلب جميع المناطق مع حاوياتها.
  Future<List<AreaModel>> fetchAreasWithContainers() async {
    final response = await _service.getAllContainers();

    List data;
    if (response.data is List) {
      data = response.data;
    } else if (response.data is Map && response.data['data'] != null) {
      data = response.data['data'];
    } else {
      throw Exception("هيكل الاستجابة غير متوقع من السيرفر");
    }

    return data.map((json) => AreaModel.fromJson(json)).toList();
  }

  /// يجلب بيانات الإحصائيات لبطاقات الرأس.
  Future<StatisticsModel> fetchStatistics() async {
    final response = await _service.getStatistics();

    Map<String, dynamic> statsData;
    if (response.data is Map && response.data['data'] != null) {
      statsData = response.data['data'];
    } else if (response.data is Map) {
      statsData = response.data;
    } else {
      throw Exception("هيكل استجابة الإحصائيات غير متوقع");
    }

    return StatisticsModel.fromJson(statsData);
  }

  /// يضيف حاوية جديدة عبر الخدمة.
  Future<void> addContainer(ContainerModel container) async {
    await _service.createContainer(container.toJson());
  }

  /// يزيل حاوية بواسطة [id].
  Future<void> removeContainer(int id) async {
    await _service.deleteContainer(id);
  }

  /// يحدّث حاوية موجودة محددة بـ [id] ببيانات جديدة.
  Future<void> updateContainer(int id, ContainerModel container) async {
    await _service.updateContainer(id, container.toJson());
  }
}
