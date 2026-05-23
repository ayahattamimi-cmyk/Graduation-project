import 'map_models.dart';
import 'map_service.dart';

class MapRepository {
  final MapService _mapService;

  MapRepository(this._mapService);

  Future<List<ReportMarker>> fetchReports() => _mapService.getReports();
  Future<List<CollectionPoint>> fetchContainers() =>
      _mapService.getContainers();
  Future<List<AreaPolygon>> fetchPolygons() => _mapService.getPolygons();
}
