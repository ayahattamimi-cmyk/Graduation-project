import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapViewModel extends ChangeNotifier {

  static const LatLng seiyunCenter =
  LatLng(15.943, 48.786);

  GoogleMapController? mapController;

  bool isSatellite = false;

  bool showReports = true;
  bool showContainers = true;
  bool showAreas = true;

  Set<Marker> markers = {};
  Set<Polygon> polygons = {};

  LatLng? selectedLocation;

  MapViewModel() {
    loadPolygons();
    loadMarkers();
  }

  void onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  /// satellite
  void toggleSatellite() {
    isSatellite = !isSatellite;
    notifyListeners();
  }

  /// reports
  void toggleReports() {
    showReports = !showReports;
    loadMarkers();
  }

  /// containers
  void toggleContainers() {
    showContainers = !showContainers;
    loadMarkers();
  }

  /// areas
  void toggleAreas() {
    showAreas = !showAreas;
    notifyListeners();
  }

  /// اختيار موقع
  void selectLocation(LatLng point) {

    selectedLocation = point;

    loadMarkers();

    notifyListeners();
  }

  /// MARKERS
  void loadMarkers() {

    final Set<Marker> newMarkers = {};

    /// البلاغات
    if (showReports) {

      newMarkers.add(
        Marker(
          markerId: const MarkerId("report1"),

          position: const LatLng(15.944, 48.785),

          icon: BitmapDescriptor.defaultMarkerWithHue(
            BitmapDescriptor.hueRed,
          ),

          onTap: () {},

          infoWindow: const InfoWindow(
            title: "بلاغ عاجل",
            snippet: "حي السحيل",
          ),
        ),
      );
    }

    /// الحاويات
    if (showContainers) {

      newMarkers.add(
        Marker(
          markerId: const MarkerId("container1"),

          position: const LatLng(15.940, 48.789),

          icon: BitmapDescriptor.defaultMarkerWithHue(
            BitmapDescriptor.hueBlue,
          ),

          infoWindow: const InfoWindow(
            title: "حاوية ثابتة",
            snippet: "مربع 1",
          ),
        ),
      );
    }

    /// الموقع المختار
    if (selectedLocation != null) {

      newMarkers.add(
        Marker(
          markerId: const MarkerId("selected"),

          position: selectedLocation!,

          icon: BitmapDescriptor.defaultMarkerWithHue(
            BitmapDescriptor.hueRose,
          ),

          infoWindow: InfoWindow(
            title: "الموقع المختار",

            snippet:
            "${selectedLocation!.latitude}, ${selectedLocation!.longitude}",
          ),
        ),
      );
    }

    markers = newMarkers;

    notifyListeners();
  }

  /// polygons
  Future<void> loadPolygons() async {

    final String jsonString =
    await rootBundle.loadString(
      'assets/json/boundary_sayun.json',
    );

    final data = jsonDecode(jsonString);

    final features = data["features"];

    final Set<Polygon> loadedPolygons = {};

    int i = 0;

    for (var feature in features) {

      final coords =
      feature["geometry"]["coordinates"][0];

      final List<LatLng> points = coords.map<LatLng>((e) {

        return LatLng(
          e[1],
          e[0],
        );

      }).toList();

      final colors = [
        Colors.purple,
        Colors.green,
        Colors.orange,
        Colors.blue,
      ];

      final color = colors[i % colors.length];

      loadedPolygons.add(

        Polygon(
          polygonId: PolygonId("zone$i"),

          points: points,

          fillColor:
          color.withOpacity(0.25),

          strokeColor: color,

          strokeWidth: 3,
        ),
      );

      i++;
    }

    polygons = loadedPolygons;

    notifyListeners();
  }
}