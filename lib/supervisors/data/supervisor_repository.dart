import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';

import 'model/supervisor_model.dart';
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
      // إرسال type فقط إذا تم اختيار نوع محدد — إذا كان فارغاً نرسل الكل
      final Map<String, dynamic> params = {};
      if (name.isNotEmpty) params["name"] = name;
      if (type.isNotEmpty) {
        // الـ API يتوقع lowercase: "lifting" أو "sweeping"
        if (type.toLowerCase() == "lifting" || type == "رفع") {
          params["type"] = "lifting";
        } else if (type.toLowerCase() == "sweeping" || type == "كنس") {
          params["type"] = "sweeping";
        }
      }

      FormData formData = FormData.fromMap(params);

      final response = await _service.getSupervisorPerformanceReport(formData);

      if (response.data['status'] == 'success') {
        return response.data['data']['supervisors'] as List;
      }
      return [];
    } catch (e) {
      debugPrint("⚠️ Error fetching supervisor performance: $e");
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

  // تحديث البيانات والتأكد من نجاح العملية (باستخدام FormData كما يتطلب السيرفر)
  Future<bool> updateSupervisorInfo(int id, Map<String, dynamic> data) async {
    try {
      final formData = FormData.fromMap(data);
      final response = await _service.updateSupervisor(id, formData);
      return response.data['status'] == 'success';
    } catch (e) {
      debugPrint("❌ Error updating supervisor: $e");
      return false;
    }
  }

  Future<void> addSupervisor(SupervisorModel supervisor) async {
    // نقوم بتحويل الموديل إلى Map (JSON) قبل الإرسال
    final response = await _service.addSupervisor(supervisor.toJson());

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception("فشل الإرسال للسيرفر");
    }
  }

  // الخطوة الأولى: إنشاء/تسجيل دخول المشرف (عبر رابط login)
  // نرجع خريطة تحتوي على الـ ID والتوكن الجديد
  Future<Map<String, dynamic>?> createAccountOnServer({
    required String idToken,
    required String name,
    required String role,
  }) async {
    debugPrint("📤 [Step 1] Sending to login: Name: $name, Role: $role");

    final Map<String, dynamic> body = {
      "idToken": idToken,
      "name": name,
      "role": role,
    };

    final response = await _service.createUser(body, extra: {'no-auth': true});

    debugPrint("🌐 [Step 1] Login Response: ${response.data}");

    if (response.data['status'] == 'success') {
      final data = response.data['data'];
      String? newToken = data?['token']; // استخراج التوكن الجديد (مثلاً 39|...)

      if (data != null && data['user'] != null && data['user']['id'] != null) {
        return {
          'id': int.tryParse(data['user']['id'].toString()),
          'token': newToken,
        };
      }
    }
    return null;
  }

  // الخطوة الثانية: ربط المشرف بالمنطقة ونوع العمل (تتطلب توكن المشرف الجديد)
  Future<bool> saveSupervisorDetails({
    required String type,
    required String areaId,
    int? userId,
    String? firebaseToken,
    String? serverToken,
  }) async {
    // التأكد من إرسال النوع بالإنجليزية كما يطلبه السيرفر
    String mappedType = type;
    if (type == "رفع") mappedType = "lifting";
    if (type == "كنس") mappedType = "sweeping";

    final Map<String, dynamic> body = {
      "type": mappedType,
      "area_id": int.tryParse(areaId) ?? areaId,
      "idToken": firebaseToken, // توكن فايربيس في الجسم
    };

    final formData = FormData.fromMap(body);

    // توكن الباك إيند في العنوان
    final response = await _service.insertInformationUser(
      formData,
      headers:
          serverToken != null ? {'Authorization': 'Bearer $serverToken'} : null,
      extra: {'no-auth': true},
    );

    debugPrint("🌐 [Step 2 - New Token Mode] Response: ${response.data}");

    return response.data['status'] == 'success';
  }
}
