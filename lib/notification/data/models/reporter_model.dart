class ReporterModel {
  final String name;
  final String phone;

  ReporterModel({required this.name, required this.phone});

  factory ReporterModel.fromJson(Map<String, dynamic> json) {
    return ReporterModel(
      name: json['name'] ?? "لا يوجد اسم",
      phone: json['phone'] ?? "لا يوجد رقم",
    );
  }
}
