import 'package:flutter/material.dart';

class StatCard extends StatelessWidget {
  final String title;
  final String? value; // يجي من الباك اند لاحقًا
  final String subtitle; // العبارة اللي تحت
  final IconData icon; // الأيقونة
  final Color color;

  const StatCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    this.value,// required ممكن تكون نل عشان كذا م كتبت
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //هنا الايقونة والعوان
          Row(
            children: [
              Icon(icon, color: color, size: 22),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

         //الرقم
          Text(
            value ?? '--',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),

          const SizedBox(height: 6),

         //الوصف الي تحت
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }
}
