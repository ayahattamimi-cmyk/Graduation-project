import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:web2/drop_locations/data/area_model.dart';
import 'package:web2/drop_locations/data/container_model.dart';
import '../../supervisors/data/supervisor_repository.dart';
import '../../supervisors/data/model/area_detail_model.dart';
import '../data/container_repository.dart';
import '../data/statistics_model.dart';

class DropLocationsViewModel extends ChangeNotifier {
  final ContainerRepository _repository;
  final SupervisorRepository _supervisorRepo;

  /// ينشئ [DropLocationsViewModel] مع المستودعات المحددة.
  DropLocationsViewModel(this._repository, this._supervisorRepo);

  List<AreaModel> _areas = [];
  List<AreaDetailModel> _referenceAreas = [];
  StatisticsModel? _statistics;
  bool _isLoading = false;
  String? _errorMessage;

  /// قائمة المناطق التي تم جلبها مع حاوياتها.
  List<AreaModel> get areas => _areas;

  /// يعيد المناطق المرجعية إن وجدت، وإلا يتراجع إلى المناطق التي تم جلبها.
  List<AreaModel> get referenceAreas =>
      _referenceAreas.isEmpty
          ? _areas
          : _referenceAreas
              .map(
                (e) => AreaModel(
                  id: e.id,
                  areaDetails: e.label ?? e.name ?? '',
                  containers: [],
                ),
              )
              .toList();

  /// بيانات الإحصائيات الحالية.
  StatisticsModel? get statistics => _statistics;

  /// ما إذا كانت البيانات قيد التحميل حالياً.
  bool get isLoading => _isLoading;

  /// آخر رسالة خطأ، أو null إذا لم يحدث خطأ.
  String? get errorMessage => _errorMessage;

  /// يجلب جميع بيانات الحاويات (المناطق والمناطق المرجعية والإحصائيات) من الخادم.
  Future<void> fetchContainersData() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _areas = await _repository.fetchAreasWithContainers();

      try {
        _referenceAreas = await _supervisorRepo.fetchAreas('lifting');
      } catch (e) {
        // غير حرج: المناطق المرجعية اختيارية
      }

      try {
        _statistics = await _repository.fetchStatistics();
      } catch (statsError) {
        // غير حرج: فشل الإحصائيات لا يجب أن يمنع العرض
      }
    } catch (e) {
      _errorMessage = "فشل في تحميل البيانات: ${e.toString()}";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// يعيد قائمة أسماء المناطق للعرض.
  List<String> get areaNames => _areas.map((area) => area.areaDetails).toList();

  /// يضيف حاوية جديدة ويحدّث البيانات.
  Future<void> addContainer(ContainerModel container) async {
    _isLoading = true;
    notifyListeners();
    try {
      await _repository.addContainer(container);
      await fetchContainersData();
    } catch (e) {
      _errorMessage = "فشل إضافة الموقع: $e";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// يحذف حاوية بواسطة [containerId]، ويحدّث القائمة المحلية، ويحدّث الإحصائيات.
  Future<void> deleteContainer(int containerId) async {
    try {
      await _repository.removeContainer(containerId);

      for (var area in _areas) {
        area.containers.removeWhere((c) => c.id == containerId);
      }

      _statistics = await _repository.fetchStatistics();

      notifyListeners();
    } catch (e) {
      _errorMessage = "فشل الحذف: $e";
      notifyListeners();
    }
  }

  /// يحدّث حاوية موجودة بـ [id] ببيانات جديدة ويحدّث القائمة.
  Future<void> editContainer(int id, ContainerModel updatedContainer) async {
    try {
      await _repository.updateContainer(id, updatedContainer);

      await fetchContainersData();

      notifyListeners();
    } catch (e) {
      _errorMessage = "فشل في تعديل البيانات: $e";
      notifyListeners();
    }
  }
}
