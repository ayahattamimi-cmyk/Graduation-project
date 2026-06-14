import 'package:dio/dio.dart';

/// يترجم أكواد [DioException] إلى رسائل خطأ عربية سهلة للمستخدم.
class ApiExceptions implements Exception {
  late String message;

  /// يبني [ApiExceptions] عن طريق ربط أنواع [DioException] بالرسائل.
  ApiExceptions.fromDioError(DioException dioError) {
    switch (dioError.type) {
      case DioExceptionType.cancel:
        message = "تم إلغاء الطلب للسيرفر";
        break;
      case DioExceptionType.connectionTimeout:
        message = "انتهت مهلة الاتصال، السيرفر بطيء جداً";
        break;
      case DioExceptionType.receiveTimeout:
        message = "انتهت مهلة استقبال البيانات";
        break;
      case DioExceptionType.badResponse:
        message = _handleError(
          dioError.response?.statusCode,
          dioError.response?.data,
        );
        break;
      case DioExceptionType.sendTimeout:
        message = "انتهت مهلة إرسال البيانات";
        break;
      case DioExceptionType.connectionError:
        message = "لا يوجد اتصال بالإنترنت (تأكد من الشبكة)";
        break;
      default:
        message = "عذراً، حدث خطأ غير متوقع";
        break;
    }
  }

  /// يربط أكواد حالة HTTP برسائل خطأ عربية.
  String _handleError(int? statusCode, dynamic error) {
    switch (statusCode) {
      case 400:
        return 'طلب خاطئ (Bad Request)';
      case 401:
        return 'غير مصرح لك (Unauthorized) - يرجى تسجيل الدخول';
      case 403:
        return 'ليس لديك صلاحية للوصول (Forbidden)';
      case 404:
        return 'المصدر المطلوب غير موجود (Not Found)';
      case 500:
        return 'خطأ داخلي في السيرفر (Internal Server Error)';
      case 502:
        return 'خطأ في بوابة العبور (Bad Gateway)';
      default:
        return 'حدث خطأ مجهول برمز: $statusCode';
    }
  }

  @override
  String toString() => message;
}
