class NotificationsData {

  Future<List<Map<String, dynamic>>> getNotifications() async {

    await Future.delayed(const Duration(seconds: 1));

    return [
      {
        "id": "#2025-001",
        "category": "نظافة الشوارع",
        "priority": "عاجل",
        "days": "منذ 57 يوم",
        "status": "جديد",
      },
      {
        "id": "#2025-002",
        "category": "تركيب المخلفات",
        "priority": "متوسط",
        "days": "منذ 57 يوم",
        "status": "جديد",
      },
    ];
  }

}