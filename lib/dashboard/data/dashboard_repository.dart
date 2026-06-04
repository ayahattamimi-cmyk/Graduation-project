/// ============================================================
/// 📁 dashboard_repository.dart — طبقة الوصول (Repository)
/// ============================================================
/// المسؤولية:
///   يعمل كحلقة وسيطة بين [DashboardService] والـ ViewModel.
///   يستتلم البيانات الخام ويحولها إلى كائنات [DashboardModel]
///   جاهزة للعرض.
///
/// ملاحظة:
///   يستخدم [debugPrint] لتسجيل ردود الـ API أثناء التطوير.
/// ============================================================
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'dashboard_model.dart';
import 'dashboard_service.dart';

class DashboardRepository {
  final DashboardService _service;
  DashboardRepository(this._service);

  Future<DashboardModel> fetchDashboardStats() async {
    try {
      final response = await _service.getDashboardData();
      dynamic responseData = response.data;

      // إذا كان الرد نصاً (String)، نقوم بتحويله إلى Map
      if (responseData is String) {
        try {
          responseData = jsonDecode(responseData);
        } catch (e) {
          debugPrint("🚨 Failed to decode JSON string: $e");
          throw Exception("فشل في معالجة بيانات السيرفر (JSON Error)");
        }
      }

      // التحقق من أن الرد عبارة عن Map بعد التحويل
      if (responseData is Map) {
        if (responseData['status'] == 'success') {
          return DashboardModel.fromJson(responseData['data'] ?? {});
        } else {
          throw Exception(responseData['message'] ?? "حدث خطأ غير معروف");
        }
      } else {
        debugPrint("🚨 Unexpected response format: $responseData");
        throw Exception("تنسيق رد السيرفر غير متوقع (ليس Map)");
      }
    } catch (e) {
      debugPrint("Error in DashboardRepository: $e");
      rethrow;
    }
  }
}
