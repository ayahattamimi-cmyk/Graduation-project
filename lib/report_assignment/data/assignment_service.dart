import '../../core/network/api_service.dart';

class AssignmentService {
  final ApiService _apiService;
  AssignmentService(this._apiService);

  /// يجلب المربع المقترح لبلاغ بناءً على إحداثياته.
  Future<dynamic> getSuggestion(int reportId) async {
    return await _apiService.get('report-square/$reportId');
  }

  /// يرسل تعييناً يربط بلاغاً بمشرف.
  Future<dynamic> postAssignment(dynamic data) async {
    return await _apiService.post('AssignmenCreate', data: data);
  }

  /// يجلب تفاصيل المربع حسب معرف المربع ونوع العمل للتوجيه اليدوي.
  Future<dynamic> getSquareDetails(int squareId, String type) async {
    return await _apiService.get('report-square-all/$squareId/$type');
  }
}
