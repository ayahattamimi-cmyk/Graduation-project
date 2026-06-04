/// ============================================================
/// 📁 dashboard_service.dart — خدمة الشبكة (API Service)
/// ============================================================
/// المسؤولية:
///   يتولى التواصل المباشر مع نقطة النهاية والجلب الأولي لبيانات
///   لوحة التحكم عبر [ApiService].
///
/// العمليات:
///   - fetchDashboardData() : جلب بيانات اللوحة (GET)
/// ============================================================
import '../../core/network/api_service.dart';

class DashboardService {
  final ApiService _apiService;
  DashboardService(this._apiService);

  Future<dynamic> getDashboardData() async {
    return await _apiService.get('admin/dashboard-stats');
  }
}
