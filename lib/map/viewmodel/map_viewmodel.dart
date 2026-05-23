import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../data/map_repository.dart';
import '../data/map_models.dart';

class MapViewModel extends ChangeNotifier {
  final MapRepository _repository;

  static const LatLng seiyunCenter = LatLng(15.943, 48.786);

  GoogleMapController? mapController;

  bool isSatellite = false;
  bool showReports = true;
  bool showContainers = true;
  bool showAreas = true;

  Set<Marker> markers = {};
  Set<Polygon> polygons = {};

  bool isLoading = false;
  String? errorMessage;

  List<ReportMarker> _rawReports = [];
  List<CollectionPoint> _rawContainers = [];

  LatLng? selectedLocation;

  MapViewModel(this._repository) {
    _init();
  }

  Future<void> _init() async {
    isLoading = true;
    notifyListeners();

    try {
      await loadPolygons();
      await _fetchInitialData();
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> _fetchInitialData() async {
    _rawReports = await _repository.fetchReports();
    _rawContainers = await _repository.fetchContainers();
    updateMarkers();
  }

  void onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  void toggleSatellite() {
    isSatellite = !isSatellite;
    notifyListeners();
  }

  void toggleReports() {
    showReports = !showReports;
    updateMarkers();
  }

  void toggleContainers() {
    showContainers = !showContainers;
    updateMarkers();
  }

  void toggleAreas() {
    showAreas = !showAreas;
    notifyListeners();
  }

  void selectLocation(LatLng point) {
    selectedLocation = point;
    updateMarkers();
    notifyListeners();
  }

  void updateMarkers() {
    final Set<Marker> newMarkers = {};

    if (showReports) {
      for (var report in _rawReports) {
        newMarkers.add(
          Marker(
            markerId: MarkerId("report_${report.id}"),
            position: LatLng(report.lat, report.lng),
            icon: BitmapDescriptor.defaultMarkerWithHue(
              BitmapDescriptor.hueRed,
            ),
            infoWindow: InfoWindow(
              title: "بلاغ: ${report.status}",
              snippet: "موقعه: ${report.lat}, ${report.lng}",
            ),
          ),
        );
      }
    }

    if (showContainers) {
      for (var container in _rawContainers) {
        newMarkers.add(
          Marker(
            markerId: MarkerId("container_${container.name}"),
            position: LatLng(container.lat, container.lng),
            icon: BitmapDescriptor.defaultMarkerWithHue(
              BitmapDescriptor.hueBlue,
            ),
            infoWindow: InfoWindow(
              title: container.name,
              snippet: "نوع: ${container.type}",
            ),
          ),
        );
      }
    }

    if (selectedLocation != null) {
      newMarkers.add(
        Marker(
          markerId: const MarkerId("selected"),
          position: selectedLocation!,
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRose),
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

  Future<void> loadPolygons() async {
    try {
      final areaPolygons = await _repository.fetchPolygons();
      final Set<Polygon> loadedPolygons = {};

      final colors = [Colors.purple, Colors.green, Colors.orange, Colors.blue];

      for (int i = 0; i < areaPolygons.length; i++) {
        final area = areaPolygons[i];
        final color = colors[i % colors.length];

        loadedPolygons.add(
          Polygon(
            polygonId: PolygonId("zone$i"),
            points: area.points.map((p) => LatLng(p[0], p[1])).toList(),
            fillColor: color.withOpacity(0.25),
            strokeColor: color,
            strokeWidth: 3,
          ),
        );
      }

      polygons = loadedPolygons;
      notifyListeners();
    } catch (e) {
      debugPrint("Error loading polygons: $e");
    }
  }
}
