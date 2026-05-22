import 'map_models.dart';

final List<ReportMarker> dummyReports = [

  ReportMarker(
    id: '1',
    lat: 15.943,
    lng: 48.786,
    status: 'عاجل',
  ),

  ReportMarker(
    id: '2',
    lat: 15.939,
    lng: 48.782,
    status: 'تم التنفيذ',
  ),
];

final List<CollectionPoint> dummyContainers = [

  CollectionPoint(
    name: 'حاوية 1',
    lat: 15.945,
    lng: 48.784,
    type: 'ثابت',
  ),

  CollectionPoint(
    name: 'حاوية 2',
    lat: 15.941,
    lng: 48.779,
    type: 'مستحدث',
  ),
];

final List<AreaPolygon> dummyPolygons = [

  AreaPolygon(
    name: 'مربع 1',
    points: [
      [15.940, 48.780],
      [15.946, 48.780],
      [15.946, 48.786],
      [15.940, 48.786],
    ],
  ),
];