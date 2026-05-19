import 'package:dio/dio.dart';

class ReportService {
  final Dio _dio;
  ReportService(this._dio);

  Future<Response> filterReports({
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

    return await _dio.post('filter-reports', data: formData);
  }

  // دالة جلب الإحصائيات العامة للبلاغات
  Future<Response> getGeneralReportStats() async {
    // سنستخدم الرابط الذي يوفره الباك أند للبلاغات
    return await _dio.get('reports/statistics'); // افتراضي حتى يتم تأكيد الرابط
  }
}
