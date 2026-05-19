import 'package:flutter/material.dart';
import '../data/notification_data.dart';

class NotificationsViewModel extends ChangeNotifier {

  final NotificationsData _data = NotificationsData();

  List<Map<String, dynamic>> notifications = [];

  bool isLoading = false;

  Future<void> loadNotifications() async {

    isLoading = true;
    notifyListeners();

    notifications = await _data.getNotifications();

    isLoading = false;
    notifyListeners();

  }

}