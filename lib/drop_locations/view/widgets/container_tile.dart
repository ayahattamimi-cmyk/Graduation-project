import 'package:flutter/material.dart';
import '../../data/container_data.dart';

class ContainerTile extends StatelessWidget {
  final ContainerData container;
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
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 6,
      ),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          /// العنوان + أزرار
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [

              Text(
                container.nameContainer,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),

              Row(
                children: [

                  /// حذف
                  IconButton(
                    onPressed: onDelete,
                    icon: const Icon(
                      Icons.delete_outline,
                      color: Colors.red,
                    ),
                  ),

                  /// تعديل
                  IconButton(
                    onPressed: onEdit,
                    icon: const Icon(Icons.edit_outlined),
                  ),

                ],
              ),
            ],
          ),

          const SizedBox(height: 6),

          Text("الشارع: ${container.nameStreet}"),
          Text("النوع: ${container.type}"),
          Text("الفترة: ${container.period}"),
          Text("التصنيف: ${container.classification}"),

          const SizedBox(height: 6),

          Row(
            children: [
              Text("مرات الرفع: ${container.collectionFrequency}"),
              const SizedBox(width: 12),
              Text("اليوم: ${container.collectionDay}"),
            ],
          ),

          Text("وقت البداية: ${container.startTime}"),
        ],
      ),
    );
  }
}