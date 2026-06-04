import 'map_models.dart';
import 'map_service.dart';

class WebMapRepository {
  final MapService _mapService;

  WebMapRepository(this._mapService);

  Future<List<ReportModel>> getLiveReports() async {
    final data = await _mapService.fetchLiveMapData();
    return data['reports'] ?? [];
  }

  Future<List<ContainerModel>> getContainers() async {
    final data = await _mapService.fetchLiveMapData();
    return data['containers'] ?? [];
  }

  /// جلب البيانات الموحدة
  Future<MapDataModel> getMapData() async {
    final data = await _mapService.fetchLiveMapData();
    return MapDataModel(
      reports: data['reports'] ?? [],
      containers: data['containers'] ?? [],
    );
  }

  // دالة المضلعات من الخدمة
  Future<List<AreaPolygon>> fetchPolygons() => _mapService.getPolygons();
}
