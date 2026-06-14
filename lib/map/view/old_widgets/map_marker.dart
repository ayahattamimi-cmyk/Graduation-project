import 'package:flutter/material.dart';

/// عنصر يعرض نقطة علامة ملونة مع تسمية لوسائل إيضاح الخريطة.
class MapMarkerItem extends StatelessWidget {
  final Color color;
  final String label;
  final bool isSquare;

  const MapMarkerItem({
    Key? key,
    required this.color,
    required this.label,
    this.isSquare = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              color: color,
              shape: isSquare ? BoxShape.rectangle : BoxShape.circle,
              borderRadius: isSquare ? BorderRadius.circular(2) : null,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontFamily: 'Cairo',
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}
