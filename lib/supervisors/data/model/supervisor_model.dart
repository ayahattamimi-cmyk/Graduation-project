import 'area_detail_model.dart';

class SupervisorModel {
  final int id;
  final String name;
  final String type;
  final String area;
  final List<AreaDetailModel> areaDetails;

  SupervisorModel({
    required this.id,
    required this.name,
    required this.type,
    required this.area,
    required this.areaDetails,
    
  });
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'area': area,
      'area_details':
          areaDetails, // تأكد أن الاسم يطابق ما يتوقعه الـ Backend (Laravel)
    };
  }

  factory SupervisorModel.fromJson(Map<String, dynamic> json) {
    return SupervisorModel(
      id: json['id'],
      name: json['name'] ?? '',
      type: json['type'] ?? '',
      area: json['area'] ?? '',
      areaDetails:
          (json['area_details'] as List? ?? [])
              .map((i) => AreaDetailModel.fromJson(i))
              .toList(),
    );
  }
}
