import 'dashboard_model.dart';
import 'dashboard_service.dart';

class DashboardRepository {
  final DashboardService _service;
  DashboardRepository(this._service);

  Future<DashboardModel> fetchDashboardStats() async {
    try {
      final response = await _service.getDashboardData();

      // التحقق من حالة الرد
      if (response.data['status'] == 'success') {
        return DashboardModel.fromJson(response.data['data']);
      } else {
        throw Exception(response.data['message'] ?? "حدث خطأ غير معروف");
      }
    } catch (e) {
      print("Error in DashboardRepository: $e");
      rethrow;
    }
  }
}
