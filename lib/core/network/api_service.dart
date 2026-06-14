import 'package:dio/dio.dart';
import 'dio_client.dart';

/// غلاف مركزي لعميل HTTP يوفر وسائط مكتوبة
/// (GET, POST, PUT, DELETE, PATCH) على مثيل مشترك من [Dio].
class ApiService {
  final Dio _dio;

  /// ينشئ [ApiService] مدعومًا بالـ [DioClient] المقدم.
  ApiService(DioClient dioClient) : _dio = dioClient.dio;

  /// يرسل طلب GET إلى [path] المحدد مع بارامترات استعلام ورؤوس اختيارية.
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

  /// يرسل طلب POST. يدعم حمولات JSON و [FormData].
  Future<Response> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? extra,
  }) async {
    return await _dio.post(
      path,
      data: data,
      options: Options(
        headers: headers,
        extra: extra,
        contentType:
            data is FormData ? 'multipart/form-data' : 'application/json',
      ),
    );
  }

  /// يرسل طلب PUT لتحديث مورد موجود.
  Future<Response> put(
    String path, {
    dynamic data,
    Map<String, dynamic>? headers,
  }) async {
    return await _dio.put(path, data: data, options: Options(headers: headers));
  }

  /// يرسل طلب DELETE لحذف مورد.
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

  /// يرسل طلب PATCH للتحديثات الجزئية.
  Future<Response> patch(
    String path, {
    dynamic data,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? extra,
  }) async {
    return await _dio.patch(
      path,
      data: data,
      options: Options(
        headers: headers,
        extra: extra,
        contentType:
            data is FormData ? 'multipart/form-data' : 'application/json',
      ),
    );
  }
}
