import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

import '../viewmodel/map_viewmodel.dart';
import 'widgets/map_filter_chip.dart';
import 'widgets/map_info_bottom_sheet.dart';
import 'widgets/map_legend.dart';
import 'widgets/map_layers_toggle.dart';

class MapScreen extends StatelessWidget {
  const MapScreen({super.key});

  @override
  Widget build(BuildContext context) {

    return ChangeNotifierProvider(
      create: (_) => MapViewModel(),

      child: Consumer<MapViewModel>(
        builder: (context, vm, _) {

          return Scaffold(

            body: Stack(
              children: [

                GoogleMap(

                  initialCameraPosition: CameraPosition(
                    target: MapViewModel.seiyunCenter,
                    zoom: 13,
                  ),

                  mapType:
                  vm.isSatellite
                      ? MapType.satellite
                      : MapType.normal,

                  polygons: vm.polygons,

                  markers: vm.markers,

                  myLocationEnabled: true,

                  zoomControlsEnabled: false,

                  onMapCreated: vm.onMapCreated,

                  onTap: vm.selectLocation,
                ),

                /// TOP BAR
                Positioned(
                  top: 20,
                  left: 20,
                  right: 20,

                  child: Row(
                    children: [

                      Expanded(
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,

                          child: Row(
                            children: [

                              MapFilterChip(
                                label: "البلاغات",
                                color: Colors.red,
                                icon: Icons.report,
                                isSelected: vm.showReports,
                                onTap: vm.toggleReports,
                              ),

                              const SizedBox(width: 8),

                              MapFilterChip(
                                label: "الحاويات",
                                color: Colors.blue,
                                icon: Icons.delete,
                                isSelected: vm.showContainers,
                                onTap: vm.toggleContainers,
                              ),

                              const SizedBox(width: 8),

                              MapFilterChip(
                                label: "المناطق",
                                color: Colors.green,
                                icon: Icons.map,
                                isSelected: vm.showAreas,
                                onTap: vm.toggleAreas,
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(width: 12),

                      FloatingActionButton.small(
                        heroTag: "satellite",

                        backgroundColor: Colors.white,

                        onPressed: vm.toggleSatellite,

                        child: Icon(
                          vm.isSatellite
                              ? Icons.map
                              : Icons.satellite_alt,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),

                /// LAYERS
                Positioned(
                  top: 90,
                  right: 20,
                  child: const MapLayersToggle(),
                ),

                /// LEGEND
                Positioned(
                  bottom: 20,
                  left: 20,
                  child: const MapLegend(),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}