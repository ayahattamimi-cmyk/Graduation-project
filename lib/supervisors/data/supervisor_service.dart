import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import '../model/supervisor_model.dart';

class SupervisorService {
  final Dio? _dio;

  SupervisorService([this._dio]);

  // جلب جميع المشرفين (الموك/الجديد)
  Future<List<SupervisorModel>> getSupervisors() async {
    final response = await http.get(
      Uri.parse("API_LINK_HERE"),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      List list = data["supervisors"];
      return list
          .map((e) => SupervisorModel.fromJson(e))
          .toList();
    }

    throw Exception("Failed to load supervisors");
  }

  // جلب جميع المشرفين
  Future<Response> getAllSupervisors() async {
    return await _dio!.get('showSupervisors');
  }

  // جلب المربعات حسب النوع (كنس أو رفع)
  Future<Response> getAreas(String type) async {
    return await _dio!.get('showAreas/$type');
  }

  // تحديث بيانات مشرف معين
  Future<Response> updateSupervisor(int id, Map<String, dynamic> data) async {
    return await _dio!.post('updateSupervisors/$id', data: data);
  }

  // جلب الإحصائيات (CountStatistics)
  Future<Response> getStatistics() async {
    return await _dio!.get('CountStatistics');
  }

  // جلب مشرفي الرفع فقط
  Future<Response> getLiftingSupervisors() async {
    return await _dio!.get('getLiftingSupervisors');
  }

  // جلب مشرفي الكنس فقط
  Future<Response> getSweepingSupervisors() async {
    return await _dio!.get('getSweepingSupervisors');
  }

  Future<Response> addSupervisor(Map<String, dynamic> data) async {
    return await _dio!.post('addSupervisors', data: data);
  }

  Future<Response> getSupervisorPerformanceReport(FormData data) async {
    return await _dio!.post('supervisor-report', data: data);
  }
}