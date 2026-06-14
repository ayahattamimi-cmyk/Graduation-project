import 'map_models.dart';
import 'map_service.dart';

/// مستودع يعمل كجسر بين [MapService] و ViewModel.
class WebMapRepository {
  final MapService _mapService;

  WebMapRepository(this._mapService);

  /// يجلب قائمة البلاغات الحية من خدمة الخريطة.
  Future<List<ReportModel>> getLiveReports() async {
    final data = await _mapService.fetchLiveMapData();
    return data['reports'] ?? [];
  }

  /// يجلب قائمة حاويات النفايات من خدمة الخريطة.
  Future<List<ContainerModel>> getContainers() async {
    final data = await _mapService.fetchLiveMapData();
    return data['containers'] ?? [];
  }

  /// يجلب بيانات الخريطة الموحّدة التي تحتوي على البلاغات والحاويات.
  Future<MapDataModel> getMapData() async {
    final data = await _mapService.fetchLiveMapData();
    return MapDataModel(
      reports: data['reports'] ?? [],
      containers: data['containers'] ?? [],
    );
  }

  /// يسترجع قائمة المضلعات الجغرافية من الخدمة.
  Future<List<AreaPolygon>> fetchPolygons() => _mapService.getPolygons();
}
