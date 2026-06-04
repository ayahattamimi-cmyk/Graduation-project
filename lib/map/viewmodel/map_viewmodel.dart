import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import '../data/map_models.dart';
import '../data/map_repository.dart';
import '../utils/map_marker_helper.dart';

class WebMapViewModel extends ChangeNotifier {
  final WebMapRepository _repository;
  static const LatLng seiyunCenter = LatLng(15.9429, 48.7844);
  GoogleMapController? mapController;

  MapDataModel? _mapData;
  MapDataModel? get mapData => _mapData;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  // Custom Icons
  BitmapDescriptor? reportIconPending;
  BitmapDescriptor? reportIconProcessing;
  BitmapDescriptor? reportIconSolved;
  BitmapDescriptor? reportIconCancelled;
  BitmapDescriptor? containerIcon;

  bool _showReports = true;
  bool get showReports => _showReports;

  bool _showContainers = true;
  bool get showContainers => _showContainers;

  bool _showZones = true;
  bool get showZones => _showZones;

  bool _isSatellite = false;
  bool get isSatellite => _isSatellite;

  final Set<Polygon> _polygons = {};
  Set<Polygon> get polygons => _polygons;

  final Set<Marker> _markers = {};
  Set<Marker> get markers => _markers;

  String? selectedZoneName;
  String? selectedZoneType;

  // Focus Report ID (from assignment page)
  int? focusReportId;

  // Picker Mode logic
  bool isPickerMode = false;
  LatLng? pickedLocation;

  WebMapViewModel(this._repository);

  Future<void> initWebMap({int? focusId}) async {
    _isLoading = true;
    focusReportId = focusId;
    notifyListeners();

    try {
      // تم تعديل الأيقونات لتُحمل بالكامل أولاً كـ Canvas
      await _loadIcons();
      await _loadZones();
      await fetchMapData();

      if (focusReportId != null) {
        focusOnReport(focusReportId!);
      }
    } catch (e) {
      debugPrint("Error initializing map: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> _loadIcons() async {
    const double iconSize = 45.0; // كبر الحجم قليلاً لتظهر الدبابيس بوضوح

    // 1. الحاويات: نريد لها خلفية دائرية بيضاء لتبرز (نضع hasBackground: true)
    containerIcon = await MapMarkerHelper.getMarkerIconFromIcon(
      Icons.delete_outline,
      const Color.fromARGB(255, 12, 100, 38),
      iconSize,
      hasBackground: true,
    );

    // 2. البلاغات: دبابيس شفافة وبدون أي خلفية بيضاء (نتركها false الافتراضية)
    reportIconPending = await MapMarkerHelper.getMarkerIconFromIcon(
      Icons.location_on,
      Colors.orange,
      iconSize,
    );

    reportIconProcessing = await MapMarkerHelper.getMarkerIconFromIcon(
      Icons.location_on,
      Colors.cyan,
      iconSize,
    );

    reportIconSolved = await MapMarkerHelper.getMarkerIconFromIcon(
      Icons.location_on,
      Colors.green,
      iconSize,
    );

    reportIconCancelled = await MapMarkerHelper.getMarkerIconFromIcon(
      Icons.location_on,
      Colors.red,
      iconSize,
    );
  }

  Future<void> _loadZones() async {
    _polygons.clear();
    await _loadGeoJson('assets/json/boundary_sayun.json', isBoundary: true);
    await _loadGeoJson('assets/json/upload_zones.json', zoneType: "مربع رفع");
    await _loadGeoJson('assets/json/sweep_zones.json', zoneType: "مربع كنس");
  }

  Future<void> fetchMapData() async {
    _isLoading = true;
    notifyListeners();

    try {
      _mapData = await _repository.getMapData();
      _applyFiltersAndRefresh();
    } catch (e) {
      debugPrint("Error fetching map data: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void _applyFiltersAndRefresh() {
    _markers.clear();
    if (_mapData == null) return;

    bool isIsolated = isPickerMode || focusReportId != null;

    if (_showReports && !isPickerMode) {
      for (var report in _mapData!.reports) {
        if (focusReportId != null && report.id != focusReportId) continue;
        if (report.lat == 0.0 || report.lng == 0.0) continue;

        // تنظيف الفراغات لضمان دقة الفلترة من الـ API
        final status = report.status.trim();
        BitmapDescriptor icon;

        // اختيار الأيقونة بناءً على النص المنظف
        if (status.contains("تم الحل") || status.contains("إنجاز")) {
          icon =
              reportIconSolved ??
              BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen);
        } else if (status.contains("قيد المعالجة")) {
          icon =
              reportIconProcessing ??
              BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure);
        } else if (status.contains("ملغي") || status.contains("ملغية")) {
          icon =
              reportIconCancelled ??
              BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed);
        } else {
          icon =
              reportIconPending ??
              BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange);
        }

        _markers.add(
          Marker(
            markerId: MarkerId("report_${report.id}"),
            position: LatLng(report.lat, report.lng),
            icon: icon,
            infoWindow: InfoWindow(
              title: "بلاغ رقم #${report.id}",
              snippet: "الحالة: ${report.status}",
            ),
          ),
        );
      }
    }

    if (_showContainers && !isIsolated) {
      for (var container in _mapData!.containers) {
        if (container.lat == 0.0 || container.lng == 0.0) continue;

        _markers.add(
          Marker(
            markerId: MarkerId("container_${container.id}"),
            position: LatLng(container.lat, container.lng),
            icon:
                containerIcon ??
                BitmapDescriptor.defaultMarkerWithHue(
                  BitmapDescriptor.hueGreen,
                ),
            infoWindow: InfoWindow(
              title: container.locationName,
              snippet: "النوع: ${container.type}",
            ),
          ),
        );
      }
    }

    if (isPickerMode && pickedLocation != null) {
      _markers.add(
        Marker(
          markerId: const MarkerId("PICKED_LOCATION"),
          position: pickedLocation!,
          icon: BitmapDescriptor.defaultMarkerWithHue(
            BitmapDescriptor.hueAzure,
          ),
          infoWindow: const InfoWindow(title: "الموقع المختار"),
        ),
      );
    }
  }

  void focusOnReport(int id) {
    if (_mapData == null) return;
    try {
      final report = _mapData!.reports.firstWhere((r) => r.id == id);
      mapController?.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(target: LatLng(report.lat, report.lng), zoom: 17.5),
        ),
      );
      mapController?.showMarkerInfoWindow(MarkerId("report_${report.id}"));
    } catch (e) {
      debugPrint("Report with id $id not found for focusing.");
    }
  }

  void toggleReports() {
    _showReports = !_showReports;
    _applyFiltersAndRefresh();
    notifyListeners();
  }

  void toggleContainers() {
    _showContainers = !_showContainers;
    _applyFiltersAndRefresh();
    notifyListeners();
  }

  void toggleZones() {
    _showZones = !_showZones;
    notifyListeners();
  }

  void toggleSatellite() {
    _isSatellite = !_isSatellite;
    notifyListeners();
  }

  void onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  void moveToCenter() {
    mapController?.animateCamera(
      CameraUpdate.newCameraPosition(
        const CameraPosition(target: seiyunCenter, zoom: 14.0),
      ),
    );
  }

  void zoomIn() {
    mapController?.animateCamera(CameraUpdate.zoomIn());
  }

  void zoomOut() {
    mapController?.animateCamera(CameraUpdate.zoomOut());
  }

  Future<void> _loadGeoJson(
    String path, {
    bool isBoundary = false,
    String zoneType = "",
  }) async {
    try {
      final String jsonString = await rootBundle.loadString(path);
      final Map<String, dynamic> geoJson = jsonDecode(jsonString);
      final List<dynamic> features = geoJson['features'];

      for (var feature in features) {
        if (feature['geometry']['type'] == 'Polygon') {
          final List<dynamic> coordinates =
              feature['geometry']['coordinates'][0];
          List<LatLng> points =
              coordinates.map((coord) => LatLng(coord[1], coord[0])).toList();
          final String name =
              feature['properties']['Name'] ??
              feature['properties']['name'] ??
              'منطقة غير مسماة';

          final Color zoneColor =
              isBoundary ? Colors.redAccent : _getUniqueColor(name);
          final Color fill =
              isBoundary
                  ? zoneColor.withOpacity(0.0)
                  : zoneColor.withOpacity(0.2);
          final Color stroke =
              isBoundary ? zoneColor.withOpacity(0.8) : zoneColor;

          _polygons.add(
            Polygon(
              polygonId: PolygonId("${name}_$path"),
              points: points,
              fillColor: fill,
              strokeColor: stroke,
              strokeWidth: isBoundary ? 2 : 1,
              consumeTapEvents: !isPickerMode,
              onTap: () {
                if (!isPickerMode) {
                  selectedZoneName = name;
                  selectedZoneType = isBoundary ? "الحدود الإدارية" : zoneType;
                  notifyListeners();
                }
              },
            ),
          );
        }
      }
    } catch (e) {
      debugPrint('Error loading GeoJSON $path: $e');
    }
  }

  Color _getUniqueColor(String name) {
    final List<Color> palette = [
      Colors.blue,
      Colors.green,
      Colors.orange,
      Colors.purple,
      Colors.cyan,
      Colors.indigo,
      Colors.teal,
      Colors.amber,
      Colors.pink,
      Colors.deepOrange,
    ];
    return palette[name.hashCode.abs() % palette.length];
  }

  void clearSelectedZone() {
    selectedZoneName = null;
    selectedZoneType = null;
    notifyListeners();
  }

  void enablePickerMode() async {
    isPickerMode = true;
    pickedLocation = null;
    await _loadZones();
    _applyFiltersAndRefresh();
    notifyListeners();
  }

  void disablePickerMode() async {
    isPickerMode = false;
    pickedLocation = null;
    await _loadZones();
    _applyFiltersAndRefresh();
    notifyListeners();
  }

  void setPickedLocation(LatLng location) {
    if (!isPickerMode) return;
    pickedLocation = location;
    _applyFiltersAndRefresh();
    notifyListeners();
  }

  @override
  void dispose() {
    mapController = null;
    super.dispose();
  }
}
