import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:web2/drop_locations/data/area_model.dart';
import 'package:web2/drop_locations/viewmodel/drop_locations_viewmodel.dart';
import '../../../dashboard/view/sidebar.dart';
import '../../data/area_data.dart';
import '../add_location_dialog.dart';
import 'container_tile.dart';

class AreaCard extends StatefulWidget {
  final AreaData area;
  final Function(AppPage) onPageSelected;

  const AreaCard({super.key, required this.area,required this.onPageSelected,});

  @override
  State<AreaCard> createState() => _AreaCardState();
}

class _AreaCardState extends State<AreaCard> {
  bool expanded = false;

  @override
  Widget build(BuildContext context) {
    // الوصول للـ ViewModel لتنفيذ العمليات الحقيقية
    final viewModel = context.read<DropLocationsViewModel>();

    return Card(
      color: Colors.grey,
      margin: const EdgeInsets.all(12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Column(
        children: [
          ListTile(
            title: Text(
              widget.area.areaDetails,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            trailing: IconButton(
              icon: Icon(
                expanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                color: Colors.white,
              ),
              onPressed: () {
                setState(() {
                  expanded = !expanded;
                });
              },
            ),
          ),

          if (expanded)
            // عرض الحاويات التابعة لهذا المربع
            ...widget.area.containers.map(
              (c) => ContainerTile(
                container: c,

                /// حذف حاوية من السيرفر
                onDelete: () {
                  if (c.id != null) {
                    // تم التعديل: الحذف الآن يتم عبر الـ ViewModel وليس setState محلي
                    viewModel.deleteContainer(c.id!);
                  }
                },

                /// تعديل بيانات حاوية
                onEdit: () async {
                  final result = await showDialog(
                    context: context,
                    builder:
                        (_) => AddLocationDialog(
                          initialName: c.nameContainer,
                          initialType: c.type,
                          initialPeriod: c.period,
                          initialClassification: c.classification,
                        ),
                  );

                  if (result != null && c.id != null) {
                    // --- (تعديل) تحديث البيانات وإرسالها للسيرفر ---
                    final updatedContainer = c.copyWith(
                      nameContainer: result["name"],
                      type: result["type"],
                      period: result["period"],
                      classification: result["classification"],
                    );

                    // استدعاء دالة التعديل التي أضفناها في الفيو مودل
                    viewModel.editContainer(c.id!, updatedContainer);
                  }
                },
              ),
            ),
        ],
      ),
    );
  }
}
