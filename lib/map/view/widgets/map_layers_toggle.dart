import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../viewmodel/map_viewmodel.dart';

class MapLayersToggle extends StatelessWidget {
  const MapLayersToggle({super.key});

  @override
  Widget build(BuildContext context) {

    final vm = context.watch<MapViewModel>();

    return Container(
      width: 220,
      padding: const EdgeInsets.all(14),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: const [
          BoxShadow(
            blurRadius: 5,
            color: Colors.black12,
          ),
        ],
      ),

      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [

          CheckboxListTile(
            value: vm.showReports,
            title: const Text("البلاغات"),
            onChanged: (v) {
              vm.toggleReports();
            },
          ),

          CheckboxListTile(
            value: vm.showContainers,
            title: const Text("الحاويات"),
            onChanged: (v) {
              vm.toggleContainers();
            },
          ),

          CheckboxListTile(
            value: vm.showAreas,
            title: const Text("المناطق"),
            onChanged: (v) {
              vm.toggleAreas();
            },
          ),
        ],
      ),
    );
  }
}