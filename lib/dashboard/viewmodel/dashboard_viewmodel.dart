import 'package:flutter/material.dart';
import 'package:web2/dashboard/data/dashboard_model.dart';
import 'package:web2/dashboard/data/dashboard_repository.dart';

class DashboardViewModel extends ChangeNotifier {
  final DashboardRepository _repository;

  /// ينشئ [DashboardViewModel] مع [DashboardRepository] المحدد.
  DashboardViewModel(this._repository);

  DashboardModel? _dashboardData;
  bool _isLoading = false;

  /// بيانات لوحة التحكم الحالية، أو null إذا لم يتم تحميلها بعد.
  DashboardModel? get dashboardData => _dashboardData;

  /// ما إذا كانت لوحة التحكم تقوم بتحميل البيانات حالياً.
  bool get isLoading => _isLoading;

  /// العدد الإجمالي للبلاغات من إحصائيات لوحة التحكم.
  String get totalReports =>
      _dashboardData?.statistics.totalReports.toString() ?? "--";

  /// عدد البلاغات المُحلّة من إحصائيات لوحة التحكم.
  String get resolvedReports =>
      _dashboardData?.statistics.resolved.count.toString() ?? "--";

  /// عدد البلاغات المعلقة/قيد المعالجة من إحصائيات لوحة التحكم.
  String get processingReports =>
      _dashboardData?.statistics.pending.count.toString() ?? "--";

  /// عدد المناطق النشطة من قائمة المناطق الأكثر تفاعلاً.
  String get activeAreas => _dashboardData?.topAreas.length.toString() ?? "--";

  /// يحمّل إحصائيات لوحة التحكم من المستودع ويُخطر المستمعين.
  Future<void> loadStats() async {
    _isLoading = true;
    notifyListeners();

    try {
      _dashboardData = await _repository.fetchDashboardStats();
    } catch (e) {
      // التعامل مع الخطأ بصمت
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
