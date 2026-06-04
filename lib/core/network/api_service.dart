import 'package:dio/dio.dart';
import 'dio_client.dart';

class ApiService {
  final Dio _dio;

  ApiService(DioClient dioClient) : _dio = dioClient.dio;

  /// دالة لجلب البيانات
  Future<Response> get(
    String path, {
    Map<String, dynamic>? query,
    Map<String, dynamic>? headers,
  }) async {
    return await _dio.get(
      path,
      queryParameters: query,
      options: Options(headers: headers),
    );
  }

  /// دالة لإرسال بيانات جديدة
  /// تدعم إرسال النصوص (JSON) أو الملفات (FormData)
  Future<Response> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? extra, // إضافة هذا المعامل
  }) async {
    return await _dio.post(
      path,
      data: data,
      options: Options(
        headers: headers,
        extra: extra, // تمريره لـ Dio
        // تحديد نوع المحتوى تلقائياً بناءً على البيانات المرسلة
        contentType:
            data is FormData ? 'multipart/form-data' : 'application/json',
      ),
    );
  }

  /// دالة لتعديل بيانات موجودة
  Future<Response> put(
    String path, {
    dynamic data,
    Map<String, dynamic>? headers,
  }) async {
    return await _dio.put(path, data: data, options: Options(headers: headers));
  }

  /// دالة للحذف
  Future<Response> delete(
    String path, {
    Map<String, dynamic>? data,
    Map<String, dynamic>? headers,
  }) async {
    return await _dio.delete(
      path,
      data: data,
      options: Options(headers: headers),
    );
  }

  /// دالة التعديل الجزئي (PATCH)
  Future<Response> patch(
    String path, {
    dynamic data,
    Map<String, dynamic>? headers,
  }) async {
    return await _dio.patch(
      path,
      data: data,
      options: Options(
        headers: headers,
        contentType:
            data is FormData ? 'multipart/form-data' : 'application/json',
      ),
    );
  }
}
