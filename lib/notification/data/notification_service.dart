import '../../core/network/api_service.dart';
import 'package:dio/dio.dart';

/// خدمة تعالج طلبات HTTP لنقاط نهاية الإشعارات والبلاغات.
class NotificationService {
  final ApiService _apiService;
  NotificationService(this._apiService);

  /// يجلب جميع الإشعارات من الخادم.
  Future<dynamic> getNotifications() async {
    return await _apiService.post('notifications');
  }

  /// يعلّم إشعاراً محدّداً كمقروء.
  Future<dynamic> markAsRead(String id) async {
    return await _apiService.post('notifications/$id/read');
  }

  /// يجلب معلومات تفصيلية لبلاغ محدّد.
  Future<dynamic> getReportDetails(int id) async {
    return await _apiService.post('reports/$id');
  }

  /// ينشر أو يلغي نشر بلاغ بقيمة صريحة.
  Future<dynamic> publishReport(int id, bool isPublished) async {
    return await _apiService.patch(
      'reports/$id/publish',
      data: FormData.fromMap({'is_published': isPublished ? 1 : 0}),
    );
  }

  /// يلغي بلاغاً مع سبب.
  Future<dynamic> cancelReport(int id, String reason) async {
    return await _apiService.post(
      'reports/$id/cancel',
      data: FormData.fromMap({'reason': reason}),
    );
  }

  /// يجلب إحصائيات البلاغات من الخادم.
  Future<dynamic> getStatistics() async =>
      await _apiService.get('reports/statistics');
}
