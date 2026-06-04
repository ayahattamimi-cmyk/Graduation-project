import '../../core/network/api_service.dart';

class AssignmentService {
  final ApiService _apiService;
  AssignmentService(this._apiService);

  // جلب المربع المقترح بناءً على إحداثيات البلاغ
  Future<dynamic> getSuggestion(int reportId) async {
    return await _apiService.get('report-square/$reportId');
  }

  // إنشاء عملية التعيين (ربط البلاغ بمشرف)
  Future<dynamic> postAssignment(dynamic data) async {
    return await _apiService.post('AssignmenCreate', data: data);
  }

  // جلب تفاصيل المربع بناءً على رقم المربع ونوع العمل (توجيه يدوي متقدم)
  Future<dynamic> getSquareDetails(int squareId, String type) async {
    return await _apiService.get('report-square-all/$squareId/$type');
  }
}
