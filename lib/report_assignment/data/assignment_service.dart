import 'package:dio/dio.dart';

class AssignmentService {
  final Dio _dio;
  AssignmentService(this._dio);

  // جلب المربع المقترح بناءً على إحداثيات البلاغ
  Future<Response> getSuggestion(int reportId) async {
    return await _dio.get('report-square/$reportId');
  }

  // إنشاء عملية التعيين (ربط البلاغ بمشرف)
  Future<Response> postAssignment(FormData data) async {
    return await _dio.post('AssignmenCreate', data: data);
  }

  // جلب كل المشرفين (في حال أراد المدير تغيير المشرف المقترح)
  Future<Response> getAllSupervisors() async {
    return await _dio.get('showSupervisors');
  }
}
