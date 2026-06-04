import 'package:flutter/foundation.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:web2/core/network/api_service.dart';
import 'map_models.dart';

class MapService {
  final ApiService _apiService;

  MapService(this._apiService);

  /// 🌐 جلب البلاغات والحاويات معاً في طلب واحد لتوفير الأداء والـ Network
  Future<Map<String, dynamic>> fetchLiveMapData() async {
    try {
      final response = await _apiService.get('getMapData');
      if (response.statusCode == 200 && response.data != null) {
        final resBody = response.data;
        if (resBody['success'] == 'success' && resBody['data'] != null) {
          final innerData = resBody['data'];

          var reportsList = innerData['reports'] as List? ?? [];
          List<ReportModel> reports =
              reportsList.map((e) => ReportModel.fromJson(e)).toList();

          var containersList = innerData['containers'] as List? ?? [];
          List<ContainerModel> containers =
              containersList.map((e) => ContainerModel.fromJson(e)).toList();

          return {'reports': reports, 'containers': containers};
        }
      }
    } catch (e) {
      debugPrint("❌ Error fetching map data from Laravel: $e");
    }
    return {'reports': <ReportModel>[], 'containers': <ContainerModel>[]};
  }

  /// 📂 قراءة وفك ملفات الـ GeoJSON الثلاثة المحلية للمناطق والحدود
  Future<List<AreaPolygon>> getPolygons() async {
    List<AreaPolygon> allPolygons = [];

    final localFiles = [
      'assets/json/boundary_sayun.json',
      'assets/json/sweep_zones.json',
      'assets/json/upload_zones.json',
    ];

    for (var filePath in localFiles) {
      try {
        final String jsonString = await rootBundle.loadString(filePath);
        final data = jsonDecode(jsonString);
        final features = data["features"] as List? ?? [];

        for (var feature in features) {
          final geometry = feature["geometry"];
          if (geometry != null && geometry["type"] == "Polygon") {
            final coords = geometry["coordinates"][0];
            final List<List<double>> points =
                (coords as List)
                    .map(
                      (e) => [
                        double.parse(e[1].toString()),
                        double.parse(e[0].toString()),
                      ],
                    )
                    .toList();

            allPolygons.add(
              AreaPolygon(
                name:
                    feature["properties"]["name"] ??
                    (feature["properties"]["Name"] ?? "منطقة جغرافيّة"),
                points: points,
              ),
            );
          }
        }
      } catch (e) {
        debugPrint("⚠️ خطأ أو ملف غير موجود $filePath: $e");
      }
    }
    return allPolygons;
  }
}
