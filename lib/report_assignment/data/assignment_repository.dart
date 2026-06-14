import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';
import 'package:web2/report_assignment/data/assignment_model.dart';
import 'assignment_service.dart';

class AssignmentRepository {
  final AssignmentService _service;

  AssignmentRepository(this._service);

  /// يجلب اقتراح تعيين تلقائي للبلاغ المحدد.
  Future<AssignmentSuggestionModel?> fetchSuggestion(int reportId) async {
    try {
      final response = await _service.getSuggestion(reportId);
      if (response.statusCode == 200 && response.data['status'] == 'success') {
        return AssignmentSuggestionModel.fromJson(response.data['data']);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  /// يجلب تفاصيل المربع يدوياً بواسطة معرف المربع ونوع العمل.
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
      return null;
    }
  }

  /// يرسل التعيين النهائي لبلاغ إلى مشرف.
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
      return false;
    } catch (e) {
      return false;
    }
  }
}
