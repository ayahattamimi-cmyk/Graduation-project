import 'package:flutter/material.dart';
import '../data/report_data.dart';

class ReportViewModel extends ChangeNotifier {

  /// كل البيانات (من API مستقبلاً)
  List<ReportData> reports = [];

  /// بعد الفلترة
  List<ReportData> filteredReports = [];

  /// الفلاتر
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

  /// تحميل بيانات (Mock الآن - API لاحقاً)
  void loadData() {
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

    applyFilters();
  }

  /// الفلترة
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

  /// setters
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

  /// إحصائيات
  int get total => filteredReports.length;
  int get solved => filteredReports.where((e) => e.status == "محلول").length;
  int get pending => filteredReports.where((e) => e.status != "محلول").length;

  /// أفضل 3 مشرفين
  List<String> get topSupervisors {
    final map = <String, int>{};

    for (var r in reports) {
      map[r.supervisor] = (map[r.supervisor] ?? 0) + 1;
    }

    final sorted = map.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return sorted.take(3).map((e) => e.key).toList();
  }

  /// تصدير (لاحقاً)
  void exportPDF() {
    print("Export PDF");
  }

  void exportExcel() {
    print("Export Excel");
  }
}