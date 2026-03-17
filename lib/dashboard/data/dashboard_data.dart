class DashboardData {

  Future<Map<String, String>> getStats() async {

    await Future.delayed(const Duration(seconds: 1));

    return {
      "totalReports": "120",
      "resolvedReports": "90",
      "processingReports": "30",
      "activeAreas": "12",
    };

  }

}