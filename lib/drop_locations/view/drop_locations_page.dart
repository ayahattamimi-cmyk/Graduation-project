import 'package:flutter/material.dart';
import '../data/area_data.dart';
import '../data/container_data.dart';
import 'widgets/area_card.dart';
import 'widgets/drop_locations_header.dart';

class DropLocationsPage extends StatefulWidget {
  const DropLocationsPage({super.key});

  @override
  State<DropLocationsPage> createState() => _DropLocationsPageState();
}

class _DropLocationsPageState extends State<DropLocationsPage> {

  /// جميع المربعات
  List<AreaData> areas = [
    AreaData(
      areaDetails: "مربع 1 - السوق العام",
      containers: [],
    ),
    AreaData(
      areaDetails: "مربع 2 - الحي الشمالي",
      containers: [],
    ),
    AreaData(
      areaDetails: "مربع 3 - المنطقة الصناعية",
      containers: [],
    ),
    AreaData(
      areaDetails: "مربع 4 - الكورنيش",
      containers: [],
    ),
    AreaData(
      areaDetails: "مربع 5 - المركز",
      containers: [],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [

        /// زر الإضافة
        DropLocationsHeader(
          onAdd: (data) {
            setState(() {

              final areaIndex = areas.indexWhere(
                    (a) => a.areaDetails == data["area"],
              );

              if (areaIndex != -1) {
                areas[areaIndex].containers.add(
                  ContainerData(
                    id: DateTime.now().millisecondsSinceEpoch,
                    nameContainer: data["name"],
                    nameStreet: "",
                    type: data["type"],
                    period: data["period"],
                    collectionFrequency: 1,
                    collectionDay: "",
                    startTime: "",
                    classification: data["classification"],
                  ),
                );
              }

            });
          },
        ),

        const SizedBox(height: 20),

        /// عرض المربعات
        ...areas.map((area) => AreaCard(area: area)),

      ],
    );
  }
}