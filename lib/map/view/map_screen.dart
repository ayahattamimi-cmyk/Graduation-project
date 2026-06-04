import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:web2/map/view/old_widgets/map_filter_chip.dart';
import '../viewmodel/map_viewmodel.dart';
import 'widgets/zone_details_side.dart';
import '../../report_assignment/viewmodel/assignment_viewmodel.dart';

class WebMapScreen extends StatefulWidget {
  final int? focusReportId;
  const WebMapScreen({Key? key, this.focusReportId}) : super(key: key);

  @override
  State<WebMapScreen> createState() => _WebMapScreenState();
}

class _WebMapScreenState extends State<WebMapScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<WebMapViewModel>().initWebMap(focusId: widget.focusReportId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final mapVM = context.watch<WebMapViewModel>();

    return Scaffold(
      body: Stack(
        children: [
          // الخريطة الأساسية
          GoogleMap(
            mapType: mapVM.isSatellite ? MapType.satellite : MapType.normal,
            initialCameraPosition: const CameraPosition(
              target: WebMapViewModel.seiyunCenter,
              zoom: 13.5,
            ),
            onMapCreated: (controller) => mapVM.onMapCreated(controller),
            markers: mapVM.markers,
            polygons: mapVM.showZones ? mapVM.polygons : {},
            zoomControlsEnabled: false,
            myLocationButtonEnabled: false,
            onTap: (latLng) {
              if (mapVM.isPickerMode) {
                mapVM.setPickedLocation(latLng);
              }
            },
          ),

          // زر التأكيد في وضع الـ Picker
          if (mapVM.isPickerMode && mapVM.pickedLocation != null)
            Positioned(
              bottom: 40,
              left: 0,
              right: 0,
              child: Center(
                child: ElevatedButton.icon(
                  onPressed: () {
                    final loc = mapVM.pickedLocation;
                    mapVM.disablePickerMode();
                    Navigator.pop(context, loc);
                  },
                  icon: const Icon(Icons.check, color: Colors.white),
                  label: const Text(
                    "تأكيد الموقع المختار",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF13B97D),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 30,
                      vertical: 15,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ),
              ),
            ),

          // خيارات التصفية العلوية (Premium Chips)
          if (!mapVM.isPickerMode)
            Positioned(
              top: 20,
              left: 20,
              right: 20,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  MapFilterChip(
                    label: "البلاغات",
                    color: Colors.orange,
                    icon: Icons.report_problem_outlined,
                    isSelected: mapVM.showReports,
                    onTap: () => mapVM.toggleReports(),
                  ),
                  const SizedBox(width: 12),
                  MapFilterChip(
                    label: "الحاويات",
                    color: const Color.fromARGB(255, 12, 100, 38),
                    icon: Icons.delete_outline,
                    isSelected: mapVM.showContainers,
                    onTap: () => mapVM.toggleContainers(),
                  ),
                  const SizedBox(width: 12),
                  MapFilterChip(
                    label: "المناطق",
                    color: Colors.purple,
                    icon: Icons.layers_outlined,
                    isSelected: mapVM.showZones,
                    onTap: () => mapVM.toggleZones(),
                  ),
                ],
              ),
            ),

          // أدوات التحكم الجانبية (Satellite + Zoom)
          Positioned(
            right: 20,
            bottom: 40,
            child: Column(
              children: [
                _MapActionButton(
                  icon:
                      mapVM.isSatellite
                          ? Icons.map_outlined
                          : Icons.satellite_alt_outlined,
                  onPressed: () => mapVM.toggleSatellite(),
                  tooltip: "تبديل عرض القمر الصناعي",
                ),
                const SizedBox(height: 12),
                _MapActionButton(
                  icon: Icons.my_location,
                  onPressed: () => mapVM.moveToCenter(),
                  tooltip: "الرجوع للمركز",
                ),
                const SizedBox(height: 20),
                _MapActionButton(
                  icon: Icons.add,
                  onPressed: () => mapVM.zoomIn(),
                ),
                const SizedBox(height: 8),
                _MapActionButton(
                  icon: Icons.remove,
                  onPressed: () => mapVM.zoomOut(),
                ),
              ],
            ),
          ),

          // تفاصيل المنطقة المختارة
          if (mapVM.selectedZoneName != null)
            Positioned(
              bottom: 30,
              left: 30,
              child: ZoneDetailsSide(
                zoneName: mapVM.selectedZoneName!,
                zoneType: mapVM.selectedZoneType ?? "مربع عمل ميداني",
                onClose: () => mapVM.clearSelectedZone(),
              ),
            ),

          // مؤشر التحميل
          if (mapVM.isLoading)
            Container(
              color: Colors.black26,
              child: const Center(
                child: CircularProgressIndicator(color: Colors.white),
              ),
            ),

          // --- إرجاع واجهة توجيه البلاغ الآلي (بناءً على طلب التراجع) ---
          if (widget.focusReportId != null)
            Positioned(
              left: 20,
              right: 80,
              bottom: 20,
              child: Consumer<AssignmentViewModel>(
                builder: (context, assignVM, _) {
                  if (assignVM.isLoading) return const SizedBox();

                  return Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                          offset: const Offset(0, -2),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.assignment_ind,
                              color: Colors.blue,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              "توجيه البلاغ #${widget.focusReportId}",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            const Spacer(),
                            IconButton(
                              icon: const Icon(Icons.close),
                              onPressed: () => Navigator.pop(context),
                            ),
                          ],
                        ),
                        const Divider(),
                        Row(
                          children: [
                            const Expanded(
                              child: Text(
                                "المشرف الموجه له (آلياً):",
                                style: TextStyle(fontSize: 13),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: DropdownButtonFormField<int>(
                                isExpanded: true,
                                value:
                                    assignVM.supervisors.any(
                                          (s) =>
                                              s.id ==
                                              assignVM.selectedSupervisorId,
                                        )
                                        ? assignVM.selectedSupervisorId
                                        : null,
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colors.grey.shade100,
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 8,
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide.none,
                                  ),
                                ),
                                items:
                                    assignVM.supervisors.map((s) {
                                      return DropdownMenuItem<int>(
                                        value: s.id,
                                        child: Text(
                                          s.name,
                                          style: const TextStyle(fontSize: 13),
                                        ),
                                      );
                                    }).toList(),
                                onChanged: (v) {
                                  if (v != null) assignVM.setSupervisor(v);
                                },
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed:
                                assignVM.isLoading
                                    ? null
                                    : () async {
                                      bool ok = await assignVM.sendAssignment(
                                        widget.focusReportId!,
                                      );
                                      if (context.mounted && ok) {
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          SnackBar(
                                            content: Text(
                                              "تم توجيه البلاغ بنجاح للمشرف: ${assignVM.selectedSupervisorName}",
                                            ),
                                            backgroundColor: Colors.green,
                                          ),
                                        );
                                        Navigator.pop(context);
                                      }
                                    },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF13B97D),
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: const Text("تأكيد التوجيه من الخريطة"),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}

class _MapActionButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;
  final String? tooltip;

  const _MapActionButton({
    required this.icon,
    required this.onPressed,
    this.tooltip,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: IconButton(
        icon: Icon(icon, color: const Color(0xFF13B97D)),
        onPressed: onPressed,
        tooltip: tooltip,
      ),
    );
  }
}
