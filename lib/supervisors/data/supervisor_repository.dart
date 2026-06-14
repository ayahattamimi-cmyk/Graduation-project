import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';

import 'model/supervisor_model.dart';
import 'model/area_detail_model.dart';
import 'model/statistics_model.dart';
import '../data/supervisor_service.dart';

class SupervisorRepository {
  final SupervisorService _service;

  SupervisorRepository(this._service);

  /// يجلب بيانات أداء المشرفين مصفاة حسب الاسم والنوع.
  Future<List<dynamic>> fetchSupervisorPerformance(
    String name,
    String type,
  ) async {
    try {
      final Map<String, dynamic> params = {};
      if (name.isNotEmpty) params["name"] = name;
      if (type.isNotEmpty) {
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
      return [];
    }
  }

  /// يجلب جميع المشرفين من الخادم.
  Future<List<SupervisorModel>> fetchAllSupervisors() async {
    final response = await _service.getAllSupervisors();
    return (response.data['data'] as List)
        .map((json) => SupervisorModel.fromJson(json))
        .toList();
  }

  /// يجلب المناطق حسب النوع.
  Future<List<AreaDetailModel>> fetchAreas(String type) async {
    final response = await _service.getAreas(type);
    return (response.data['data'] as List)
        .map((json) => AreaDetailModel.fromJson(json))
        .toList();
  }

  /// يجلب إحصائيات المشرفين.
  Future<StatisticsModel> fetchStatistics() async {
    final response = await _service.getStatistics();
    return StatisticsModel.fromJson(response.data['data']);
  }

  /// يحدث بيانات مشرف ويعيد ما إذا نجح التحديث.
  Future<bool> updateSupervisorInfo(int id, Map<String, dynamic> data) async {
    try {
      final formData = FormData.fromMap(data);
      final response = await _service.updateSupervisor(id, formData);
      return response.data['status'] == 'success';
    } catch (e) {
      return false;
    }
  }

  /// يضيف مشرفاً جديداً عبر API.
  Future<void> addSupervisor(SupervisorModel supervisor) async {
    final response = await _service.addSupervisor(supervisor.toJson());

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception("فشل الإرسال للسيرفر");
    }
  }

  /// الخطوة 1: ينشئ حساب مستخدم على الخادم ويعيد المعرف والرمز المميز.
  Future<Map<String, dynamic>?> createAccountOnServer({
    required String idToken,
    required String name,
    required String role,
  }) async {
    final Map<String, dynamic> body = {
      "idToken": idToken,
      "name": name,
      "role": role,
    };

    final response = await _service.createUser(body, extra: {'no-auth': true});

    if (response.data['status'] == 'success') {
      final data = response.data['data'];
      String? newToken = data?['token'];

      if (data != null && data['user'] != null && data['user']['id'] != null) {
        return {
          'id': int.tryParse(data['user']['id'].toString()),
          'token': newToken,
        };
      }
    }
    return null;
  }

  /// الخطوة 2: يحفظ بيانات المشرف (النوع، المنطقة) على الخادم.
  Future<bool> saveSupervisorDetails({
    required String type,
    required String areaId,
    String? name,
    int? userId,
    String? firebaseToken,
    String? serverToken,
  }) async {
    String mappedType = type;
    if (type == "رفع") mappedType = "lifting";
    if (type == "كنس") mappedType = "sweeping";

    final Map<String, dynamic> body = {
      "type": mappedType,
      "area_id": int.tryParse(areaId) ?? areaId,
      "idToken": firebaseToken,
    };
    if (name != null) {
      body["name"] = name;
    }

    final formData = FormData.fromMap(body);

    final response = await _service.insertInformationUser(
      formData,
      headers:
          serverToken != null ? {'Authorization': 'Bearer $serverToken'} : null,
      extra: {'no-auth': true},
    );

    return response.data['status'] == 'success';
  }
}
