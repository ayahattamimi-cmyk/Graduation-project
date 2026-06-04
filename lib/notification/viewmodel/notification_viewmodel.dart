import 'package:flutter/material.dart';
import '../data/models/notification_model.dart';
import '../data/notification_repository.dart';
import '../data/models/report_details_model.dart';

class NotificationsViewModel extends ChangeNotifier {
  final NotificationRepository _repository;
  NotificationsViewModel(this._repository);

  // --- البيانات الأساسية ---
  List<NotificationModel> _notifications = [];
  int _serverUnreadCount = 0; // العدد القادم من السيرفر مباشرة
  bool _isLoading = false;
  ReportDetailsModel? _selectedReport;

  // --- Getters ---
  List<NotificationModel> get notifications => _notifications;
  bool get isLoading => _isLoading;
  ReportDetailsModel? get selectedReport => _selectedReport;

  // --- إحصائيات محسوبة ذاتياً من البيانات القادمة ---
  int get totalNotificationsCount => _notifications.length;

  int get readNotificationsCount =>
      _notifications.where((n) => n.isRead == true).length;

  int get unreadNotificationsCount =>
      _notifications.where((n) => n.isRead == false).length;

  // استخدام العدد القادم من السيرفر كأولوية للتنبيه (Badge)
  int get unreadCount => _serverUnreadCount;

  // دالة شاملة لتحميل بيانات الصفحة
  Future<void> loadDashboardData() async {
    _isLoading = true;
    notifyListeners();

    try {
      final result = await _repository.fetchNotifications();
      _notifications = result['notifications'];
      _serverUnreadCount = result['unread_count'];
    } catch (e) {
      debugPrint("❌ خطأ في جلب الإشعارات: $e");
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> loadNotifications() => loadDashboardData();

  Future<void> loadReportDetails(int reportId) async {
    _isLoading = true;
    _selectedReport = null;
    notifyListeners();
    try {
      _selectedReport = await _repository.fetchReportDetails(reportId);
    } catch (e) {
      debugPrint("Error loading report details ($reportId): $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> markRead(String id) async {
    try {
      await _repository.setRead(id);
      await loadNotifications(); // تحديث القائمة والعدد فوراً
    } catch (e) {
      debugPrint("Error marking as read: $e");
    }
  }

  Future<void> publishReport(int id) async {
    _isLoading = true;
    notifyListeners();
    try {
      await _repository.publish(id);
      // بعد النشر نقوم بتحديث البلاغ والإشعارات لضمان مزامنة حالة الزر
      await loadReportDetails(id);
      await loadNotifications();
    } catch (e) {
      debugPrint("Error publishing report: $id: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> cancelReport(int id, String reason) async {
    _isLoading = true;
    notifyListeners();
    try {
      await _repository.cancel(id, reason);
      await loadReportDetails(id);
      await loadNotifications();
    } catch (e) {
      debugPrint("Error cancelling report: $id: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
