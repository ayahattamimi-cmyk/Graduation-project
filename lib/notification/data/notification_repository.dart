///   يعمل كوسيط بين [NotificationService] والـ ViewModel.
///   يتولى تحويل بيانات الإشعارات وتفاصيل البلاغات إلى
///   نماذج Dart قابلة للعرض مع معالجة آمنة للأخطاء.

import 'package:flutter/foundation.dart';
import 'package:web2/notification/data/models/notification_model.dart';
import 'package:web2/notification/data/models/report_details_model.dart';
import 'package:web2/notification/data/models/statistics_model.dart';
import 'notification_service.dart';

class NotificationRepository {
  final NotificationService _service;
  NotificationRepository(this._service);

  Future<Map<String, dynamic>> fetchNotifications() async {
    final response = await _service.getNotifications();

    List notificationsList = [];
    int unreadCount = 0;

    if (response.data is Map) {
      final Map<String, dynamic> body = response.data;

      if (body.containsKey('data') && body['data'] is Map) {
        notificationsList = body['data']['notifications'] ?? [];
        unreadCount = _parseInt(body['data']['unread_count']);
      } else if (body.containsKey('data') && body['data'] is List) {
        notificationsList = body['data'];
        unreadCount = _parseInt(body['unread_count']);
      } else if (body.containsKey('notifications')) {
        notificationsList = body['notifications'] ?? [];
        unreadCount = _parseInt(body['unread_count']);
      }
    } else if (response.data is List) {
      notificationsList = response.data;
    }

    final List<NotificationModel> notifications = [];
    for (var element in notificationsList) {
      try {
        if (element is Map<String, dynamic>) {
          notifications.add(NotificationModel.fromJson(element));
        }
      } catch (e) {
        debugPrint(
          "⚠️ Failed to parse notification element: $element, error: $e",
        );
      }
    }

    return {'unread_count': unreadCount, 'notifications': notifications};
  }

  Future<void> setRead(String id) async {
    await _service.markAsRead(id);
  }

  Future<ReportDetailsModel> fetchReportDetails(int id) async {
    final response = await _service.getReportDetails(id);
    debugPrint("=== Debug Report Details RAW Response ===");
    debugPrint(response.data.toString());

    dynamic reportData;
    if (response.data is Map) {
      final body = response.data as Map<String, dynamic>;
      // البحث في المفاتيح الشائعة التي قد يرسلها Laravel
      if (body.containsKey('data')) {
        reportData = body['data'];
      } else if (body.containsKey('report')) {
        reportData = body['report'];
      } else {
        // إذا كانت البيانات في الـ root مباشرة
        reportData = body;
      }
    }

    if (reportData != null && reportData is Map<String, dynamic>) {
      return ReportDetailsModel.fromJson(reportData);
    } else {
      throw Exception("بنية بيانات غير صالحة لتفاصيل البلاغ");
    }
  }

  Future<void> publish(int id) async => await _service.publishReport(id);

  Future<void> cancel(int id, String reason) async =>
      await _service.cancelReport(id, reason);

  Future<StatisticModel> fetchStatistics() async {
    try {
      final response = await _service.getStatistics();

      Map<String, dynamic>? statsData;

      if (response.data is Map) {
        final body = response.data as Map<String, dynamic>;
        if (body['data'] is Map) {
          statsData = body['data'] as Map<String, dynamic>;
        } else if (body.containsKey('total')) {
          statsData = body;
        } else {
          statsData = body;
        }
      }

      if (statsData != null) {
        return StatisticModel.fromJson(statsData);
      } else {
        throw Exception("فشل في قراءة بيانات الإحصائيات");
      }
    } catch (e) {
      debugPrint("fetchStatistics error: $e");
      return StatisticModel(
        total: 0,
        active: 0,
        resolved: 0,
        resolutionRate: '0%',
      );
    }
  }

  int _parseInt(dynamic v) {
    if (v == null) return 0;
    if (v is int) return v;
    return int.tryParse(v.toString()) ?? 0;
  }
}
