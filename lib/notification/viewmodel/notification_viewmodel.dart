import 'package:flutter/material.dart';
import 'package:web2/notification/data/models/notification_model.dart';
import 'package:web2/notification/data/models/statistics_model.dart';
import 'package:web2/notification/data/notification_repository.dart';

class NotificationsViewModel extends ChangeNotifier {
  final NotificationRepository _repository;
  NotificationsViewModel(this._repository);

  // --- الإحصائيات ---
  StatisticModel? _stats; // [تعديل] استخدام كائن المودل مباشرة أسهل
  StatisticModel? get stats => _stats;

  // --- الإشعارات ---
  List<NotificationModel> _notifications = [];
  int _unreadCount = 0;
  bool _isLoading = false;

  List<NotificationModel> get notifications => _notifications;
  int get unreadCount => _unreadCount;
  bool get isLoading => _isLoading;

  // دالة شاملة لتحميل كل بيانات الصفحة مرة واحدة
  Future<void> loadDashboardData() async {
    _isLoading = true;
    notifyListeners();

    // نجلب البيانين بشكل مستقل حتى لو فشل أحدهم لا يوقف الآخر
    try {
      await _fetchInternalNotifications();
    } catch (e) {
      debugPrint("❌ خطأ في جلب الإشعارات: $e");
    }

    try {
      await _fetchInternalStatistics();
    } catch (e) {
      debugPrint("❌ خطأ في جلب الإحصائيات: $e");
    }

    _isLoading = false;
    notifyListeners();
  }

  // الدوال الداخلية تكون بسيطة فقط لجلب البيانات
  Future<void> _fetchInternalNotifications() async {
    final result = await _repository.fetchNotifications();
    _notifications = result['notifications'];
    _unreadCount = result['unread_count'];
  }

  Future<void> _fetchInternalStatistics() async {
    _stats = await _repository.fetchStatistics();
  }

  Future<void> loadNotifications() async {
    _isLoading = true;
    notifyListeners();
    try {
      final result = await _repository.fetchNotifications();
      _notifications = result['notifications'];
      _unreadCount = result['unread_count'];
    } catch (e) {
      debugPrint("Error loading notifications: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadStatistics() async {
    _isLoading = true;
    notifyListeners();
    try {
      _stats = await _repository.fetchStatistics();
    } catch (e) {
      debugPrint("Error loading stats: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> markRead(String id) async {
    try {
      await _repository.setRead(id);
      await loadNotifications(); // تحديث القائمة والعدد فوراً بعد القراءة
    } catch (e) {
      debugPrint("Error marking as read: $e");
    }
  }
}
