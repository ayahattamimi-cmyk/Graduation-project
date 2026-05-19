import 'package:flutter/material.dart';
import 'package:web2/reports/data/models/report_model.dart';
import 'package:web2/reports/data/models/SupervisorPerformanceModel.dart';
import 'package:web2/reports/data/models/report_statistics_model.dart';
import 'package:web2/supervisors/data/model/area_detail_model.dart';
import '../data/report_repository.dart';
import '../../supervisors/data/supervisor_repository.dart';

class ReportViewModel extends ChangeNotifier {
  final ReportRepository _reportRepository;
  final SupervisorRepository _supervisorRepository;

  ReportViewModel(this._reportRepository, this._supervisorRepository);

  // --- البيانات الحقيقية ---
  List<ReportModel> reports = [];
  List<SupervisorPerformanceModel> supervisorsPerformance = [];
  List<AreaDetailModel> areaObjects = [];
  ReportStatisticsModel? generalStats;
  bool isLoading = false;

  // --- فلاتر البلاغات ---
  String selectedArea = "جميع المناطق";
  String selectedType = "جميع الأنواع";
  String selectedStatus = "جميع الحالات";
  String selectedPeriod = "آخر أسبوع";

  // --- فلاتر أداء المشرفين ---
  String selectedSupervisor = "جميع المشرفين";
  String selectedSupType = "جميع الأنواع";

  // قوائم الاختيارات
  List<String> areas = ["جميع المناطق"]; // سيتم ملؤها من السيرفر
  List<String> types = ["جميع الأنواع", "رفع", "كنس"];
  List<String> status = ["جميع الحالات", "تم الحل", "قيد الانتظار", "قيد التنفيذ"];
  List<String> periods = ["آخر أسبوع", "آخر شهر", "آخر سنة"];
  List<String> supervisors = ["جميع المشرفين"];

  // دالة التهيئة الشاملة
  void loadAllData() {
    fetchReports();
    fetchSupervisorsNames();
    fetchAreas();
    fetchGeneralStats();
  }

  // جلب المناطق من السيرفر (إعادة استخدام من قسم المشرفين)
  Future<void> fetchAreas() async {
    try {
      // نطلب مناطق الرفع مثلاً أو حسب الحاجة
      final result = await _supervisorRepository.fetchAreas("lifting");
      areaObjects = result;
      areas = ["جميع المناطق", ...result.map((e) => e.label ?? e.name ?? e.id.toString())];
      notifyListeners();
    } catch (e) {
      debugPrint("❌ خطأ جلب المناطق: $e");
    }
  }

  // جلب الإحصائيات العامة
  Future<void> fetchGeneralStats() async {
    try {
      generalStats = await _reportRepository.getGeneralStats();
      notifyListeners();
    } catch (e) {
      debugPrint("❌ خطأ جلب الإحصائيات العامة: $e");
    }
  }

  // 1. جلب بلاغات التقارير
  Future<void> fetchReports() async {
    isLoading = true;
    notifyListeners();
    try {
      debugPrint("📡 [Reports] Fetching with: Area:$selectedArea, Type:$selectedType, Status:$selectedStatus");
      reports = await _reportRepository.getFilteredReports(
        areaId: selectedArea == "جميع المناطق" ? null : selectedArea,
        status: selectedStatus == "جميع الحالات" ? null : selectedStatus,
        reportType: selectedType == "جميع الأنواع" ? null : selectedType,
        period: _mapPeriodToApi(selectedPeriod),
      );
      debugPrint("✅ [Reports] Found ${reports.length} reports");
    } catch (e) {
      debugPrint("❌ [Reports] Error: $e");
    } finally {
      isLoading = false;
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

  // 3. جلب أداء مشرف معين
  Future<void> fetchSupervisorStats() async {
    if (selectedSupervisor == "جميع المشرفين") {
      supervisorsPerformance = [];
      notifyListeners();
      return;
    }

    isLoading = true;
    notifyListeners();
    try {
      final result = await _supervisorRepository.fetchSupervisorPerformance(
        selectedSupervisor,
        selectedSupType,
      );
      supervisorsPerformance = result
          .map((e) => SupervisorPerformanceModel.fromJson(e))
          .toList();
    } catch (e) {
      debugPrint("❌ خطأ جلب أداء المشرف: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // الدوال المساعدة للتحديث من الواجهة
  void setArea(String v) {
    selectedArea = v;
    // إذا كانت "جميع المناطق" نرسل null، وإلا نرسل الـ id الحقيقي
    if (v == "جميع المناطق") {
      fetchReports();
    } else {
      // البحث عن الـ id المقابل للاسم المختار
      final areaObj = areaObjects.firstWhere(
        (e) => (e.label ?? e.name ?? e.id.toString()) == v,
        orElse: () => areaObjects[0],
      );
      // تحديث الفلترة بالـ ID الحقيقي
      _fetchReportsWithId(areaObj.id.toString());
    }
  }

  Future<void> _fetchReportsWithId(String id) async {
    isLoading = true;
    notifyListeners();
    try {
      reports = await _reportRepository.getFilteredReports(
        areaId: id,
        status: selectedStatus == "جميع الحالات" ? null : selectedStatus,
        reportType: selectedType == "جميع الأنواع" ? null : selectedType,
        period: _mapPeriodToApi(selectedPeriod),
      );
    } catch (e) {
      debugPrint("❌ خطأ جلب البلاغات بالـ ID: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
  
  void setType(String v) { selectedType = v; fetchReports(); }
  void setStatus(String v) { selectedStatus = v; fetchReports(); }
  void setPeriod(String v) { selectedPeriod = v; fetchReports(); }
  
  void setSupervisor(String v) {
    selectedSupervisor = v;
    fetchSupervisorStats();
  }

  void setSupType(String v) {
    selectedSupType = v;
    fetchSupervisorStats();
  }

  // الإحصائيات (تدعم مسميات السيرفر المختلفة)
  int get total => reports.length;
  int get solved => reports.where((e) => e.status == "تم الحل" || e.status == "محلول").length;
  int get pending => total - solved;

  String _mapPeriodToApi(String p) {
    if (p == "آخر أسبوع") return "last_week";
    if (p == "آخر شهر") return "last_month";
    return "last_year";
  }

  // أفضل 3 مشرفين بناءً على الإنجاز
  List<String> get topSupervisors {
    if (supervisorsPerformance.isEmpty) return [];
    List<SupervisorPerformanceModel> sorted = List.from(supervisorsPerformance);
    sorted.sort((a, b) => b.completionRate.compareTo(a.completionRate));
    return sorted.take(3).map((s) => s.name).toList();
  }
}
