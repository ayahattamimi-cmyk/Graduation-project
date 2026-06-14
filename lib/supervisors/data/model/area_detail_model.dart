class AreaDetailModel {
  final int id;
  final String? squareName;
  final String? nameStartStreet;
  final String? nameEndStreet;
  final String? square;
  final String? name;
  final String? label;
  final String? period;
  final String? startTime;
  final String? endTime;

  AreaDetailModel({
    required this.id,
    this.squareName,
    this.nameStartStreet,
    this.nameEndStreet,
    this.square,
    this.name,
    this.label,
    this.period,
    this.startTime,
    this.endTime,
  });

  /// ينشئ [AreaDetailModel] من خريطة JSON.
  factory AreaDetailModel.fromJson(Map<String, dynamic> json) {
    return AreaDetailModel(
      id: json['id'],
      squareName: json['square_name'],
      nameStartStreet: json['name_start_street'],
      nameEndStreet: json['name_end_street'],
      square: json['square'],
      name: json['name'],
      label: json['label'],
      period: json['period'],
      startTime: json['start_time'],
      endTime: json['end_time'],
    );
  }
}
