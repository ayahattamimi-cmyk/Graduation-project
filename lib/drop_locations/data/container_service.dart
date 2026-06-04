import 'package:dio/dio.dart';
import '../../core/network/api_service.dart';

class ContainerService {
  final ApiService _apiService;
  ContainerService(this._apiService);

  // جلب كل الحاويات (المفرزة كمربعات من السيرفر)
  Future<Response> getAllContainers() async =>
      await _apiService.get('showAllContainers');

  // إضافة حاوية جديدة باستخدام FormData
  Future<Response> createContainer(Map<String, dynamic> data) async {
    final formData = FormData.fromMap(data);
    return await _apiService.post('createContainer', data: formData);
  }

  // تحديث حاوية موجودة باستخدام FormData و POST حسب التوثيق
  Future<Response> updateContainer(int id, Map<String, dynamic> data) async {
    final formData = FormData.fromMap(data);
    return await _apiService.post('updateContainer/$id', data: formData);
  }

  // حذف حاوية
  Future<Response> deleteContainer(int id) async =>
      await _apiService.delete('destroyContainer/$id');

  // جلب الإحصائيات
  Future<Response> getStatistics() async =>
      await _apiService.get('ContainersStatistics');
}
