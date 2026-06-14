import 'package:dio/dio.dart';
import '../../core/network/api_service.dart';

class ContainerService {
  final ApiService _apiService;

  /// ينشئ [ContainerService] مع [ApiService] المحدد.
  ContainerService(this._apiService);

  /// يجلب جميع الحاويات (مجمّعة كمناطق من الخادم).
  Future<Response> getAllContainers() async =>
      await _apiService.get('showAllContainers');

  /// ينشئ حاوية جديدة باستخدام FormData.
  Future<Response> createContainer(Map<String, dynamic> data) async {
    final formData = FormData.fromMap(data);
    return await _apiService.post('createContainer', data: formData);
  }

  /// يحدّث حاوية موجودة باستخدام FormData.
  Future<Response> updateContainer(int id, Map<String, dynamic> data) async {
    final formData = FormData.fromMap(data);
    return await _apiService.post('updateContainer/$id', data: formData);
  }

  /// يحذف حاوية بواسطة [id].
  Future<Response> deleteContainer(int id) async =>
      await _apiService.delete('destroyContainer/$id');

  /// يجلب إحصائيات الحاويات.
  Future<Response> getStatistics() async =>
      await _apiService.get('ContainersStatistics');
}
