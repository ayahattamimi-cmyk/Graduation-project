import '../../core/network/api_service.dart';
import 'package:dio/dio.dart';

class ReportService {
  final ApiService _apiService;
  ReportService(this._apiService);

  /// يصفي التقارير حسب المنطقة والحالة والنوع والفترة باستخدام FormData.
  Future<dynamic> filterReports({
    String? areaId,
    String? status,
    String? reportType,
    String? period,
  }) async {
    FormData formData = FormData.fromMap({
      if (areaId != null && areaId.isNotEmpty) "area_id": areaId,
      if (status != null && status.isNotEmpty) "status": status,
      if (reportType != null && reportType.isNotEmpty)
        "report_type": reportType,
      if (period != null && period.isNotEmpty) "period": period,
    });

    return await _apiService.post('filter-reports', data: formData);
  }

  /// يجلب إحصائيات التقارير العامة.
  Future<dynamic> getGeneralReportStats() async {
    return await _apiService.get('reports/statistics');
  }

  /// يلغي بلاغاً مع ذكر السبب.
  Future<dynamic> cancelReport(int id, String reason) async {
    FormData formData = FormData.fromMap({"reason": reason});
    return await _apiService.post('reports/$id/cancel', data: formData);
  }
}
