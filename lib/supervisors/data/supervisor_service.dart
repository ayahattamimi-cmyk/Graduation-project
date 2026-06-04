import '../../core/network/api_service.dart';

class SupervisorService {
  final ApiService _apiService;

  SupervisorService(this._apiService);

  // جلب جميع المشرفين
  Future<dynamic> getAllSupervisors() async {
    return await _apiService.get('showSupervisors');
  }

  // جلب المربعات حسب النوع (كنس أو رفع)
  Future<dynamic> getAreas(String type) async {
    return await _apiService.get('showAreas/$type');
  }

  // تحديث بيانات مشرف معين
  Future<dynamic> updateSupervisor(int id, dynamic data) async {
    return await _apiService.post('updateSupervisors/$id', data: data);
  }

  // جلب الإحصائيات (SupervisorsStatistics)
  Future<dynamic> getStatistics() async {
    return await _apiService.get('SupervisorsStatistics');
  }

  // جلب مشرفي الرفع فقط
  Future<dynamic> getLiftingSupervisors() async {
    return await _apiService.get('getLiftingSupervisors');
  }

  // جلب مشرفي الكنس فقط
  Future<dynamic> getSweepingSupervisors() async {
    return await _apiService.get('getSweepingSupervisors');
  }

  Future<dynamic> addSupervisor(Map<String, dynamic> data) async {
    return await _apiService.post('addSupervisors', data: data);
  }

  // الخطوة الأولى: إنشاء مستخدم جديد وربطه بالفايربيس (تم تعديله ليكون عبر رابط login)
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

  // الخطوة الثانية: إكمال بيانات المشرف (المنطقة والنوع)
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

  Future<dynamic> getSupervisorPerformanceReport(dynamic data) async {
    return await _apiService.post('supervisor-report', data: data);
  }
}
