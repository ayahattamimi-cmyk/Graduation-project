import 'package:flutter/material.dart';
import '../data/assignment_repository.dart';
import '../data/assignment_model.dart';
import '../../supervisors/data/model/supervisor_model.dart';
import '../../supervisors/data/supervisor_repository.dart'; // استيراد المستودع المشترك

class AssignmentViewModel extends ChangeNotifier {
  final AssignmentRepository _repository;
  final SupervisorRepository
  _supervisorRepository; // حقن المستودع المشترك للمشرفين

  AssignmentViewModel(this._repository, this._supervisorRepository);

  AssignmentSuggestionModel? suggestion;
  List<SupervisorModel> supervisors = [];
  bool isLoading = false;

  String selectedArea = "";
  int? selectedSupervisorId;
  int reportsCount = 0;

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

  // القيم الافتراضية المعتمدة في السيرفر (sweeping للكنس، lifting للرفع)
  String selectedWorkType = "sweeping";
  final List<String> workTypes = ["sweeping", "lifting"];

  // 1. التوجيه التلقائي (الخطوة الأولى)
  Future<void> loadAssignmentSuggestion(int reportId) async {
    isLoading = true;
    notifyListeners();

    try {
      // جلب الاقتراح الآلي بناءً على الإحداثيات
      suggestion = await _repository.fetchSuggestion(reportId);

      // استخدام المستودع المشترك لجلب قائمة كل المشرفين (منعاً للتكرار)
      supervisors = await _supervisorRepository.fetchAllSupervisors();

      if (suggestion != null) {
        selectedArea = suggestion!.squareLabel;
        selectedSupervisorId = suggestion!.supervisorId;
        reportsCount = suggestion!.reportsCount;
      } else if (supervisors.isNotEmpty) {
        selectedSupervisorId = supervisors.first.id;
      }
    } catch (e) {
      debugPrint(" فشل جلب بيانات التوجيه: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // 2. تحديث المشرف يدوياً من القائمة المنسدلة
  void setSupervisor(int id) {
    selectedSupervisorId = id;
    notifyListeners();
  }

  // 3. التوجيه المتقدم (تغيير نوع العمل وجلب المشرف المتخصص في المربع)
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
        debugPrint(" فشل جلب بيانات التوجيه المتقدم: $e");
      } finally {
        isLoading = false;
        notifyListeners();
      }
    }
  }

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
      debugPrint(" فشل عملية التعيين النهائية: $e");
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
