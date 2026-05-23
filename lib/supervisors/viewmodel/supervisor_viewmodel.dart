import 'package:flutter/material.dart';
import 'package:web2/supervisors/data/supervisor_repository.dart';
import '../data/model/supervisor_model.dart';
import '../data/model/area_detail_model.dart';
import '../data/model/statistics_model.dart';

class SupervisorViewModel extends ChangeNotifier {
  final SupervisorRepository _repository;

  SupervisorViewModel(this._repository);

  List<SupervisorModel> supervisors = [];
  List<AreaDetailModel> areas = [];
  List<dynamic> supervisorsPerformance = [];
  StatisticsModel? statistics;

  bool isLoading = false;
  String filter = "all";
  String? errorMessage;

  Future<void> loadSupervisors() async {
    _setLoading(true);
    try {
      supervisors = await _repository.fetchAllSupervisors();
      errorMessage = null;
    } catch (e) {
      errorMessage = "حدث خطأ أثناء جلب بيانات المشرفين";
    } 
    finally {
      _setLoading(false);
    }
  }

  Future<void> addSupervisor(SupervisorModel supervisor) async {
    isLoading = true;
    notifyListeners();

    try {
      // إرسال البيانات إلى Laravel API
      await _repository.addSupervisor(supervisor);
      
      // ✅ إعادة جلب القائمة مباشرة من السيرفر لضمان مزامنة الـ ID والبيانات بدقة
      await loadSupervisors(); 
    } catch (e) {
      debugPrint("Error adding supervisor: $e");
      rethrow; 
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadStatistics() async {
    try {
      statistics = await _repository.fetchStatistics();
      notifyListeners();
    } catch (e) {
      debugPrint("خطأ في جلب الإحصائيات: $e");
    }
  }

  // جلب المربعات ديناميكياً بحسب نوع العمل المختار
  Future<void> loadAreas(String type) async {
    try {
      areas = await _repository.fetchAreas(type);
      notifyListeners();
    } catch (e) {
      debugPrint("خطأ في جلب المربعات: $e");
    }
  }

  Future<bool> updateSupervisor(int id, Map<String, dynamic> data) async {
    _setLoading(true);
    try {
      bool success = await _repository.updateSupervisorInfo(id, data);
      if (success) {
        await loadSupervisors();
        return true;
      }
      return false;
    } catch (e) {
      return false;
    } finally {
      _setLoading(false);
    }
  }

  List<SupervisorModel> get filteredSupervisors {
    if (filter == "sweeping") {
      return supervisors.where((e) => e.type == "sweeping").toList();
    } else if (filter == "lifting") {
      return supervisors.where((e) => e.type == "lifting").toList();
    }
    return supervisors;
  }

  int get sweepingCount => supervisors.where((e) => e.type == "sweeping").length;
  int get liftingCount => supervisors.where((e) => e.type == "lifting").length;

  void changeFilter(String f) {
    filter = f;
    notifyListeners();
  }

  void _setLoading(bool value) {
    isLoading = value;
    notifyListeners();
  }

  Future<void> fetchPerformanceReport(String name, String type) async {
    isLoading = true;
    notifyListeners();

    try {
      final result = await _repository.fetchSupervisorPerformance(
        name, 
        type == "رفع" ? "lifting" : "sweeping"
      );
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