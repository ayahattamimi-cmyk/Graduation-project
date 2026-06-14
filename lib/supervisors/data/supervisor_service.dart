import '../../core/network/api_service.dart';

class SupervisorService {
  final ApiService _apiService;

  SupervisorService(this._apiService);

  /// يجلب جميع المشرفين.
  Future<dynamic> getAllSupervisors() async {
    return await _apiService.get('showSupervisors');
  }

  /// يجلب المناطق حسب النوع (رفع أو كنس).
  Future<dynamic> getAreas(String type) async {
    return await _apiService.get('showAreas/$type');
  }

  /// يحدث بيانات مشرف حسب المعرف.
  Future<dynamic> updateSupervisor(int id, dynamic data) async {
    return await _apiService.post('updateSupervisors/$id', data: data);
  }

  /// يجلب إحصائيات المشرفين.
  Future<dynamic> getStatistics() async {
    return await _apiService.get('SupervisorsStatistics');
  }

  /// يجلب مشرفي الرفع.
  Future<dynamic> getLiftingSupervisors() async {
    return await _apiService.get('getLiftingSupervisors');
  }

  /// يجلب مشرفي الكنس.
  Future<dynamic> getSweepingSupervisors() async {
    return await _apiService.get('getSweepingSupervisors');
  }

  /// يضيف مشرفاً جديداً.
  Future<dynamic> addSupervisor(Map<String, dynamic> data) async {
    return await _apiService.post('addSupervisors', data: data);
  }

  /// الخطوة 1: ينشئ مستخدماً عبر نقطة نهاية تسجيل الدخول.
  Future<dynamic> createUser(
    dynamic data, {
    Map<String, dynamic>? headers,
    Map<String, dynamic>? extra,
  }) async {
    return await _apiService.post(
      'login',
      data: data,
      headers: headers,
      extra: extra,
    );
  }

  /// الخطوة 2: يُدرج معلومات المشرف (المنطقة والنوع).
  Future<dynamic> insertInformationUser(
    dynamic data, {
    Map<String, dynamic>? headers,
    Map<String, dynamic>? extra,
  }) async {
    return await _apiService.post(
      'insertInformationUser',
      data: data,
      headers: headers,
      extra: extra,
    );
  }

  /// يجلب تقرير أداء المشرف.
  Future<dynamic> getSupervisorPerformanceReport(dynamic data) async {
    return await _apiService.post('supervisor-report', data: data);
  }
}
