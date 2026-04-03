import 'package:flutter/material.dart';
import '../data/area_data.dart';
import '../data/container_data.dart';

class DropLocationsViewModel extends ChangeNotifier {
  List<AreaData> areas = [];

  void loadMockData() {
    areas = [
      AreaData(
        areaDetails: "مربع 1 - السوق العام",
        containers: [
          ContainerData(
            id: 1,
            nameContainer: "حاوية أ",
            nameStreet: "نور الوحدة",
            type: "ثابت",
            period: "صباحي",
            collectionFrequency: 2,
            collectionDay: "daily",
            startTime: "08:00",
            classification: "رئيسي",
          ),
          ContainerData(
            id: 2,
            nameContainer: "حاوية ب",
            nameStreet: "السوق",
            type: "ثابت",
            period: "مسائي",
            collectionFrequency: 1,
            collectionDay: "daily",
            startTime: "13:30",
            classification: "فرعي",
          ),
        ],
      ),
    ];

    notifyListeners();
  }
}