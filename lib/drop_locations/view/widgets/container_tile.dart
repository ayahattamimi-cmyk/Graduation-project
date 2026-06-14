import 'package:flutter/material.dart';
import '../../data/container_model.dart';

class ContainerTile extends StatelessWidget {
  final ContainerModel container;
  final VoidCallback onDelete;
  final VoidCallback onEdit;

  const ContainerTile({
    super.key,
    required this.container,
    required this.onDelete,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    final bool isDaily = container.collectionDay.contains("يومياً");
    final List<String> days =
        isDaily
            ? ["يومياً"]
            : container.collectionDay
                .split(',')
                .map((e) => e.trim())
                .where((e) => e.isNotEmpty)
                .toList();

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 8, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        container.locationName,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 17,
                          color: Color(0xFF1F2937),
                        ),
                      ),
                      if (container.areaDetails != null &&
                          container.areaDetails!.isNotEmpty)
                        const SizedBox(height: 4),
                      if (container.areaDetails != null &&
                          container.areaDetails!.isNotEmpty)
                        Text(
                          container.areaDetails!,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.blue.shade700,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    IconButton(
                      onPressed: onEdit,
                      icon: const Icon(Icons.edit_outlined, size: 20),
                      color: Colors.blue.shade600,
                      tooltip: 'تعديل',
                    ),
                    IconButton(
                      onPressed: onDelete,
                      icon: const Icon(Icons.delete_outline, size: 20),
                      color: Colors.red.shade400,
                      tooltip: 'حذف',
                    ),
                  ],
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: _infoRow(
                        Icons.streetview,
                        "الشارع",
                        container.nameStreet,
                      ),
                    ),
                    Expanded(
                      child: _infoRow(
                        Icons.category_outlined,
                        "النوع",
                        container.type,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),

                Row(
                  children: [
                    Expanded(
                      child: _infoRow(
                        Icons.label_outline,
                        "التصنيف",
                        container.classification,
                      ),
                    ),
                    Expanded(
                      child: _infoRow(
                        Icons.access_time,
                        "الفترة",
                        container.period,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),

                Row(
                  children: [
                    Expanded(
                      child: _infoRow(
                        Icons.schedule,
                        "وقت البداية",
                        container.startTime.isNotEmpty
                            ? container.startTime.length >= 5
                                ? container.startTime.substring(0, 5)
                                : container.startTime
                            : '-',
                      ),
                    ),
                    Expanded(
                      child: _infoRow(
                        Icons.repeat,
                        "عدد مرات الرفع",
                        "${container.collectionFrequency} ${_frequencySuffix(container.collectionFrequency)}",
                      ),
                    ),
                  ],
                ),

                if (days.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  const Text(
                    "أيام الرفع:",
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children:
                        days.map((day) {
                          return Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.green.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(
                                color: Colors.green.withValues(alpha: 0.3),
                              ),
                            ),
                            child: Text(
                              _translate(day),
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.green.shade700,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          );
                        }).toList(),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// يترجم قيمة إنجليزية إلى ما يعادلها بالعربية.
  String _translate(String value) {
    switch (value.toLowerCase()) {
      case "daily":
        return "يومياً";
      case "morning":
        return "صباحي";
      case "evening":
        return "مسائي";
      case "fixed":
        return "ثابتة";
      case "new":
        return "مستحدثة";
      case "primary":
        return "رئيسي";
      case "secondary":
        return "ثانوي";
      case "sunday":
        return "الأحد";
      case "monday":
        return "الاثنين";
      case "tuesday":
        return "الثلاثاء";
      case "wednesday":
        return "الأربعاء";
      case "thursday":
        return "الخميس";
      case "friday":
        return "الجمعة";
      case "saturday":
        return "السبت";
      default:
        return value;
    }
  }

  /// يعيد اللاحقة العربية المناسبة لعدد مرات التكرار.
  String _frequencySuffix(int count) {
    if (count == 1) return "مرة";
    if (count == 2) return "مرتين";
    return "مرات";
  }

  /// ينشئ صفاً بأيقونة وتسمية وقيمة لعرض معلومات الحاوية.
  Widget _infoRow(IconData icon, String label, String value) {
    final displayValue = _translate(value);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        children: [
          Icon(icon, size: 16, color: const Color(0xFF10B981)),
          const SizedBox(width: 8),
          Text(
            "$label: ",
            style: const TextStyle(
              fontSize: 13,
              color: Colors.grey,
              fontWeight: FontWeight.bold,
            ),
          ),
          Expanded(
            child: Text(
              displayValue.isNotEmpty ? displayValue : '-',
              style: const TextStyle(
                fontSize: 13,
                color: Color(0xFF1F2937),
                fontWeight: FontWeight.w600,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
