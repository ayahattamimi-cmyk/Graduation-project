class AssignmentSuggestionModel {
  final int squareId;
  final String squareLabel;
  final int supervisorId;
  final String supervisorName;
  final int reportsCount;

  AssignmentSuggestionModel({
    required this.squareId,
    required this.squareLabel,
    required this.supervisorId,
    required this.supervisorName,
    required this.reportsCount,
  });

  factory AssignmentSuggestionModel.fromJson(Map<String, dynamic> json) {
    return AssignmentSuggestionModel(
      squareId: json['id'] ?? 0,
      squareLabel: json['label'] ?? "غير محدد",
      supervisorId: json['supervisor_id'] ?? 0,
      supervisorName: json['supervisor_name'] ?? "غير معروف",
      reportsCount: json['reports_count'] ?? 0,
    );
  }
}
