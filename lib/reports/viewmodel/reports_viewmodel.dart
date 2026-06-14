import 'package:flutter/material.dart';
import 'package:web2/reports/data/models/SupervisorPerformanceModel.dart';
import 'package:web2/reports/data/models/report_model.dart';
import 'package:web2/reports/data/models/report_statistics_model.dart';
import 'package:web2/supervisors/data/model/area_detail_model.dart';
import '../data/report_repository.dart';
import '../../supervisors/data/supervisor_repository.dart';

class ReportViewModel extends ChangeNotifier {
  List<ReportModel> get filteredReports => reports;
  final ReportRepository _reportRepository;
  final SupervisorRepository _supervisorRepository;

  ReportViewModel(this._reportRepository, this._supervisorRepository);

  List<ReportModel> reports = [];
  List<SupervisorPerformanceModel> supervisorsPerformance = [];
  List<AreaDetailModel> areaObjects = [];
  ReportStatisticsModel? generalStats;
  bool isLoadingReports = false;
  bool isLoadingSupervisors = false;

  bool get isLoading => isLoadingReports || isLoadingSupervisors;

  String selectedArea = "جميع المناطق";
  String selectedType = "جميع الأنواع";
  String selectedStatus = "جميع الحالات";
  String selectedPeriod = "جميع الفترات";

  String selectedSupervisor = "جميع المشرفين";
  String selectedSupType = "جميع الأنواع";

  List<String> areas = ["جميع المناطق"];
  List<String> types = ["جميع الأنواع", "رفع", "كنس"];
  List<String> status = [
    "جميع الحالات",
    "تم الحل",
    "قيد الانتظار",
    "قيد التنفيذ",
  ];
  List<String> periods = [
    "جميع الفترات",
    "اليوم",
    "أمس",
    "هذا الأسبوع",
    "الأسبوع الماضي",
    "هذا الشهر",
    "الشهر الماضي",
    "هذا العام",
  ];
  List<String> supervisors = ["جميع المشرفين"];

  /// يحمل جميع البيانات عند تهيئة الصفحة.
  void loadAllData() {
    fetchReports();
    fetchSupervisorsNames();
    fetchAreas();
    fetchGeneralStats();
    fetchSupervisorStats();
  }

  /// يجلب المناطق من الخادم، ويدمج مناطق الرفع والكنس.
  Future<void> fetchAreas() async {
    try {
      final liftingAreas = await _supervisorRepository.fetchAreas("lifting");
      final sweepingAreas = await _supervisorRepository.fetchAreas("sweeping");
      areaObjects = [...liftingAreas, ...sweepingAreas];
      areas = [
        "جميع المناطق",
        ...areaObjects.map((e) => e.label ?? e.name ?? e.id.toString()),
      ];
      notifyListeners();
    } catch (e) {
    }
  }

  /// يجلب إحصائيات التقارير العامة.
  Future<void> fetchGeneralStats() async {
    try {
      generalStats = await _reportRepository.getGeneralStats();
      notifyListeners();
    } catch (e) {
    }
  }

  /// يجلب التقارير المصفاة من المستودع.
  Future<void> fetchReports() async {
    isLoadingReports = true;
    notifyListeners();
    try {
      String? areaParam;
      if (selectedArea != "جميع المناطق") {
        final areaObj = areaObjects.firstWhere(
          (e) => (e.label ?? e.name ?? e.id.toString()) == selectedArea,
          orElse:
              () =>
                  areaObjects.isNotEmpty
                      ? areaObjects[0]
                      : AreaDetailModel(id: 0, name: ""),
        );
        areaParam = areaObj.id.toString();
      }

      String? mappedStatus;
      if (selectedStatus == "تم الحل")
        mappedStatus = "Solved";
      else if (selectedStatus == "قيد الانتظار")
        mappedStatus = "Pending";
      else if (selectedStatus == "قيد التنفيذ")
        mappedStatus = "Processing";

      String? mappedType;
      if (selectedType == "رفع")
        mappedType = "Lifting";
      else if (selectedType == "كنس")
        mappedType = "Sweeping";

      final String? periodParam =
          (selectedPeriod == "جميع الفترات")
              ? null
              : _mapPeriodToApi(selectedPeriod);

      reports = await _reportRepository.getFilteredReports(
        areaId: areaParam,
        status: mappedStatus,
        reportType: mappedType,
        period: periodParam,
      );
    } catch (e) {
    } finally {
      isLoadingReports = false;
      notifyListeners();
    }
  }

  /// يجلب أسماء المشرفين للقائمة المنسدلة.
  Future<void> fetchSupervisorsNames() async {
    try {
      final all = await _supervisorRepository.fetchAllSupervisors();
      supervisors = ["جميع المشرفين", ...all.map((s) => s.name)];
      notifyListeners();
    } catch (e) {
    }
  }

  /// يجلب بيانات أداء المشرفين بناءً على الفلاتر.
  Future<void> fetchSupervisorStats() async {
    isLoadingSupervisors = true;
    notifyListeners();
    try {
      final String supervisorName =
          selectedSupervisor == "جميع المشرفين" ? "" : selectedSupervisor;
      final String supType =
          selectedSupType == "رفع"
              ? "Lifting"
              : (selectedSupType == "كنس" ? "Sweeping" : "");

      final result = await _supervisorRepository.fetchSupervisorPerformance(
        supervisorName,
        supType,
      );
      supervisorsPerformance =
          result.map((e) => SupervisorPerformanceModel.fromJson(e)).toList();
    } catch (e) {
    } finally {
      isLoadingSupervisors = false;
      notifyListeners();
    }
  }

  /// يحدد فلتر المنطقة ويعيد جلب التقارير.
  void setArea(String v) {
    selectedArea = v;
    fetchReports();
  }

  /// يحدد فلتر النوع ويعيد جلب التقارير.
  void setType(String v) {
    selectedType = v;
    fetchReports();
  }

  /// يحدد فلتر الحالة ويعيد جلب التقارير.
  void setStatus(String v) {
    selectedStatus = v;
    fetchReports();
  }

  /// يحدد فلتر الفترة ويعيد جلب التقارير.
  void setPeriod(String v) {
    selectedPeriod = v;
    fetchReports();
  }

  /// يحدد فلتر المشرف لقسم أداء المشرفين.
  void setSupervisor(String v) {
    selectedSupervisor = v;
    fetchSupervisorStats();
  }

  /// يحدد فلتر نوع عمل المشرف لقسم الأداء.
  void setSupType(String v) {
    selectedSupType = v;
    fetchSupervisorStats();
  }

  int get total => reports.length;
  int get solved =>
      reports.where((e) {
        final s = e.status.toLowerCase();
        return s == "تم الحل" ||
            s == "محلول" ||
            s == "solved" ||
            s == "completed";
      }).length;
  int get pending => total - solved;

  /// يربط تسمية الفترة العربية بقيمة معامل API.
  String _mapPeriodToApi(String p) {
    switch (p) {
      case "اليوم":
        return "today";
      case "أمس":
        return "yesterday";
      case "هذا الأسبوع":
        return "this_week";
      case "الأسبوع الماضي":
        return "last_week";
      case "هذا الشهر":
        return "this_month";
      case "الشهر الماضي":
        return "last_month";
      case "هذا العام":
        return "this_year";
      default:
        return "";
    }
  }

  /// يعيد أفضل 3 مشرفين مرتبين حسب نسبة الإنجاز.
  List<String> get topSupervisors {
    if (supervisorsPerformance.isEmpty) return [];
    List<SupervisorPerformanceModel> sorted = List.from(supervisorsPerformance);

    sorted.sort((a, b) {
      double rateA =
          double.tryParse(a.completionRate.replaceAll('%', '')) ?? 0.0;
      double rateB =
          double.tryParse(b.completionRate.replaceAll('%', '')) ?? 0.0;
      return rateB.compareTo(rateA);
    });
    return sorted.take(3).map((s) => s.name).toList();
  }

  /// يلغي بلاغاً ويحدث القائمة والإحصائيات.
  Future<bool> cancelReport(int id, String reason) async {
    final success = await _reportRepository.cancelReport(id, reason);
    if (success) {
      await fetchReports();
      await fetchGeneralStats();
    }
    return success;
  }
}
