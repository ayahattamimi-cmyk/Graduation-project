///   يتولى إرسال طلبات HTTP مباشرةً لنقطة نهاية البلاغات.

import '../../core/network/api_service.dart';
import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';

class NotificationService {
  final ApiService _apiService;
  NotificationService(this._apiService);

  // جلب الإشعارات
  Future<dynamic> getNotifications() async {
    return await _apiService.post('notifications');
  }

  // تحديث كمقروء
  Future<dynamic> markAsRead(String id) async {
    return await _apiService.post('notifications/$id/read');
  }

  // جلب تفاصيل البلاغ
  Future<dynamic> getReportDetails(int id) async {
    debugPrint('[NotificationService] Fetching report details for id: $id');
    return await _apiService.post('reports/$id');
  }

  // نشر البلاغ
  Future<dynamic> publishReport(int id) async => await _apiService.patch(
    'reports/$id/publish',
    data: FormData.fromMap({'is_published': 1}),
  );

  // إلغاء البلاغ
  Future<dynamic> cancelReport(int id, String reason) async {
    return await _apiService.post(
      'reports/$id/cancel',
      data: FormData.fromMap({'reason': reason}),
    );
  }

  // جلب الإحصائيات
  Future<dynamic> getStatistics() async =>
      await _apiService.get('reports/statistics');
}
