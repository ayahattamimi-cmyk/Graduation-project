import 'package:flutter/material.dart';
import 'package:web2/drop_locations/data/area_model.dart';
import 'package:web2/drop_locations/data/container_model.dart';
import '../data/container_repository.dart';
import '../data/statistics_model.dart';

class DropLocationsViewModel extends ChangeNotifier {
  final ContainerRepository _repository;

  DropLocationsViewModel(this._repository);

  List<AreaModel> _areas = [];
  StatisticsModel? _statistics;
  bool _isLoading = false;
  String? _errorMessage;

  List<AreaModel> get areas => _areas;
  StatisticsModel? get statistics => _statistics;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> fetchContainersData() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _areas = await _repository.fetchAreasWithContainers();

      // جلب الإحصائيات بشكل منفصل حتى لا يمنع فشلها عرض الحاويات
      try {
        _statistics = await _repository.fetchStatistics();
      } catch (statsError) {
        debugPrint("⚠️ فشل جلب الإحصائيات (لن يمنع عرض البيانات): $statsError");
        // نتجاهل خطأ الإحصائيات ونعرض البيانات بدونها
      }
    } catch (e) {
      _errorMessage = "فشل في تحميل البيانات: ${e.toString()}";
      debugPrint("ViewModel Error: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  List<String> get areaNames => _areas.map((area) => area.areaDetails).toList();

  Future<void> addContainer(ContainerModel container) async {
    _isLoading = true;
    notifyListeners();
    try {
      await _repository.addContainer(container);
      await fetchContainersData(); // تحديث القائمة بعد الإضافة
    } catch (e) {
      _errorMessage = "فشل إضافة الموقع: $e";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> deleteContainer(int containerId) async {
    try {
      await _repository.removeContainer(containerId);

      // تحديث القائمة محلياً فورياً لتجربة مستخدم سلسة
      for (var area in _areas) {
        area.containers.removeWhere((c) => c.id == containerId);
      }

      // تحديث الإحصائيات بعد الحذف
      _statistics = await _repository.fetchStatistics();

      notifyListeners();
    } catch (e) {
      _errorMessage = "فشل الحذف: $e";
      notifyListeners();
    }
  }

  // --- أضيفي هذه الدالة داخل الفيو مودل ---
  Future<void> editContainer(int id, ContainerModel updatedContainer) async {
    try {
      // نرسل طلب التعديل للمستودع
      await _repository.updateContainer(id, updatedContainer);

      // بعد نجاح التعديل في السيرفر، نعيد جلب البيانات لتحديث الشاشة
      await fetchContainersData();

      notifyListeners();
    } catch (e) {
      _errorMessage = "فشل في تعديل البيانات: $e";
      notifyListeners();
    }
  }
}
