import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';
import 'package:web2/core/services/shared_pref.dart';

class DioClient {
  late Dio dio;

  DioClient() {
    dio = Dio(
      BaseOptions(
        baseUrl: 'https://medicalhouse-ye.net/api/',
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        headers: {'Accept': 'application/json'},
      ),
    );

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final String? token =
              await SharedPrefsService.getToken(); // استدعاء مباشر
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
        onError: (e, handler) async {
          if (e.response?.statusCode == 401) {
            debugPrint(
              "🚨 [401 Error]: التوكن قد يكون منتهي الصلاحية أو غير صالح",
            );
            debugPrint("🔗 Path: ${e.requestOptions.path}");
            // سنعطل المسح التلقائي مؤقتاً لنرى هل المشكلة هنا
            // await SharedPrefsService.removeToken();
          }
          return handler.next(e);
        },
      ),
    );
  }
}
