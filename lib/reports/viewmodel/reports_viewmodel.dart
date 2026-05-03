import 'package:flutter/material.dart';
import '../data/report_data.dart';

class ReportViewModel extends ChangeNotifier {

  List<ReportData> reports = [];
  List<ReportData> filteredReports = [];

  String selectedArea = "جميع المناطق";
  String selectedType = "جميع الأنواع";
  String selectedStatus = "جميع الحالات";
  String selectedPeriod = "آخر أسبوع";

  List<String> areas = [
    "جميع المناطق",
    "مربع 1 - السوق العام",
    "مربع 2 - الحي الشمالي",
    "مربع 3 - الصناعية",
  ];

  List<String> types = ["جميع الأنواع", "كنس", "رفع"];
  List<String> status = ["جميع الحالات", "محلول", "قيد التنفيذ", "قيد الانتظار"];
  List<String> periods = ["آخر أسبوع", "آخر شهر", "آخر 3 أشهر", "آخر سنة"];

  ///  فلترة المشرفين
  String selectedSupervisorArea = "جميع المناطق";
  String selectedSupervisorType = "جميع الأنواع";
  String selectedSupervisor = "جميع المشرفين";

  List<String> supervisors = ["جميع المشرفين"];
  List<String> supervisorAreas = ["جميع المناطق", "مربع 1", "مربع 2", "مربع 3"];
  List<String> supervisorTypes = ["جميع الأنواع", "كنس", "رفع"];

  void setSupervisorArea(String v) {
    selectedSupervisorArea = v;
    notifyListeners();
  }

  void setSupervisorType(String v) {
    selectedSupervisorType = v;
    notifyListeners();
  }
  void setSupervisor(String v) {
    selectedSupervisor = v;
    notifyListeners();
  }

  void loadData() {
    //supervisors = [
     // "جميع المشرفين",
    //  ...reports.map((e) => e.supervisor).toSet()
   // ];
    reports = [
      ReportData(
        id: "#2025-001",
        date: "2025-12-01",
        area: "مربع 1",
        type: "كنس",
        status: "محلول",
        supervisor: "زكي مبارك",
        duration: 2.5,
      ),
      ReportData(
        id: "#2025-002",
        date: "2025-12-01",
        area: "مربع 3",
        type: "رفع",
        status: "قيد التنفيذ",
        supervisor: "فهد سليمان",
        duration: 1.8,
      ),

    ];
    supervisors = [
      "جميع المشرفين",
      ...reports.map((e) => e.supervisor).toSet()
    ];

    applyFilters();
  }

  void applyFilters() {
    filteredReports = reports.where((r) {
      final matchArea =
          selectedArea == "جميع المناطق" || r.area.contains(selectedArea);

      final matchType =
          selectedType == "جميع الأنواع" || r.type == selectedType;

      final matchStatus =
          selectedStatus == "جميع الحالات" || r.status == selectedStatus;

      return matchArea && matchType && matchStatus;
    }).toList();

    notifyListeners();
  }

  void setArea(String v) {
    selectedArea = v;
    applyFilters();
  }

  void setType(String v) {
    selectedType = v;
    applyFilters();
  }

  void setStatus(String v) {
    selectedStatus = v;
    applyFilters();
  }

  void setPeriod(String v) {
    selectedPeriod = v;
    applyFilters();
  }

  int get total => filteredReports.length;
  int get solved => filteredReports.where((e) => e.status == "محلول").length;
  int get pending => filteredReports.where((e) => e.status != "محلول").length;

  List<String> get topSupervisors {
    final map = <String, int>{};

    for (var r in reports) {
      map[r.supervisor] = (map[r.supervisor] ?? 0) + 1;
    }

    final sorted = map.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return sorted.take(3).map((e) => e.key).toList();
  }

  ///  إحصائيات المشرفين
  List<Map<String, dynamic>> get supervisorStats {
    final map = <String, List<ReportData>>{};


    for (var r in reports) {
      map.putIfAbsent(r.supervisor, () => []);
      map[r.supervisor]!.add(r);
    }

    return map.entries.map((entry) {


      final filtered = entry.value.where((r) {

        final matchArea = selectedSupervisorArea == "جميع المناطق" ||
            r.area.contains(selectedSupervisorArea);

        final matchType = selectedSupervisorType == "جميع الأنواع" ||
            r.type == selectedSupervisorType;

        return matchArea && matchType;

      }).toList();

      final total = filtered.length;
      final done = filtered.where((e) => e.status == "محلول").length;
      final notDone = total - done;


      if (selectedSupervisor != "جميع المشرفين" &&
          entry.key != selectedSupervisor) {
        return {
          "name": entry.key,
          "total": 0,
          "done": 0,
          "notDone": 0,
          "rate": 0.0,
        };
      }

      return {
        "name": entry.key,
        "total": total,
        "done": done,
        "notDone": notDone,
        "rate": total == 0 ? 0 : (done / total) * 100
      };

    }).toList();
  }
}