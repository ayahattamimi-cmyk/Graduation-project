class ReportMarker {
  final String id;
  final double lat;
  final double lng;
  final String status;

  ReportMarker({
    required this.id,
    required this.lat,
    required this.lng,
    required this.status,
  });
}

class CollectionPoint {
  final String name;
  final double lat;
  final double lng;
  final String type;

  CollectionPoint({
    required this.name,
    required this.lat,
    required this.lng,
    required this.type,
  });
}

class AreaPolygon {
  final String name;
  final List<List<double>> points;

  AreaPolygon({
    required this.name,
    required this.points,
  });
}