// notification_service.dart
// التوكن يُضاف تلقائياً لكل الطلبات عبر DioClient interceptor
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class NotificationService {
  final Dio _dio;
  NotificationService(this._dio);

  // جلب الإشعارات - POST كما هو في Postman
  // التوكن يُحقن تلقائياً في الـ body عبر DioClient interceptor
  Future<Response> getNotifications() async {
    return await _dio.post('notifications');
  }

  // تحديث كمقروء
  Future<Response> markAsRead(String id) async =>
      await _dio.post('notifications/$id/read');

  // جلب تفاصيل البلاغ - POST كما هو في Postman
  Future<Response> getReportDetails(int id) async {
    debugPrint('[NotificationService] Fetching report details for id: $id');
    return await _dio.post('reports/$id');
  }

  // نشر البلاغ
  Future<Response> publishReport(int id) async =>
      await _dio.patch('reports/$id/publish');

  // جلب الإحصائيات
  Future<Response> getStatistics() async =>
      await _dio.get('reports/statistics');
}
