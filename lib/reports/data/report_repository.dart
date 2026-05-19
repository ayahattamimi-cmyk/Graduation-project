import 'package:web2/reports/data/models/report_model.dart';
import 'package:flutter/foundation.dart';
import 'package:web2/reports/data/models/report_model.dart';
import 'package:web2/reports/data/models/report_statistics_model.dart';
import 'package:web2/reports/data/report_service.dart';

class ReportRepository {
  final ReportService _service;
  ReportRepository(this._service);

  Future<List<ReportModel>> getFilteredReports({
    String? areaId,
    String? status,
    String? reportType,
    String? period,
  }) async {
    try {
      final response = await _service.filterReports(
        areaId: areaId,
        status: status,
        reportType: reportType,
        period: period,
      );

      debugPrint("📡 [Repo] Raw Response: ${response.data}");

      if (response.data['status'] == 'success') {
        List reportsData = response.data['data']['reports'];
        return reportsData.map((e) => ReportModel.fromJson(e)).toList();
      } else {
        debugPrint("⚠️ [Repo] Status was not success: ${response.data['message']}");
        return [];
      }
    } catch (e) {
      debugPrint("❌ [Repo] Exception: $e");
      return [];
    }
  }

  // جلب الإحصائيات العامة للبلاغات
  Future<ReportStatisticsModel?> getGeneralStats() async {
    try {
      // سنفترض أن الرابط هو reports-statistics أو مشابه، أو نستخدم الرابط الذي يوفره الباك أند
      // ملاحظة: إذا كان الرابط هو CountStatistics، يجب التأكد من تطابق البيانات
      final response = await _service.getGeneralReportStats();
      if (response.data['status'] == 'success') {
        return ReportStatisticsModel.fromJson(response.data['data']);
      }
      return null;
    } catch (e) {
      debugPrint("❌ [Repo] Error fetching stats: $e");
      return null;
    }
  }

}
