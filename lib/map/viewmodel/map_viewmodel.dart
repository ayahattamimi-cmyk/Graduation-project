import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';

import '../data/dummy_map_data.dart';
import '../data/map_models.dart';

class MapViewModel extends ChangeNotifier {

  bool showReports = true;
  bool showContainers = true;
  bool showAreas = true;
  LatLng? selectedLocation;
  List<ReportMarker> reports = dummyReports;
  List<CollectionPoint> containers = dummyContainers;
  List<AreaPolygon> polygons = dummyPolygons;

  void toggleReports(bool value) {
    showReports = value;
    notifyListeners();
  }

  void toggleContainers(bool value) {
    showContainers = value;
    notifyListeners();
  }

  void toggleAreas(bool value) {
    showAreas = value;
    notifyListeners();
  }
}