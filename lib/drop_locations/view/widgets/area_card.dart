import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:web2/drop_locations/data/area_model.dart';
import 'package:web2/drop_locations/viewmodel/drop_locations_viewmodel.dart';
import '../../../dashboard/view/widgets/sidebar.dart';

import '../add_location_dialog.dart';
import 'container_tile.dart';

class AreaCard extends StatefulWidget {
  final AreaModel area;
  final Function(AppPage) onPageSelected;

  const AreaCard({super.key, required this.area, required this.onPageSelected});

  @override
  State<AreaCard> createState() => _AreaCardState();
}

class _AreaCardState extends State<AreaCard> {
  bool expanded = false;

  @override
  Widget build(BuildContext context) {
    final viewModel = context.read<DropLocationsViewModel>();
    final int containerCount = widget.area.containers.length;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(
          color:
              expanded
                  ? const Color(0xFF10B981).withOpacity(0.3)
                  : Colors.transparent,
          width: 2,
        ),
      ),
      child: Column(
        children: [
          // رأس الكارد (Header)
          InkWell(
            onTap: () => setState(() => expanded = !expanded),
            borderRadius: BorderRadius.circular(16),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  // أيقونة المنطقة مع خلفية فاتحة
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF0FDF4),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.grid_view_rounded,
                      color: Color(0xFF10B981),
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 16),

                  // اسم المنطقة
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.area.areaDetails,
                          style: const TextStyle(
                            color: Color(0xFF1F2937),
                            fontWeight: FontWeight.bold,
                            fontSize: 17,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "يحتوي على $containerCount حاوية",
                          style: TextStyle(
                            color: Colors.grey.shade500,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // أيقونة السهم
                  Icon(
                    expanded
                        ? Icons.expand_less_rounded
                        : Icons.expand_more_rounded,
                    color: const Color(0xFF10B981),
                    size: 28,
                  ),
                ],
              ),
            ),
          ),

          // المحتوى عند التوسيع
          if (expanded)
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Column(
                children: [
                  const Divider(indent: 16, endIndent: 16),
                  const SizedBox(height: 8),
                  ...widget.area.containers.map(
                    (c) => ContainerTile(
                      container: c,
                      onDelete: () {
                        if (c.id != null) {
                          viewModel.deleteContainer(c.id!);
                        }
                      },
                      onEdit: () async {
                        final result = await showDialog(
                          context: context,
                          builder:
                              (_) => AddLocationDialog(
                                existingAreas: viewModel.areas,
                                initialContainer: c,
                              ),
                        );

                        if (result != null && c.id != null) {
                          final updatedContainer = c.copyWith(
                            locationName: result["location_name"],
                            nameStreet: result["name_street"],
                            type: result["type"],
                            classification: result["classification"],
                            areaId: result["area_id"],
                            lat: result["lat"],
                            lng: result["lng"],
                            collectionFrequency: result["collection_frequency"],
                            collectionDay: result["collection_day"],
                            startTime: result["start_time"],
                            period: result["period"],
                          );
                          viewModel.editContainer(c.id!, updatedContainer);
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
