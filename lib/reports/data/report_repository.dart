import 'package:web2/reports/data/models/report_model.dart';
import 'package:flutter/foundation.dart';
import 'package:web2/reports/data/models/report_statistics_model.dart';
import 'package:web2/reports/data/report_service.dart';

class ReportRepository {
  final ReportService _service;
  ReportRepository(this._service);

  /// يجلب التقارير المصفاة حسب المنطقة والحالة والنوع والفترة الاختيارية.
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
            return [];
          }
        }

        return reportsData.map((e) => ReportModel.fromJson(e)).toList();
      } else {
        return [];
      }
    } catch (e, st) {
      return [];
    }
  }

  /// يجلب إحصائيات التقارير العامة.
  Future<ReportStatisticsModel?> getGeneralStats() async {
    try {
      final response = await _service.getGeneralReportStats();
      if (response.data['status'] == 'success') {
        return ReportStatisticsModel.fromJson(response.data['data']);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  /// يلغي بلاغاً بالمعرف والسبب المحددين.
  Future<bool> cancelReport(int id, String reason) async {
    try {
      final response = await _service.cancelReport(id, reason);
      return response.data['status'] == 'success';
    } catch (e) {
      return false;
    }
  }
}
