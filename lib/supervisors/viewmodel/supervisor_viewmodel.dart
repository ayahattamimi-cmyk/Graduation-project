import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:web2/supervisors/data/supervisor_repository.dart';
import '../data/model/supervisor_model.dart';
import '../data/model/area_detail_model.dart';
import '../data/model/statistics_model.dart';

class SupervisorViewModel extends ChangeNotifier {
  final SupervisorRepository _repository;

  SupervisorViewModel(this._repository);

  // البيانات
  List<SupervisorModel> supervisors = [];
  List<AreaDetailModel> areas = [];
  // قائمة بسيطة لتخزين أداء المشرفين القادم من السيرفر
  List<dynamic> supervisorsPerformance = [];
  StatisticsModel? statistics;

  // حالات الواجهة
  bool isLoading = false;
  String filter = "all";
  String? errorMessage;

  // 1. جلب جميع المشرفين من السيرفر
  Future<void> loadSupervisors() async {
    _setLoading(true);
    try {
      supervisors = await _repository.fetchAllSupervisors();
      errorMessage = null;
    } catch (e) {
      errorMessage = "حدث خطأ أثناء جلب بيانات المشرفين";
    } finally {
      _setLoading(false);
    }
  }

  Future<void> addSupervisor(SupervisorModel supervisor) async {
    isLoading = true;
    notifyListeners();

    try {
      // استدعاء الريبوزيتوري لإرسال البيانات للسيرفر (Laravel API)
      await _repository.addSupervisor(supervisor);

      // يمكنك هنا تحديث القائمة المحلية إذا أردت
      // _supervisors.add(supervisor);
    } catch (e) {
      debugPrint("Error adding supervisor: $e");
      rethrow; // لإتاحة معالجة الخطأ في شاشة الـ Login
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // 2. جلب الإحصائيات (CountStatistics)
  Future<void> loadStatistics() async {
    try {
      statistics = await _repository.fetchStatistics();
      notifyListeners();
    } catch (e) {
      debugPrint("خطأ في جلب الإحصائيات: $e");
    }
  }

  // 3. جلب المربعات للقائمة المنسدلة (Dropdown)
  Future<void> loadAreas(String type) async {
    try {
      areas = await _repository.fetchAreas(type);
      notifyListeners();
    } catch (e) {
      debugPrint("خطأ في جلب المربعات: $e");
    }
  }

  // 4. تحديث بيانات مشرف (تواصل مع السيرفر وتحديث محلي)
  Future<bool> updateSupervisor(int id, Map<String, dynamic> data) async {
    _setLoading(true);
    try {
      bool success = await _repository.updateSupervisorInfo(id, data);
      if (success) {
        await loadSupervisors(); // إعادة جلب البيانات لتحديث القائمة
        return true;
      }
      return false;
    } catch (e) {
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // 5. منطق الفلترة (Filtered List)
  List<SupervisorModel> get filteredSupervisors {
    if (filter == "sweeping") {
      return supervisors.where((e) => e.type == "sweeping").toList();
    } else if (filter == "lifting") {
      return supervisors.where((e) => e.type == "lifting").toList();
    }
    return supervisors;
  }

  // 6. عدادات سريعة للواجهة
  int get sweepingCount =>
      supervisors.where((e) => e.type == "sweeping").length;
  int get liftingCount => supervisors.where((e) => e.type == "lifting").length;

  // تغيير الفلتر
  void changeFilter(String f) {
    filter = f;
    notifyListeners();
  }

  // دالة مساعدة لتغيير حالة التحميل
  void _setLoading(bool value) {
    isLoading = value;
    notifyListeners();
  }

  // --- تقييم أداء المشرفين ---

  Future<void> fetchPerformanceReport(String name, String type) async {
    isLoading = true;
    notifyListeners();

    try {
      FormData formData = FormData.fromMap({
        "name": name,
        "type":
            type == "رفع" ? "lifting" : "sweeping", // التحويل لإنجليزية السيرفر
      });

      final result = await _repository.fetchSupervisorPerformance(name, type);
      supervisorsPerformance = result;
      errorMessage = null;
    } catch (e) {
      debugPrint("❌ فشل جلب الأداء: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
