import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import 'package:web2/map/view/widgets/map_filters.dart';

import '../viewmodel/map_viewmodel.dart';
import 'widgets/map_layers_toggle.dart';
import 'widgets/map_legend.dart';


class MapScreen extends StatelessWidget {
  const MapScreen({super.key});

  Color reportColor(String status) {

    switch (status) {

      case "عاجل":
        return Colors.red;

      case "تم التنفيذ":
        return Colors.green;

      default:
        return Colors.orange;
    }
  }

  Color containerColor(String type) {

    switch (type) {

      case "ثابت":
        return Colors.blue;

      default:
        return Colors.orange;
    }
  }

  @override
  Widget build(BuildContext context) {

    return ChangeNotifierProvider(
      create: (_) => MapViewModel(),

      child: Consumer<MapViewModel>(
        builder: (context, vm, _) {

          return Scaffold(

            body: Stack(
              children: [

                FlutterMap(

                  options: MapOptions(
                    initialCenter: const LatLng(15.943, 48.786),
                    initialZoom: 13,

                    onTap: (tapPosition, point) {

                      vm.selectedLocation = point;
                      vm.notifyListeners();

                      print(point.latitude);
                      print(point.longitude);
                    },
                  ),


                  children: [

                    TileLayer(
                      urlTemplate:
                      'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                    ),

                    /// المناطق
                    if (vm.showAreas)
                      PolygonLayer(

                        polygons: vm.polygons.map((p) {

                          return Polygon(

                            points: p.points.map((e) {
                              return LatLng(e[0], e[1]);
                            }).toList(),

                            color: Colors.blue.withOpacity(0.2),

                            borderColor: Colors.blue,

                            borderStrokeWidth: 2,
                          );

                        }).toList(),
                      ),

                    /// البلاغات
                    if (vm.showReports)
                      MarkerLayer(

                        markers: vm.reports.map((r) {

                          return Marker(

                            point: LatLng(r.lat, r.lng),

                            width: 40,
                            height: 40,

                            child: Icon(
                              Icons.location_on,
                              color: reportColor(r.status),
                              size: 35,
                            ),
                          );

                        }).toList(),
                      ),

                    /// الحاويات
                    if (vm.showContainers)
                      MarkerLayer(
                        markers: vm.containers.map((c) {

                          return Marker(
                            point: LatLng(c.lat, c.lng),
                            width: 40,
                            height: 40,

                            child: Icon(
                              Icons.delete,
                              color: containerColor(c.type),
                              size: 30,
                            ),
                          );

                        }).toList(),
                      ),

                    /// الموقع المختار
                    if (vm.selectedLocation != null)
                      MarkerLayer(
                        markers: [
                          Marker(
                            point: vm.selectedLocation!,
                            width: 50,
                            height: 50,

                            child: const Icon(
                              Icons.location_pin,
                              color: Colors.red,
                              size: 40,
                            ),
                          ),
                        ],
                      ),
                  ],
                ),

                /// الفلاتر
                Positioned(
                  top: 20,
                  right: 20,
                  child: const MapLayersToggle(),
                ),

                Positioned(
                  top: 20,
                  left: 20,
                  child: const MapFilterWidget(),
                ),

                /// الليجند
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