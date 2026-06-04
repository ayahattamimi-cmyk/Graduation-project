import 'package:flutter/material.dart';

class MapFilterChip extends StatelessWidget {

  final String label;
  final Color color;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const MapFilterChip({
    super.key,
    required this.label,
    required this.color,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {

    return InkWell(

      onTap: onTap,

      borderRadius: BorderRadius.circular(20),

      child: AnimatedContainer(

        duration: const Duration(milliseconds: 200),

        padding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 10,
        ),

        decoration: BoxDecoration(

          color:
          isSelected
              ? color.withOpacity(0.2)
              : Colors.white,

          borderRadius:
          BorderRadius.circular(20),

          border: Border.all(
            color:
            isSelected
                ? color
                : Colors.grey.shade300,
          ),
        ),

        child: Row(
          mainAxisSize: MainAxisSize.min,

          children: [

            Icon(
              icon,
              size: 18,
              color: color,
            ),

            const SizedBox(width: 6),

            Text(
              label,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}