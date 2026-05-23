import 'map_models.dart';

import 'dummy_map_data.dart';
import 'dart:convert';
import 'package:flutter/services.dart';

class MapService {
  Future<List<ReportMarker>> getReports() async {
    // Simulate API call
    await Future.delayed(const Duration(milliseconds: 500));
    return dummyReports;
  }

  Future<List<CollectionPoint>> getContainers() async {
    // Simulate API call
    await Future.delayed(const Duration(milliseconds: 500));
    return dummyContainers;
  }

  Future<List<AreaPolygon>> getPolygons() async {
    // This could also load from assets
    final String jsonString = await rootBundle.loadString(
      'assets/json/boundary_sayun.json',
    );
    final data = jsonDecode(jsonString);
    final features = data["features"];

    List<AreaPolygon> polygons = [];
    for (var feature in features) {
      final coords = feature["geometry"]["coordinates"][0];
      final List<List<double>> points =
          (coords as List)
              .map((e) => [e[1] as double, e[0] as double])
              .toList();
      polygons.add(
        AreaPolygon(
          name: feature["properties"]["name"] ?? "Area",
          points: points,
        ),
      );
    }
    return polygons;
  }
}
