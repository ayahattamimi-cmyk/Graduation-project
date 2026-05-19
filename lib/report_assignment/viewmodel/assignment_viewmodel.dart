import 'package:flutter/material.dart';
import '../data/assignment_repository.dart'; // استيراد الريبوزيتوري الجديد
import '../data/assignment_model.dart'; // استيراد موديل التوجيه

class AssignmentViewModel extends ChangeNotifier {
  // 1. التعديل: تمرير الريبوزيتوري عبر الـ Constructor للاتصال بالسيرفر
  final AssignmentRepository _repository;
  AssignmentViewModel(this._repository);

  // --- البيانات الديناميكية القادمة من السيرفر ---
  AssignmentSuggestionModel? suggestion;
  bool isLoading = false;

  // المتغيرات التي تقرأها الواجهة مباشرة
  String selectedArea = "";
  String supervisorName = "";
  int reportsCount = 0;

  // القيم الافتراضية المعتمدة في السيرفر (sweeping للكنس، lifting للرفع)
  String selectedWorkType = "sweeping";
  final List<String> workTypes = ["sweeping", "lifting"];

  // 2. التعديل: دالة جلب الاقتراح التلقائي بناءً على إحداثيات وموقع البلاغ (GET)
  // يتم استدعاؤها في صفحة التفاصيل عند الضغط على زر التوجيه (قبل الانتقال)
  Future<void> loadAssignmentSuggestion(int reportId) async {
    isLoading = true;
    notifyListeners(); // إشعار الواجهة بالتحميل

    try {
      // جلب البيانات من قاعدة البيانات عبر Laravel API
      suggestion = await _repository.fetchSuggestion(reportId);

      if (suggestion != null) {
        // تعبئة البيانات المقترحة تلقائياً "على الجاهز" للمدير
        selectedArea = suggestion!.squareLabel; // مثل: "مربع 8 - السحيل وشحوح2"
        supervisorName = suggestion!.supervisorName; // مثل: "أمين علي بن سالم"
        reportsCount = suggestion!.reportsCount; // عدد البلاغات الحالية بالمربع
      }
    } catch (e) {
      debugPrint("❌ فشل جلب اقتراح التوجيه من السيرفر: $e");
    } finally {
      isLoading = false;
      notifyListeners(); // إشعار الواجهة بانتهاء التحميل وعرض البيانات
    }
  }

  // 3. التعديل: دالة تحديث نوع العمل (كنس / رفع) من القائمة المنسدلة
  void setWorkType(String value) {
    selectedWorkType = value;
    notifyListeners();
  }

  // 4. التعديل: إرسال طلب التعيين الفعلي والنهائي للسيرفر (POST)
  // تأخذ رقم البلاغ لتوثيق العملية في قاعدة البيانات
  Future<bool> sendAssignment(int reportId) async {
    if (suggestion == null) return false;

    isLoading = true;
    notifyListeners();

    try {
      // إرسال البيانات للريبوزيتوري لتجهيز الـ FormData والـ POST
      final success = await _repository.sendAssignment(
        reportId: reportId,
        supervisorId: suggestion!.supervisorId, // نرسل الـ ID الرقمي للمشرف كما يطلبه السيرفر
        workType: selectedWorkType, // نرسل نوع العمل المختار (sweeping / lifting)
      );
      return success;
    } catch (e) {
      debugPrint("❌ فشل عملية التعيين النهائية: $e");
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
