import '../../core/network/api_service.dart';

class DashboardService {
  final ApiService _apiService;

  /// ينشئ [DashboardService] مع [ApiService] المحدد.
  DashboardService(this._apiService);

  /// يجلب بيانات لوحة التحكم الخام من نقطة نهاية API.
  Future<dynamic> getDashboardData() async {
    return await _apiService.get('admin/dashboard-stats');
  }
}
