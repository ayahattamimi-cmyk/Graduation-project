import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../dashboard/view/widgets/sidebar.dart';
import 'package:web2/dashboard/view/widgets/stat_card.dart';

import '../add_location_dialog.dart';
import '../../viewmodel/drop_locations_viewmodel.dart';

class DropLocationsHeader extends StatelessWidget {
  final Function(Map data) onAdd;
  final Function(AppPage) onPageSelected;
  const DropLocationsHeader({
    super.key,
    required this.onPageSelected,
    required this.onAdd,
  });

  @override
  Widget build(BuildContext context) {
    final stats = context.watch<DropLocationsViewModel>().statistics;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  "إدارة مواقع الرفع",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 4),
                Text(
                  "إضافة وتحديث مواقع الحاويات والرفع",
                  style: TextStyle(color: Color(0xFF616161)),
                ),
              ],
            ),
            ElevatedButton.icon(
              onPressed: () async {
                final viewModel = context.read<DropLocationsViewModel>();
                final result = await showDialog(
                  context: context,
                  builder:
                      (_) => AddLocationDialog(
                        existingAreas: viewModel.referenceAreas,
                      ),
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

        Row(
          children: [
            Expanded(
              child: StatCard(
                title: "مواقع مستحدثة",
                value: "${stats?.dynamicCount ?? 0}",
                subtitle: "مواقع تم تحديثها مؤخراً",
                color: Colors.orange,
                icon: Icons.location_on_outlined,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: StatCard(
                title: "حاويات ثابتة",
                value: "${stats?.staticCount ?? 0}",
                subtitle: "مواقع الحاويات المسجلة",
                color: Colors.purple,
                icon: Icons.place_outlined,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: StatCard(
                title: "إجمالي المواقع",
                value: "${stats?.totalContent ?? 0}",
                subtitle: "جميع نقاط الرفع المضافة",
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
