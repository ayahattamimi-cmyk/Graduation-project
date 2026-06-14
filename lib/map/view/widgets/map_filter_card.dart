import 'package:flutter/material.dart';

/// عنصر بطاقة يوفر مفاتيح تبديل لإظهار البلاغات والحاويات والمناطق.
class MapFilterCard extends StatelessWidget {
  final bool showReports;
  final bool showContainers;
  final bool showZones;
  final Function(String, bool?) onChanged;

  const MapFilterCard({
    Key? key,
    required this.showReports,
    required this.showContainers,
    required this.showZones,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildItem("البلاغات", showReports, (val) => onChanged('reports', val), Colors.red),
          const VerticalDivider(width: 20, indent: 10, endIndent: 10),
          _buildItem("الحاويات", showContainers, (val) => onChanged('containers', val), Colors.blue),
          const VerticalDivider(width: 20, indent: 10, endIndent: 10),
          _buildItem("المناطق", showZones, (val) => onChanged('zones', val), Colors.purple),
        ],
      ),
    );
  }

  /// يبني صف تبديل تصفية مفرد مع خانة اختيار وتسمية.
  Widget _buildItem(String label, bool value, Function(bool?) onToggle, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Checkbox(
          value: value,
          onChanged: onToggle,
          activeColor: color,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        ),
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'Cairo',
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
