import 'package:flutter/material.dart';
import '../data/assignment_repository.dart';
import '../data/assignment_model.dart';
import '../../supervisors/data/model/supervisor_model.dart';
import '../../supervisors/data/supervisor_repository.dart';

class AssignmentViewModel extends ChangeNotifier {
  final AssignmentRepository _repository;
  final SupervisorRepository _supervisorRepository;

  AssignmentViewModel(this._repository, this._supervisorRepository);

  AssignmentSuggestionModel? suggestion;
  List<SupervisorModel> supervisors = [];
  bool isLoading = false;

  String selectedArea = "";
  int? selectedSupervisorId;
  int reportsCount = 0;

  /// يعيد اسم المشرف المحدد حالياً.
  String get selectedSupervisorName {
    if (selectedSupervisorId == null) return "غير محدد";
    final s = supervisors.firstWhere(
      (element) => element.id == selectedSupervisorId,
      orElse:
          () => SupervisorModel(
            id: 0,
            name: "غير معروف",
            type: "",
            area: "",
            areaDetails: [],
          ),
    );
    return s.name;
  }

  String selectedWorkType = "sweeping";
  final List<String> workTypes = ["sweeping", "lifting"];

  /// يحمل اقتراح التعيين التلقائي لبلاغ ويملأ قائمة المشرفين.
  Future<void> loadAssignmentSuggestion(int reportId) async {
    isLoading = true;
    notifyListeners();

    try {
      suggestion = await _repository.fetchSuggestion(reportId);
      supervisors = await _supervisorRepository.fetchAllSupervisors();

      if (suggestion != null) {
        selectedArea = suggestion!.squareLabel;
        selectedSupervisorId = suggestion!.supervisorId;
        reportsCount = suggestion!.reportsCount;

      } else if (supervisors.isNotEmpty) {
        selectedSupervisorId = supervisors.first.id;
      }
    } catch (e) {
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  /// يحدد المشرف المختار يدوياً من القائمة المنسدلة.
  void setSupervisor(int id) {
    selectedSupervisorId = id;
    notifyListeners();
  }

  /// يغير نوع العمل ويجلب المشرف المتخصص لذلك المربع.
  Future<void> setWorkType(String type) async {
    selectedWorkType = type;
    notifyListeners();

    if (suggestion != null) {
      isLoading = true;
      notifyListeners();

      try {
        final advancedData = await _repository.fetchSquareDetails(
          suggestion!.squareId,
          selectedWorkType,
        );

        if (advancedData != null) {
          selectedArea = advancedData.squareLabel;
          selectedSupervisorId = advancedData.supervisorId;
          reportsCount = advancedData.reportsCount;
        }
      } catch (e) {
      } finally {
        isLoading = false;
        notifyListeners();
      }
    }
  }

  /// يرسل طلب التعيين النهائي إلى الخادم.
  Future<bool> sendAssignment(int reportId) async {
    if (selectedSupervisorId == null) return false;

    isLoading = true;
    notifyListeners();

    try {
      final success = await _repository.sendAssignment(
        reportId: reportId,
        supervisorId: selectedSupervisorId!,
      );
      return success;
    } catch (e) {
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
