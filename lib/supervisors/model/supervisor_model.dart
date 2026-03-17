class SupervisorModel {
  final int id;
  final String name;
  final String type;
  final String area;
  final String squareName;
  final String? schedule;

  /// تفاصيل الكنس
  final String? startStreet;
  final String? endStreet;

  /// تفاصيل الرفع
  final String? period;
  final String? startTime;
  final String? endTime;

  SupervisorModel({
    required this.id,
    required this.name,
    required this.type,
    required this.area,
    required this.squareName,
    this.startStreet,
    this.endStreet,
    this.period,
    this.startTime,
    this.endTime,
    this.schedule,
  });

  /// تحويل JSON إلى Model
  factory SupervisorModel.fromJson(Map<String, dynamic> json) {
    final detail = json["area_details"][0];

    return SupervisorModel(
      id: json["id"],
      name: json["name"],
      type: json["type"],
      area: json["area"],
      squareName: detail["square_name"],

      startStreet: detail["name_start_street"],
      endStreet: detail["name_end_street"],

      period: detail["period"],
      startTime: detail["start_time"],
      endTime: detail["end_time"],
    );
  }

  /// تحويل Model إلى JSON (مفيد عند الإضافة أو التعديل)
  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "type": type,
      "area": area,
      "square_name": squareName,
      "name_start_street": startStreet,
      "name_end_street": endStreet,
      "period": period,
      "start_time": startTime,
      "end_time": endTime,
    };
  }

  /// نسخ الكائن مع تعديل بعض القيم
  SupervisorModel copyWith({
    String? name,
    String? type,
    String? area,
    String? squareName,
    String? startStreet,
    String? endStreet,
    String? period,
    String? startTime,
    String? endTime,
  }) {
    return SupervisorModel(
      id: id,
      name: name ?? this.name,
      type: type ?? this.type,
      area: area ?? this.area,
      squareName: squareName ?? this.squareName,
      startStreet: startStreet ?? this.startStreet,
      endStreet: endStreet ?? this.endStreet,
      period: period ?? this.period,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
    );
  }
}