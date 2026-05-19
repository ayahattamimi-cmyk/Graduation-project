import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../add_location_dialog.dart';
import '../../viewmodel/drop_locations_viewmodel.dart';

class DropLocationsHeader extends StatelessWidget {
  final Function(Map data) onAdd;
  const DropLocationsHeader({super.key, required this.onAdd});

  @override
  Widget build(BuildContext context) {
    final stats = context.watch<DropLocationsViewModel>().statistics;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// title + button
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  "إدارة مواقع الرفع",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  "إضافة وتحديث مواقع الحاويات والرفع",
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
            ElevatedButton.icon(
              onPressed: () async {
                final result = await showDialog(
                  context: context,
                  builder: (_) => const AddLocationDialog(),
                );

                if (result != null) {
                  onAdd(result);
                }
              },
              icon: const Icon(Icons.add, color: Colors.white),
              label: const Text(
                "إضافة موقع جديد",
                style: TextStyle(color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 14,
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 20),

        /// cards
        Row(
          children: [
            Expanded(
              child: _StatCard(
                title: "المحتوى التفاعلي",
                number: "${stats?.dynamicCount ?? 0}",
                color: Colors.orange,
                icon: Icons.location_on_outlined,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _StatCard(
                title: "المحتوى الثابت",
                number: "${stats?.staticCount ?? 0}",
                color: Colors.purple,
                icon: Icons.place_outlined,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _StatCard(
                title: "إجمالي المواقع",
                number: "${stats?.totalContent ?? 0}",
                color: Colors.blue,
                icon: Icons.widgets_outlined,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String number;
  final Color color;
  final IconData icon;

  const _StatCard({
    required this.title,
    required this.number,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      height: 110,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 28),
          const Spacer(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(title, style: const TextStyle(fontSize: 13)),
              const SizedBox(height: 6),
              Text(
                number,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}