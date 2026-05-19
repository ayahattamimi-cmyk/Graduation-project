import 'package:flutter/material.dart';
import 'package:web2/dashboard/data/dashboard_model.dart';
import 'package:web2/dashboard/data/dashboard_repository.dart';

class DashboardViewModel extends ChangeNotifier {
  final DashboardRepository _repository;

  DashboardViewModel(this._repository);

  DashboardModel? _dashboardData;
  bool _isLoading = false; // متغير خاص بالحالة

  // Getters
  DashboardModel? get dashboardData => _dashboardData;
  bool get isLoading => _isLoading; // Getter للوصول للحالة من الفيو

  // اختصارات (Getters) للبيانات الأساسية
  String get totalReports =>
      _dashboardData?.statistics.totalReports.toString() ?? "--";
  String get resolvedReports =>
      _dashboardData?.statistics.resolved.count.toString() ?? "--";
  String get processingReports =>
      _dashboardData?.statistics.pending.count.toString() ?? "--";
  String get activeAreas => _dashboardData?.topAreas.length.toString() ?? "--";

  Future<void> loadStats() async {
    _isLoading = true; // بدء التحميل
    notifyListeners();

    try {
      _dashboardData = await _repository.fetchDashboardStats();
    } catch (e) {
      debugPrint("❌ DashboardViewModel Error: $e");
    } finally {
      _isLoading = false; // انتهاء التحميل (سواء نجح أو فشل)
      notifyListeners();
    }
  }
}
