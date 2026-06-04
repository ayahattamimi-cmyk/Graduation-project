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
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with Name and Actions
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 8, 16, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    container.locationName,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: Color(0xFF374151),
                    ),
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
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Column(
              children: [
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: _infoRow(
                        Icons.access_time,
                        "الفترة",
                        container.period,
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
                const SizedBox(height: 8),
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
                        Icons.repeat,
                        "التكرار",
                        "${container.collectionFrequency} مرات",
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 14, color: const Color(0xFF10B981)),
        const SizedBox(width: 6),
        Text(
          "$label: ",
          style: const TextStyle(
            fontSize: 12,
            color: Colors.grey,
            fontWeight: FontWeight.bold,
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(fontSize: 12, color: Color(0xFF4B5563)),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
