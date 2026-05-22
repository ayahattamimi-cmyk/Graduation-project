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
      print("❌ Error in fetchSuggestion: $e");
      return null;
    }
  }

  // إرسال طلب التعيين النهائي للسيرفر
  Future<bool> sendAssignment({
    required int reportId,
    required int supervisorId,
    required String workType,
  }) async {
    try {
      final formData = FormData.fromMap({
        "report_id": reportId,
        "supervisor_id": supervisorId,
        "work_type": workType, // نرسل نوع العمل المختار (sweeping / lifting)
      });

      final response = await _service.postAssignment(formData);
      return response.data['status'] == 'success';
    } on DioException catch (e) {
      print("❌ DioException in sendAssignment: ${e.message}");
      if (e.response != null) {
        print("📁 Status Code: ${e.response?.statusCode}");
        print("📁 Response Data: ${e.response?.data}");
      }
      return false;
    } catch (e) {
      print("❌ Error in sendAssignment: $e");
      return false;
    }
  }
}
