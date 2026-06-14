import 'package:flutter/material.dart';

class TopSupervisorsWidget extends StatelessWidget {
  final List<String> supervisors;

  const TopSupervisorsWidget({super.key, required this.supervisors});

  @override
  Widget build(BuildContext context) {
    if (supervisors.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        const Align(
          alignment: Alignment.centerRight,
          child: Text(
            "أفضل 3 مشرفين (حسب نسبة الإنجاز)",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),

        const SizedBox(height: 12),

        ...supervisors.asMap().entries.map((entry) {
          final index = entry.key;
          final name = entry.value;

          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade300),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.02),
                  blurRadius: 5,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: _getRankColor(index).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    "${index + 1}",
                    style: TextStyle(
                      color: _getRankColor(index),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                const SizedBox(width: 12),

                Icon(Icons.person_pin_rounded, color: _getRankColor(index)),

                const SizedBox(width: 10),

                Expanded(
                  child: Text(
                    name,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                    ),
                  ),
                ),

                if (index == 0)
                  const Icon(Icons.stars, color: Colors.amber, size: 20),
              ],
            ),
          );
        }).toList(),
      ],
    );
  }

  /// يعيد لوناً بناءً على مركز الترتيب.
  Color _getRankColor(int index) {
    switch (index) {
      case 0:
        return Colors.orange;
      case 1:
        return Colors.blue;
      case 2:
        return Colors.blueGrey;
      default:
        return Colors.blue;
    }
  }
}
