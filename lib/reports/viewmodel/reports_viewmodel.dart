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

  // --- البيانات الحقيقية ---
  List<ReportModel> reports = [];
  List<SupervisorPerformanceModel> supervisorsPerformance = [];
  List<AreaDetailModel> areaObjects = [];
  ReportStatisticsModel? generalStats;
  bool isLoadingReports = false; // حالة تحميل البلاغات بشكل مستقل
  bool isLoadingSupervisors = false; // حالة تحميل المشرفين بشكل مستقل

  bool get isLoading => isLoadingReports || isLoadingSupervisors;

  // --- فلاتر البلاغات الرئيسية ---
  String selectedArea = "جميع المناطق";
  String selectedType = "جميع الأنواع";
  String selectedStatus = "جميع الحالات";
  String selectedPeriod = "جميع الفترات"; // افتراضياً: بدون فلتر فترة زمنية

  // --- فلاتر أداء المشرفين المصححة ---
  String selectedSupervisor = "جميع المشرفين";
  String selectedSupType = "جميع الأنواع";

  // قوائم الاختيارات للـ Dropdowns
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

  // دالة التهيئة الشاملة عند فتح الصفحة
  void loadAllData() {
    fetchReports();
    fetchSupervisorsNames();
    fetchAreas();
    fetchGeneralStats();
    fetchSupervisorStats();
  }

  // جلب المناطق من السيرفر
  Future<void> fetchAreas() async {
    try {
      final result = await _supervisorRepository.fetchAreas("lifting");
      areaObjects = result;
      areas = [
        "جميع المناطق",
        ...result.map((e) => e.label ?? e.name ?? e.id.toString()),
      ];
      notifyListeners();
    } catch (e) {
      debugPrint("❌ خطأ جلب المناطق: $e");
    }
  }

  // جلب الإحصائيات العامة للبلاغات
  Future<void> fetchGeneralStats() async {
    try {
      generalStats = await _reportRepository.getGeneralStats();
      notifyListeners();
    } catch (e) {
      debugPrint("❌ خطأ جلب الإحصائيات العامة: $e");
    }
  }

  // 1. جلب بلاغات التقارير (مع معالجة "جميع المناطق")
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

      // تحويل القيم العربية إلى القيم التي يتوقعها الباك أند (English)
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

      // إرسال period فقط إذا تم اختيار فترة محددة
      final String? periodParam =
          (selectedPeriod == "جميع الفترات")
              ? null
              : _mapPeriodToApi(selectedPeriod);

      debugPrint(
        "🔎 [VM] Fetching reports: area=$areaParam status=$mappedStatus type=$mappedType period=$periodParam",
      );

      reports = await _reportRepository.getFilteredReports(
        areaId: areaParam,
        status: mappedStatus,
        reportType: mappedType,
        period: periodParam,
      );

      debugPrint("✅ [VM] Reports loaded: ${reports.length} items");
    } catch (e) {
      debugPrint("❌ [Reports] Error: $e");
    } finally {
      isLoadingReports = false;
      notifyListeners();
    }
  }

  // 2. جلب أسماء المشرفين للقائمة المنسدلة
  Future<void> fetchSupervisorsNames() async {
    try {
      final all = await _supervisorRepository.fetchAllSupervisors();
      supervisors = ["جميع المشرفين", ...all.map((s) => s.name)];
      notifyListeners();
    } catch (e) {
      debugPrint("❌ خطأ جلب أسماء المشرفين: $e");
    }
  }

  // 3. جلب أداء المشرفين بناءً على الفلاتر الخاصة بهم
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
      debugPrint("❌ خطأ جلب أداء المشرف: $e");
    } finally {
      isLoadingSupervisors = false;
      notifyListeners();
    }
  }

  // دوال الـ Setters المحدثة لضمان استدعاء الـ API الصحيح تلقائياً فور التغيير
  void setArea(String v) {
    selectedArea = v;
    fetchReports();
  }

  void setType(String v) {
    selectedType = v;
    fetchReports();
  }

  void setStatus(String v) {
    selectedStatus = v;
    fetchReports();
  }

  void setPeriod(String v) {
    selectedPeriod = v;
    fetchReports();
  }

  // دوال فلاتر قسم المشرفين لكي لا تتداخل مع فلاتر البلاغات
  void setSupervisor(String v) {
    selectedSupervisor = v;
    fetchSupervisorStats();
  }

  void setSupType(String v) {
    selectedSupType = v;
    fetchSupervisorStats();
  }

  // حسابات الإحصائيات الذكية للبلاغات الحالية
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

  // أفضل 3 مشرفين بناءً على حساب نسبة الإنجاز
  List<String> get topSupervisors {
    if (supervisorsPerformance.isEmpty) return [];
    List<SupervisorPerformanceModel> sorted = List.from(supervisorsPerformance);

    // ترتيب تنازلي حسب نسبة الإنجاز النصية (مثل تحويل "85%" إلى رقم ومقارنته)
    sorted.sort((a, b) {
      double rateA =
          double.tryParse(a.completionRate.replaceAll('%', '')) ?? 0.0;
      double rateB =
          double.tryParse(b.completionRate.replaceAll('%', '')) ?? 0.0;
      return rateB.compareTo(rateA);
    });
    return sorted.take(3).map((s) => s.name).toList();
  }

  // إلغاء البلاغ وتحديث القائمة
  Future<bool> cancelReport(int id, String reason) async {
    final success = await _reportRepository.cancelReport(id, reason);
    if (success) {
      await fetchReports(); // تحديث القائمة فوراً بعد الإلغاء
      await fetchGeneralStats(); // تحديث الإحصائيات أيضاً
    }
    return success;
  }
}
