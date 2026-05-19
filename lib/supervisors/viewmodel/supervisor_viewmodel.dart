import 'package:flutter/material.dart';
import '../data/supervisor_repository.dart';
import '../data/supervisor_service.dart';
import '../model/supervisor_model.dart';

class SupervisorViewModel extends ChangeNotifier {

  final SupervisorRepository _repository;

  SupervisorViewModel([SupervisorRepository? repository])
      : _repository = repository ?? SupervisorRepository(SupervisorService());

  List<SupervisorModel> supervisors = [];

  bool isLoading = false;

  String filter = "all";

  String? errorMessage;

  /// جلب المشرفين
  Future<void> loadSupervisors() async {

    isLoading = true;
    notifyListeners();

    try {

      supervisors =
      await _repository.fetchAllSupervisors();

      errorMessage = null;

    } catch (e) {

      errorMessage =
      "حدث خطأ أثناء جلب المشرفين";
    }

    isLoading = false;

    notifyListeners();
  }

  /// إضافة مشرف
  Future<void> addSupervisor(
      SupervisorModel supervisor,
      ) async {

    isLoading = true;
    notifyListeners();

    try {

      await _repository.addSupervisor(
        supervisor,
      );

      await loadSupervisors();

    } catch (e) {

      debugPrint(
        "Error add supervisor: $e",
      );
    }

    isLoading = false;
    notifyListeners();
  }

  /// تعديل مشرف
  Future<bool> updateSupervisor(
      int id,
      Map<String, dynamic> data,
      ) async {

    isLoading = true;
    notifyListeners();

    try {

      bool success =
      await _repository.updateSupervisorInfo(
        id,
        data,
      );

      if (success) {

        await loadSupervisors();

        return true;
      }

      return false;

    } catch (e) {

      debugPrint(
        "Error update supervisor: $e",
      );

      return false;
    }

    finally {

      isLoading = false;

      notifyListeners();
    }
  }

  /// فلترة
  void changeFilter(String f){

    filter = f;

    notifyListeners();
  }

  List<SupervisorModel> get filtered{

    if(filter == "sweeping"){

      return supervisors
          .where(
            (e)=>e.type=="sweeping",
      )
          .toList();
    }

    if(filter == "lifting"){

      return supervisors
          .where(
            (e)=>e.type=="lifting",
      )
          .toList();
    }

    return supervisors;
  }

  int get sweepingCount =>
      supervisors
          .where(
            (e)=>e.type=="sweeping",
      )
          .length;

  int get liftingCount =>
      supervisors
          .where(
            (e)=>e.type=="lifting",
      )
          .length;
}