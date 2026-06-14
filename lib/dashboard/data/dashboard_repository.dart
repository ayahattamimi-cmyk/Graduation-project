import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'dashboard_model.dart';
import 'dashboard_service.dart';

class DashboardRepository {
  final DashboardService _service;

  /// ينشئ [DashboardRepository] مع [DashboardService] المحدد.
  DashboardRepository(this._service);

  /// يجلب ويحلل إحصائيات لوحة التحكم من API.
  Future<DashboardModel> fetchDashboardStats() async {
    try {
      final response = await _service.getDashboardData();
      dynamic responseData = response.data;

      if (responseData is String) {
        try {
          responseData = jsonDecode(responseData);
        } catch (e) {
          throw Exception("فشل في معالجة بيانات السيرفر (JSON Error)");
        }
      }

      if (responseData is Map) {
        if (responseData['status'] == 'success') {
          return DashboardModel.fromJson(responseData['data'] ?? {});
        } else {
          throw Exception(responseData['message'] ?? "حدث خطأ غير معروف");
        }
      } else {
        throw Exception("تنسيق رد السيرفر غير متوقع (ليس Map)");
      }
    } catch (e) {
      rethrow;
    }
  }
}
