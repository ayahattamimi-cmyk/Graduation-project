import 'package:flutter/material.dart';
import '../data/assignment_data.dart';

class AssignmentViewModel extends ChangeNotifier {

  AssignmentViewModel(){
    fetchReportsCount();
    _updateSupervisor();
  }

  String selectedArea = "مربع 1 - السوق العام";
  String selectedWorkType = "كنس";

  String supervisorName = "";
  int reportsCount = 0;

  final Map<String,String> supervisors = {
    "مربع 1 - السوق العام": "أحمد محمد الحربي",
    "مربع 2 - الحي الشمالي": "سعود القحطاني",
    "مربع 3 - المنطقة الصناعية": "خالد عبدالله القحطاني",
    "مربع 4 - الكورنيش": "عبدالعزيز العتيبي",
    "مربع 5 - المركز": "محمد الزهراني",
  };

  final List<String> areas = [
    "مربع 1 - السوق العام",
    "مربع 2 - الحي الشمالي",
    "مربع 3 - المنطقة الصناعية",
    "مربع 4 - الكورنيش",
    "مربع 5 - المركز",
  ];

  final List<String> workTypes = ["كنس","رفع"];

  void setArea(String value){
    selectedArea = value;
    _updateSupervisor();
    fetchReportsCount();
    notifyListeners();
  }

  void setWorkType(String value){
    selectedWorkType = value;
    notifyListeners();
  }

  void _updateSupervisor(){
    supervisorName = supervisors[selectedArea] ?? "";
  }

  /// mock API
  Future<void> fetchReportsCount() async {

    await Future.delayed(const Duration(milliseconds: 300));

    final fakeApi = {
      "مربع 1 - السوق العام": 12,
      "مربع 2 - الحي الشمالي": 8,
      "مربع 3 - المنطقة الصناعية": 52,
      "مربع 4 - الكورنيش": 4,
      "مربع 5 - المركز": 17,
    };

    reportsCount = fakeApi[selectedArea] ?? 0;
    notifyListeners();
  }

  AssignmentData assignReport(){
    return AssignmentData(
      area: selectedArea,
      workType: selectedWorkType,
      supervisorName: supervisorName,
      reportsCount: reportsCount,
    );
  }
}