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
    this.value,
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
          // [تعديل هنا] استخدام Expanded لمنع الـ Overflow في العناوين الطويلة
          Row(
            children: [
              Icon(icon, color: color, size: 22),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 1, // إبقاء النص في سطر واحد
                  overflow:
                      TextOverflow
                          .ellipsis, // وضع نقاط (...) إذا كان النص طويلاً
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // الرقم - مع إضافة حماية بسيطة للمساحة
          FittedBox(
            // [إضافة] تجعل الرقم يصغر حجمه تلقائياً إذا كان كبيراً جداً بدل الانفجار
            fit: BoxFit.scaleDown,
            child: Text(
              value ?? '--',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ),

          const SizedBox(height: 6),

          // الوصف الي تحت
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 12, // تصغير بسيط ليناسب الويب
              color: Colors.grey.shade600,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
