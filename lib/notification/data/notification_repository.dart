import 'package:web2/notification/data/models/notification_model.dart';
import 'package:web2/notification/data/models/report_details_model.dart';
import 'package:web2/notification/data/models/statistics_model.dart';
import 'notification_service.dart';

/// مستودع يربط بين [NotificationService] و ViewModel،
/// ويحوّل استجابات API الخام إلى نماذج Dart مع معالجة الأخطاء.
class NotificationRepository {
  final NotificationService _service;
  NotificationRepository(this._service);

  /// يجلب ويحلل الإشعارات من API، مع استخراج عدد الإشعارات غير المقروءة.
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
      } catch (_) {
      }
    }

    return {'unread_count': unreadCount, 'notifications': notifications};
  }

  /// يعلّم الإشعار كمقروء بواسطة معرفه.
  Future<void> setRead(String id) async {
    await _service.markAsRead(id);
  }

  /// يجلب ويحلل بيانات البلاغ التفصيلية لمعرّف بلاغ معين.
  Future<ReportDetailsModel> fetchReportDetails(int id) async {
    final response = await _service.getReportDetails(id);

    dynamic reportData;
    if (response.data is Map) {
      final body = response.data as Map<String, dynamic>;
      if (body.containsKey('data')) {
        reportData = body['data'];
      } else if (body.containsKey('report')) {
        reportData = body['report'];
      } else {
        reportData = body;
      }
    }

    if (reportData != null && reportData is Map<String, dynamic>) {
      return ReportDetailsModel.fromJson(reportData);
    } else {
      throw Exception("Invalid data structure for report details");
    }
  }

  /// ينشر أو يلغي نشر بلاغ، ويعيد الحالة الفعلية من استجابة السيرفر.
  Future<bool> publish(int id, bool isPublished) async {
    final response = await _service.publishReport(id, isPublished);
    try {
      if (response.data is Map) {
        final body = response.data as Map<String, dynamic>;
        final data = body['data'] ?? body;
        if (data is Map) {
          final val = data['is_published'] ?? data['is_publish'];
          if (val != null) return _parseBool(val);
        }
      }
    } catch (_) {}
    return isPublished;
  }

  /// يلغي بلاغاً بسبب معين.
  Future<void> cancel(int id, String reason) async =>
      await _service.cancelReport(id, reason);

  /// يجلب ويحلل إحصائيات البلاغات من API.
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
        throw Exception("Failed to read statistics data");
      }
    } catch (_) {
      return StatisticModel(
        total: 0,
        active: 0,
        resolved: 0,
        resolutionRate: '0%',
      );
    }
  }

  /// يحلل عدداً صحيحاً بأمان من قيمة ديناميكية.
  int _parseInt(dynamic v) {
    if (v == null) return 0;
    if (v is int) return v;
    return int.tryParse(v.toString()) ?? 0;
  }

  /// يحلل قيمة منطقية (Boolean) بأمان من أنواع مختلفة.
  bool _parseBool(dynamic value) {
    if (value == null) return false;
    if (value is bool) return value;
    if (value is int) return value == 1;
    final str = value.toString().toLowerCase();
    return str == '1' || str == 'true';
  }
}
