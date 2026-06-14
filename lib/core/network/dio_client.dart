import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';
import 'package:web2/core/services/shared_pref.dart';

/// يهيئ عميل HTTP [Dio] بعنوان أساسي ومهلات زمنية ومعترض (interceptor)
/// يرفق رمز Bearer تلقائيًا في كل طلب.
class DioClient {
  late Dio dio;

  /// ينشئ [DioClient] بخيارات أساسية ومعترض لرؤوس التوثيق.
  DioClient() {
    dio = Dio(
      BaseOptions(
        baseUrl: 'https://medicalhouse-ye.net/api/',
        connectTimeout: const Duration(seconds: 60),
        receiveTimeout: const Duration(seconds: 60),
        headers: {'Accept': 'application/json'},
      ),
    );

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          if (options.extra['no-auth'] == true) {
            return handler.next(options);
          }

          final String? token = await SharedPrefsService.getToken();
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
        onError: (e, handler) async {
          return handler.next(e);
        },
      ),
    );
  }
}
