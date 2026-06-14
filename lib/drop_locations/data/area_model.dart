/// يمثل منطقة جغرافية واحدة تحتوي على قائمة من حاويات التجميع ([ContainerModel]).
/// يُستخدم في صفحة مواقع الرفع.
import 'container_model.dart';

class AreaModel {
  final int id;
  final String areaDetails;
  final List<ContainerModel> containers;

  /// ينشئ [AreaModel] بالمعرف وتفاصيل المنطقة والحاويات المحددة.
  AreaModel({
    required this.id,
    required this.areaDetails,
    required this.containers,
  });

  /// ينشئ [AreaModel] من خريطة JSON.
  /// يحاول حل معرف المنطقة من حقل 'id' أولاً؛ إذا كان مفقوداً،
  /// يتراجع إلى 'area_id' من أول حاوية في القائمة.
  factory AreaModel.fromJson(Map<String, dynamic> json) {
    final containersList = (json['containers'] as List?) ?? [];

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
