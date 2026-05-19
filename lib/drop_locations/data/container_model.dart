class ContainerModel {
  final int? id;
  final String nameContainer;
  final String nameStreet;
  final String type;
  final String period;
  final int collectionFrequency;
  final String collectionDay;
  final String startTime;
  final String classification;
  final String? areaDetails;

  ContainerModel({
    this.id,
    required this.nameContainer,
    required this.nameStreet,
    required this.type,
    required this.period,
    required this.collectionFrequency,
    required this.collectionDay,
    required this.startTime,
    required this.classification,
    this.areaDetails,
  });
  ContainerModel copyWith({
    int? id,
    String? nameContainer,
    String? nameStreet,
    String? type,
    String? period,
    int? collectionFrequency,
    String? collectionDay,
    String? startTime,
    String? classification,
    String? areaDetails,
  }) {
    return ContainerModel(
      id: id ?? this.id,
      nameContainer: nameContainer ?? this.nameContainer,
      nameStreet: nameStreet ?? this.nameStreet,
      type: type ?? this.type,
      period: period ?? this.period,
      collectionFrequency: collectionFrequency ?? this.collectionFrequency,
      collectionDay: collectionDay ?? this.collectionDay,
      startTime: startTime ?? this.startTime,
      classification: classification ?? this.classification,
      areaDetails: areaDetails ?? this.areaDetails,
    );
  }

  // كود الـ fromJson الخاص بكِ سليم تماماً ويتطابق مع Postman
  factory ContainerModel.fromJson(Map<String, dynamic> json) {
    return ContainerModel(
      id: json['id'],
      nameContainer: json['name_container'] ?? '',
      nameStreet: json['name_street'] ?? '',
      type: json['type'] ?? '',
      period: json['period'] ?? '',
      collectionFrequency: json['collection_frequency'] ?? 0,
      collectionDay: json['collection_day'] ?? '',
      startTime: json['start_time'] ?? '',
      classification: json['classification'] ?? '',
      areaDetails: json['area_details'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name_container': nameContainer,
      'name_street': nameStreet,
      'type': type,
      'area_details': areaDetails,
      'period': period,
      'collection_frequency': collectionFrequency,
      'collection_day': collectionDay,
      'start_time': startTime,
      'classification': classification,
      if (areaDetails != null) 'area_details': areaDetails,
    };
  }
}
