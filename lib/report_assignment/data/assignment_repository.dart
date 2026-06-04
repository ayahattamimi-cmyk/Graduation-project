import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';
import 'package:web2/report_assignment/data/assignment_model.dart';
import 'assignment_service.dart';

class AssignmentRepository {
  final AssignmentService _service;

  AssignmentRepository(this._service);

  // جلب الاقتراح التلقائي بناءً على موقع البلاغ
  Future<AssignmentSuggestionModel?> fetchSuggestion(int reportId) async {
    try {
      final response = await _service.getSuggestion(reportId);
      if (response.statusCode == 200 && response.data['status'] == 'success') {
        return AssignmentSuggestionModel.fromJson(response.data['data']);
      }
      return null;
    } catch (e) {
      debugPrint("❌ Error in fetchSuggestion: $e");
      return null;
    }
  }

  // جلب البيانات التفصيلية للمربع (يدوياً) حسب النوع
  Future<AssignmentSuggestionModel?> fetchSquareDetails(
    int squareId,
    String type,
  ) async {
    try {
      final response = await _service.getSquareDetails(squareId, type);
      if (response.statusCode == 200 && response.data['status'] == 'success') {
        return AssignmentSuggestionModel.fromJson(response.data['data']);
      }
      return null;
    } catch (e) {
      debugPrint("❌ Error in fetchSquareDetails: $e");
      return null;
    }
  }

  // إرسال طلب التعيين النهائي للسيرفر
  Future<bool> sendAssignment({
    required int reportId,
    required int supervisorId,
  }) async {
    try {
      final formData = FormData.fromMap({
        "report_id": reportId,
        "supervisor_id": supervisorId,
      });

      final response = await _service.postAssignment(formData);
      return response.data['status'] == 'success';
    } on DioException catch (e) {
      debugPrint("❌ DioException in sendAssignment: ${e.message}");
      return false;
    } catch (e) {
      debugPrint("❌ Error in sendAssignment: $e");
      return false;
    }
  }
}
