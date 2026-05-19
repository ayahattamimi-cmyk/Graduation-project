import 'package:dio/dio.dart';

class DashboardService {
  final Dio _dio;
  DashboardService(this._dio);

  Future<Response> getDashboardData() async {
    // بما أن Postman نجح مع GET، سنستخدم GET هنا
    return await _dio.get('admin/dashboard-stats');
  }
}
