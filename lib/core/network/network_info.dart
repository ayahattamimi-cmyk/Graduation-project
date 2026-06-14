import 'package:connectivity_plus/connectivity_plus.dart';

/// واجهة مجردة للتحقق من حالة الاتصال بالإنترنت.
abstract class NetworkInfo {
  /// يعيد true عندما يكون الجهاز متصلًا بالشبكة.
  Future<bool> get isConnected;
}

/// تطبيق ملموس لـ [NetworkInfo] باستخدام حزمة connectivity_plus.
class NetworkInfoImpl implements NetworkInfo {
  final Connectivity connectivity;

  /// ينشئ [NetworkInfoImpl] مع مثيل [Connectivity] المحدد.
  NetworkInfoImpl(this.connectivity);

  @override
  Future<bool> get isConnected async {
    final result = await connectivity.checkConnectivity();
    return !result.contains(ConnectivityResult.none);
  }
}
