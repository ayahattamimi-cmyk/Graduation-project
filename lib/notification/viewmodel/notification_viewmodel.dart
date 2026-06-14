import 'package:flutter/material.dart';
import '../data/models/notification_model.dart';
import '../data/notification_repository.dart';
import '../data/models/report_details_model.dart';

/// ViewModel يدير حالة الإشعارات وتفاصيل البلاغ وإجراءات النشر/الإلغاء.
class NotificationsViewModel extends ChangeNotifier {
  final NotificationRepository _repository;
  NotificationsViewModel(this._repository);

  List<NotificationModel> _notifications = [];
  int _serverUnreadCount = 0;
  bool _isLoading = false;
  ReportDetailsModel? _selectedReport;
  List<NotificationModel> get notifications => _notifications;
  bool get isLoading => _isLoading;
  ReportDetailsModel? get selectedReport => _selectedReport;

  int get totalNotificationsCount => _notifications.length;

  int get readNotificationsCount =>
      _notifications.where((n) => n.isRead == true).length;

  int get unreadNotificationsCount =>
      _notifications.where((n) => n.isRead == false).length;

  int get unreadCount => _serverUnreadCount;

  /// يحمّل جميع بيانات لوحة القيادة بما في ذلك الإشعارات وعدد غير المقروء.
  Future<void> loadDashboardData() async {
    _isLoading = true;
    notifyListeners();

    try {
      final result = await _repository.fetchNotifications();
      _notifications = result['notifications'];
      _serverUnreadCount = result['unread_count'];
    } catch (_) {
    }

    _isLoading = false;
    notifyListeners();
  }

  /// اسم مستعار لـ [loadDashboardData].
  Future<void> loadNotifications() => loadDashboardData();

  /// يحمّل تفاصيل بلاغ محدّد مع دمج is_published من الإشعارات إن وُجدت.
  Future<void> loadReportDetails(int reportId) async {
    _isLoading = true;
    notifyListeners();
    try {
      final newReport = await _repository.fetchReportDetails(reportId);
      final match = _notifications.where((n) => n.reportId == reportId);
      if (match.isNotEmpty && match.first.isPublished != newReport.isPublished) {
        _selectedReport = newReport.copyWith(isPublished: match.first.isPublished);
      } else {
        _selectedReport = newReport;
      }
    } catch (_) {
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// يعلّم الإشعار كمقروء ويحدّث القائمة.
  Future<void> markRead(String id) async {
    try {
      await _repository.setRead(id);
      await loadNotifications();
    } catch (_) {
    }
  }

  /// ينشر أو يلغي النشر، ثم يحدّث الإشعارات لضمان بقاء الحالة بعد إعادة الدخول.
  Future<void> publishReport(int id) async {
    try {
      final bool newState = !(_selectedReport?.isPublished ?? false);
      await _repository.publish(id, newState);
      await loadDashboardData();
      final match = _notifications.where((n) => n.reportId == id);
      if (match.isNotEmpty && _selectedReport != null) {
        _selectedReport = _selectedReport!.copyWith(isPublished: match.first.isPublished);
        notifyListeners();
      }
    } catch (_) {}
  }

  /// يلغي بلاغاً مع سبب، ثم يحدّث التفاصيل والقائمة.
  Future<void> cancelReport(int id, String reason) async {
    _isLoading = true;
    notifyListeners();
    try {
      await _repository.cancel(id, reason);
      await loadReportDetails(id);
      await loadNotifications();
    } catch (_) {
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
