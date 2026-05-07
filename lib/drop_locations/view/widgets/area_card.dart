import 'package:flutter/material.dart';
import '../../data/area_data.dart';
import '../add_location_dialog.dart';
import 'container_tile.dart';

class AreaCard extends StatefulWidget {
  final AreaData area;

  const AreaCard({super.key, required this.area});

  @override
  State<AreaCard> createState() => _AreaCardState();
}

class _AreaCardState extends State<AreaCard> {
  bool expanded = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.grey,
      margin: const EdgeInsets.all(12),
      child: Column(
        children: [
          ListTile(
            title: Text(
              widget.area.areaDetails,
              style: const TextStyle(color: Colors.white),
            ),
            trailing: IconButton(
              icon: Icon(
                expanded
                    ? Icons.keyboard_arrow_up
                    : Icons.keyboard_arrow_down,
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
            ...widget.area.containers.map(
                  (c) => ContainerTile(
                container: c,

                /// حذف
                onDelete: () {
                  setState(() {
                    widget.area.containers.remove(c);
                  });
                },

                /// تعديل
                    onEdit: () async {
                      final result = await showDialog(
                        context: context,
                        builder: (_) => AddLocationDialog(
                          initialName: c.nameContainer,
                          initialType: c.type,
                          initialPeriod: c.period,
                          initialClassification: c.classification,
                        ),
                      );

                      if (result != null) {
                        setState(() {
                          c.nameContainer = result["name"];
                          c.type = result["type"];
                          c.period = result["period"];
                          c.classification = result["classification"];
                        });
                      }
                    },
              ),
            ),
        ],
      ),
    );
  }
}