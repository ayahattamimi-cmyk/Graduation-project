import 'container_model.dart';

class AreaModel {
  final String areaDetails;
  final List<ContainerModel> containers;

  AreaModel({required this.areaDetails, required this.containers});

  //  : أضفنا هذه الدالة لتحويل JSON السيرفر إلى مودل جاهز
  factory AreaModel.fromJson(Map<String, dynamic> json) {
    return AreaModel(
      areaDetails: json['area_details'] ?? '',
      // هنا نقوم بتحويل قائمة الحاويات الموجودة داخل كل مربع
      containers:
          (json['containers'] as List)
              .map((item) => ContainerModel.fromJson(item))
              .toList(),
    );
  }
}
