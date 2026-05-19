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

    // الدخول إلى حقل 'data' الموجود في JSON الـ Postman
    List data = response.data['data'];

    // تحويل كل عنصر في القائمة إلى AreaModel
    return data.map((json) => AreaModel.fromJson(json)).toList();
  }

  /// جلب الإحصائيات للكروت العلوية
  Future<StatisticsModel> fetchStatistics() async {
    final response = await _service.getStatistics();
    return StatisticsModel.fromJson(response.data['data']);
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
