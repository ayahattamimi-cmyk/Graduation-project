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
  bool isLoadingAreas = false;
  String filter = "all";
  String? errorMessage;

  /// يحمل جميع المشرفين من المستودع.
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

  /// يضيف مشرفاً جديداً ويحدث القائمة.
  Future<void> addSupervisor(SupervisorModel supervisor) async {
    isLoading = true;
    notifyListeners();

    try {
      await _repository.addSupervisor(supervisor);
      await loadSupervisors();
    } catch (e) {
      rethrow;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  /// يحمل إحصائيات المشرفين.
  Future<void> loadStatistics() async {
    try {
      statistics = await _repository.fetchStatistics();
      notifyListeners();
    } catch (e) {
    }
  }

  int _loadAreasCounter = 0;

  /// يحمل المناطق حسب النوع، متجاهلاً الاستجابات القديمة من الاستدعاءات السابقة.
  Future<void> loadAreas(String type) async {
    _loadAreasCounter++;
    final int callId = _loadAreasCounter;
    isLoadingAreas = true;
    notifyListeners();
    try {
      final result = await _repository.fetchAreas(type);
      if (callId == _loadAreasCounter) {
        areas = result;
      }
    } catch (e) {
    } finally {
      isLoadingAreas = false;
      notifyListeners();
    }
  }

  /// يحدث مشرفاً ويجدد القائمة عند النجاح.
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

  /// يعيد المشرفين المصفاة حسب قيمة الفلتر الحالية.
  List<SupervisorModel> get filteredSupervisors {
    if (filter == "sweeping") {
      return supervisors.where((e) => e.type == "sweeping").toList();
    } else if (filter == "lifting") {
      return supervisors.where((e) => e.type == "lifting").toList();
    }
    return supervisors;
  }

  int get sweepingCount =>
      supervisors.where((e) => e.type == "sweeping").length;
  int get liftingCount => supervisors.where((e) => e.type == "lifting").length;

  /// يغير الفلتر الحالي ويخطر المستمعين.
  void changeFilter(String f) {
    filter = f;
    notifyListeners();
  }

  void _setLoading(bool value) {
    isLoading = value;
    notifyListeners();
  }

  /// يجلب تقرير الأداء لاسم مشرف ونوع معينين.
  Future<void> fetchPerformanceReport(String name, String type) async {
    isLoading = true;
    notifyListeners();

    try {
      final result = await _repository.fetchSupervisorPerformance(
        name,
        type == "رفع" ? "lifting" : "sweeping",
      );
      supervisorsPerformance = result;
      errorMessage = null;
    } catch (e) {
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  /// الخطوة 1: ينشئ حساب خادم ويعيد المعرف والرمز المميز.
  Future<Map<String, dynamic>?> createServerAccount(
    String idToken,
    String name,
  ) async {
    _setLoading(true);
    try {
      final result = await _repository.createAccountOnServer(
        idToken: idToken,
        name: name,
        role: "supervisors",
      );
      _setLoading(false);
      return result;
    } catch (e) {
      _setLoading(false);
      rethrow;
    }
  }

  /// الخطوة 2: يكمل بيانات المشرف (النوع والمنطقة) على الخادم.
  Future<bool> completeSupervisorData(
    String type,
    String areaId, {
    String? name,
    int? userId,
    String? firebaseToken,
    String? serverToken,
  }) async {
    _setLoading(true);
    try {
      bool success = await _repository.saveSupervisorDetails(
        type: type,
        areaId: areaId,
        name: name,
        userId: userId,
        firebaseToken: firebaseToken,
        serverToken: serverToken,
      );
      if (success) {
        await loadSupervisors();
      }
      return success;
    } catch (e) {
      return false;
    } finally {
      _setLoading(false);
    }
  }
}
