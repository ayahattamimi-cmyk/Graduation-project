import '../../core/network/api_service.dart';
import 'package:dio/dio.dart';

class ReportService {
  final ApiService _apiService;
  ReportService(this._apiService);

  Future<dynamic> filterReports({
    String? areaId,
    String? status,
    String? reportType,
    String? period,
  }) async {
    // تجهيز البيانات كـ FormData لضمان التوافق مع الويب
    FormData formData = FormData.fromMap({
      if (areaId != null && areaId.isNotEmpty) "area_id": areaId,
      if (status != null && status.isNotEmpty) "status": status,
      if (reportType != null && reportType.isNotEmpty)
        "report_type": reportType,
      if (period != null && period.isNotEmpty) "period": period,
    });

    return await _apiService.post('filter-reports', data: formData);
  }

  // دالة جلب الإحصائيات العامة للبلاغات
  Future<dynamic> getGeneralReportStats() async {
    return await _apiService.get('reports/statistics');
  }

  // دالة إلغاء البلاغ مع ذكر السبب
  Future<dynamic> cancelReport(int id, String reason) async {
    FormData formData = FormData.fromMap({"reason": reason});
    return await _apiService.post('reports/$id/cancel', data: formData);
  }
}
