class ReportModel {
  final int id;
  final double lat;
  final double lng;
  final String status;
  final String date;
  final String reporterName;

  ReportModel({
    required this.id,
    required this.lat,
    required this.lng,
    required this.status,
    required this.date,
    required this.reporterName,
  });

  factory ReportModel.fromJson(Map<String, dynamic> json) {
    return ReportModel(
      id: json['id'] ?? 0,
      lat: double.tryParse(json['lat'].toString()) ?? 15.943,
      lng: double.tryParse(json['lng'].toString()) ?? 48.786,
      status: json['status'] ?? '',
      date: json['created_at'] ?? '',
      reporterName: json['reporter_name'] ?? 'مستخدم مجهول',
    );
  }
}

class MapDataModel {
  final List<ReportModel> reports;
  final List<ContainerModel> containers;

  MapDataModel({required this.reports, required this.containers});

  factory MapDataModel.fromJson(Map<String, dynamic> json) {
    return MapDataModel(
      reports:
          (json['reports'] as List?)
              ?.map((i) => ReportModel.fromJson(i))
              .toList() ??
          [],
      containers:
          (json['containers'] as List?)
              ?.map((i) => ContainerModel.fromJson(i))
              .toList() ??
          [],
    );
  }
}

class ContainerModel {
  final String id;
  final String locationName;
  final double lat;
  final double lng;
  final String type;

  ContainerModel({
    required this.id,
    required this.locationName,
    required this.lat,
    required this.lng,
    required this.type,
  });

  factory ContainerModel.fromJson(Map<String, dynamic> json) {
    return ContainerModel(
      id: json['id'].toString(),
      locationName: json['location_name'] ?? '',
      lat: double.tryParse(json['lat'].toString()) ?? 15.943,
      lng: double.tryParse(json['lng'].toString()) ?? 48.786,
      type: json['type'] ?? '',
    );
  }
}

class AreaPolygon {
  final String name;
  final List<List<double>> points;

  AreaPolygon({required this.name, required this.points});
}
