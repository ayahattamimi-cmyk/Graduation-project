import 'package:dio/dio.dart';

import '../model/supervisor_model.dart';
import 'model/area_detail_model.dart';
import 'model/statistics_model.dart';
import '../data/supervisor_service.dart';


class SupervisorRepository {
  final SupervisorService _service;

  SupervisorRepository(this._service);

  Future<List<dynamic>> fetchSupervisorPerformance(
    String name,
    String type,
  ) async {
    try {
      // تجهيز البيانات كـ FormData كما يطلب السيرفر
      FormData formData = FormData.fromMap({
        "name": name,
        "type": type == "رفع" ? "Lifting" : "Sweeping", // مطابقة للـ cURL الخاص بالمستخدم
      });

      // استدعاء السيرفس (سنقوم بإضافة هذه الدالة في ملف السيرفس أيضاً)
      final response = await _service.getSupervisorPerformanceReport(formData);

      if (response.data['status'] == 'success') {
        // نرجع القائمة الخام مباشرة عشان نتعامل معها في الفيو مودل ببساطة
        return response.data['data']['supervisors'] as List;
      }
      return [];
    } catch (e) {
      print("❌ Error in Repository: $e");
      return [];
    }
  }

  // تحويل بيانات المشرفين من JSON إلى List<SupervisorModel>
  Future<List<SupervisorModel>> fetchAllSupervisors() async {
    final response = await _service.getAllSupervisors();
    return (response.data['data'] as List)
        .map((json) => SupervisorModel.fromJson(json))
        .toList();
  }

  // تحويل المربعات إلى List<AreaDetailModel>
  Future<List<AreaDetailModel>> fetchAreas(String type) async {
    final response = await _service.getAreas(type);
    return (response.data['data'] as List)
        .map((json) => AreaDetailModel.fromJson(json))
        .toList();
  }

  // جلب الإحصائيات وتحويلها لموديل
  Future<StatisticsModel> fetchStatistics() async {
    final response = await _service.getStatistics();
    return StatisticsModel.fromJson(response.data['data']);
  }

  // تحديث البيانات والتأكد من نجاح العملية
  Future<bool> updateSupervisorInfo(int id, Map<String, dynamic> data) async {
    final response = await _service.updateSupervisor(id, data);
    return response.data['status'] == 'success';
  }

  Future<void> addSupervisor(SupervisorModel supervisor) async {
    // نقوم بتحويل الموديل إلى Map (JSON) قبل الإرسال
    final response = await _service.addSupervisor(supervisor.toJson());

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception("فشل الإرسال للسيرفر");
    }
  }
}
