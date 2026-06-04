import 'package:web2/reports/data/models/report_model.dart';
import 'package:flutter/foundation.dart';
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

      final data = response.data;

      // تحقق من نوع الاستجابة
      if (data == null) {
        return [];
      }

      final responseStatus = data['status']?.toString();

      if (responseStatus == 'success') {
        final innerData = data['data'];

        List? reportsData = innerData?['reports'] ?? innerData?['data'];
        if (reportsData == null) {
          if (innerData is List) {
            reportsData = innerData;
          } else {
            debugPrint(
              "⚠️ [Repo] reportsData not found. innerData = $innerData",
            );
            return [];
          }
        }

        return reportsData.map((e) => ReportModel.fromJson(e)).toList();
      } else {
        return [];
      }
    } catch (e, st) {
      debugPrint("❌ [Repo] Exception: $e");
      debugPrint("❌ [Repo] StackTrace: $st");
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

  // إلغاء البلاغ
  Future<bool> cancelReport(int id, String reason) async {
    try {
      final response = await _service.cancelReport(id, reason);
      return response.data['status'] == 'success';
    } catch (e) {
      debugPrint("❌ [Repo] Error cancelling report: $e");
      return false;
    }
  }
}
