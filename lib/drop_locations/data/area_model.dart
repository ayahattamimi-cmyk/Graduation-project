///   يمثّل منطقة جغرافية واحدة تحتوي على قائمة بنود الجمع ([ContainerModel]).
///   يُستخدم في صفحة مواقع التجميع.
import 'container_model.dart';

class AreaModel {
  final int id;
  final String areaDetails;
  final List<ContainerModel> containers;

  AreaModel({
    required this.id,
    required this.areaDetails,
    required this.containers,
  });

  factory AreaModel.fromJson(Map<String, dynamic> json) {
    final containersList = (json['containers'] as List?) ?? [];

    // محاولة ذكية لإيجاد ID المنطقة:
    // 1. نبحث عنه في الحقل المباشر 'id'
    // 2. إذا لم يوجد، نبحث عنه داخل أول حاوية في المنطقة 'area_id'
    int foundId = json['id'] ?? 0;
    if (foundId == 0 && containersList.isNotEmpty) {
      foundId = containersList.first['area_id'] ?? 0;
    }

    return AreaModel(
      id: foundId,
      areaDetails: json['area_details'] ?? '',
      containers:
          containersList.map((item) => ContainerModel.fromJson(item)).toList(),
    );
  }
}
