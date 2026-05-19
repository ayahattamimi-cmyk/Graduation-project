import 'package:flutter/material.dart';

class TopSupervisorsWidget extends StatelessWidget {
  final List<String> supervisors;

  const TopSupervisorsWidget({
    super.key,
    required this.supervisors,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [

        /// 🔹 العنوان
        Align(
          alignment: Alignment.centerRight,
          child: const Text(
            "أفضل 3 مشرفين",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),

        const SizedBox(height: 12),

        /// 🔹 عرض أول 3 فقط
        ...supervisors.take(3).toList().asMap().entries.map((entry) {
          final index = entry.key;
          final name = entry.value;

          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Row(
              children: [

                /// رقم الترتيب (1 - 2 - 3)
                Container(
                  width: 30,
                  height: 30,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    "${index + 1}",
                    style: const TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                const SizedBox(width: 12),

                /// أيقونة
                const Icon(Icons.person, color: Colors.blue),

                const SizedBox(width: 10),

                /// الاسم
                Text(
                  name,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }
}