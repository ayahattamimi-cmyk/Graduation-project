import 'package:flutter/material.dart';
import '../../core/network/api_service.dart';
import '../data/dashboard_repository.dart';
import '../data/dashboard_service.dart';
import '../data/dashboard_model.dart';
import '../../core/network/api_service.dart';
import '../../core/network/dio_client.dart';
import '../../core/network/api_service.dart';
class DashboardViewModel extends ChangeNotifier {

  final DashboardRepository _repository =
  DashboardRepository(
    DashboardService(
      DioClient().dio,
    ),
  );

  DashboardModel? dashboardData;

  String totalReports = "--";
  String resolvedReports = "--";
  String processingReports = "--";
  String activeAreas = "--";

  bool isLoading = false;

  Future<void> loadStats() async {

    isLoading = true;
    notifyListeners();

    try {

      totalReports =
          dashboardData?.statistics.totalReports.toString() ?? "--";

      resolvedReports =
          dashboardData?.statistics.resolved.count.toString() ?? "--";

      processingReports =
          dashboardData?.statistics.inProgress.count.toString() ?? "--";

      activeAreas =
          dashboardData?.topAreas.length.toString() ?? "--";

    }

    catch (e) {

      debugPrint(
        "Dashboard Error: $e",
      );
    }

    isLoading = false;
    notifyListeners();
  }
}