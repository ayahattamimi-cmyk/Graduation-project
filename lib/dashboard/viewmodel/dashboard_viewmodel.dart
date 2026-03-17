import 'package:flutter/material.dart';
import '../data/dashboard_data.dart';

class DashboardViewModel extends ChangeNotifier {

  final DashboardData _data = DashboardData();

  String totalReports = "--";
  String resolvedReports = "--";
  String processingReports = "--";
  String activeAreas = "--";

  bool isLoading = false;

  Future<void> loadStats() async {

    isLoading = true;
    notifyListeners();

    final result = await _data.getStats();

    totalReports = result["totalReports"] ?? "--";
    resolvedReports = result["resolvedReports"] ?? "--";
    processingReports = result["processingReports"] ?? "--";
    activeAreas = result["activeAreas"] ?? "--";

    isLoading = false;
    notifyListeners();

  }

}