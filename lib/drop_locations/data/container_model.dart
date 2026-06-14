class ContainerModel {
  final int? id;
  final String locationName;
  final String nameStreet;
  final String type;
  final String period;
  final int collectionFrequency;
  final String collectionDay;
  final String startTime;
  final String classification;
  final String? areaDetails;
  final int? areaId;
  final double? lat;
  final double? lng;

  /// ينشئ [ContainerModel] بالخصائص المحددة.
  ContainerModel({
    this.id,
    required this.locationName,
    required this.nameStreet,
    required this.type,
    required this.period,
    required this.collectionFrequency,
    required this.collectionDay,
    required this.startTime,
    required this.classification,
    this.areaDetails,
    this.areaId,
    this.lat,
    this.lng,
  });

  /// يعيد نسخة من هذا [ContainerModel] مع استبدال الحقول المحددة.
  ContainerModel copyWith({
    int? id,
    String? locationName,
    String? nameStreet,
    String? type,
    String? period,
    int? collectionFrequency,
    String? collectionDay,
    String? startTime,
    String? classification,
    String? areaDetails,
    int? areaId,
    double? lat,
    double? lng,
  }) {
    return ContainerModel(
      id: id ?? this.id,
      locationName: locationName ?? this.locationName,
      nameStreet: nameStreet ?? this.nameStreet,
      type: type ?? this.type,
      period: period ?? this.period,
      collectionFrequency: collectionFrequency ?? this.collectionFrequency,
      collectionDay: collectionDay ?? this.collectionDay,
      startTime: startTime ?? this.startTime,
      classification: classification ?? this.classification,
      areaDetails: areaDetails ?? this.areaDetails,
      areaId: areaId ?? this.areaId,
      lat: lat ?? this.lat,
      lng: lng ?? this.lng,
    );
  }

  /// ينشئ [ContainerModel] من خريطة JSON.
  /// يعالج [collection_day] عندما يكون قائمة بربط القيم.
  factory ContainerModel.fromJson(Map<String, dynamic> json) {
    String collectionDayValue;
    if (json['collection_day'] is List) {
      collectionDayValue = (json['collection_day'] as List).join(', ');
    } else {
      collectionDayValue = json['collection_day']?.toString() ?? '';
    }

    return ContainerModel(
      id: json['id'],
      locationName: json['location_name'] ?? json['name_container'] ?? '',
      nameStreet: json['name_street'] ?? '',
      type: json['type'] ?? '',
      period: json['period'] ?? '',
      collectionFrequency: json['collection_frequency'] ?? 0,
      collectionDay: collectionDayValue,
      startTime: json['start_time'] ?? '',
      classification: json['classification'] ?? '',
      areaDetails: json['area_details'],
      areaId: json['area_id'],
      lat: json['lat'] != null ? double.tryParse(json['lat'].toString()) : null,
      lng: json['lng'] != null ? double.tryParse(json['lng'].toString()) : null,
    );
  }

  /// يسلسل هذا [ContainerModel] إلى خريطة JSON.
  Map<String, dynamic> toJson() {
    return {
      'location_name': locationName,
      'name_street': nameStreet,
      'type': type,
      'classification': classification,
      if (areaId != null) 'area_id': areaId,
      'collection_frequency': collectionFrequency,
      'collection_day[]':
          collectionDay.contains("يومياً")
              ? [
                "الأحد",
                "الاثنين",
                "الثلاثاء",
                "الأربعاء",
                "الخميس",
                "الجمعة",
                "السبت",
              ]
              : collectionDay
                  .split(',')
                  .map((e) => e.trim())
                  .where((e) => e.isNotEmpty)
                  .toList(),
      'start_time': startTime,
      'period': period,
      if (lat != null) 'lat': lat,
      if (lng != null) 'lng': lng,
    };
  }
}
