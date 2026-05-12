import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '../../dashboard/view/sidebar.dart';

class AddLocationDialog extends StatefulWidget {
  final Function(AppPage) onPageSelected;
  final String? initialName;
  final String? initialType;
  final String? initialPeriod;
  final String? initialClassification;

  const AddLocationDialog({
    super.key,
    required this.onPageSelected,
    this.initialName,
    this.initialType,
    this.initialPeriod,
    this.initialClassification,
  });

  @override
  State<AddLocationDialog> createState() => _AddLocationDialogState();
}

class _AddLocationDialogState extends State<AddLocationDialog> {

  final _formKey = GlobalKey<FormState>();

  late TextEditingController nameController;

  String type = "ثابت";
  String area = "مربع 1 - السوق العام";
  String period = "صباحي";
  String frequency = "مرتان";
  String classification = "رئيسي";
  String location = "(29,69)";

  @override
  void initState() {
    super.initState();

    nameController = TextEditingController(
      text: widget.initialName ?? "",
    );

    type = widget.initialType ?? type;
    period = widget.initialPeriod ?? period;
    classification = widget.initialClassification ?? classification;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      child: Container(
        width: 500,
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                const Text(
                  "أدخل بيانات موقع الرفع الجديد",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 20),

                const Text("اسم الموقع"),
                const SizedBox(height: 6),

                TextFormField(
                  controller: nameController,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "هذا الحقل مطلوب";
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    hintText: "مثال: حاوية 1-أ",
                  ),
                ),

                const SizedBox(height: 12),

                const Text("نوع الموقع"),

                DropdownButtonFormField(
                  value: type,
                  validator: (value) {
                    if (value == null || value.toString().isEmpty) {
                      return "هذا الحقل مطلوب";
                    }
                    return null;
                  },
                  items: const [
                    DropdownMenuItem(value: "ثابت", child: Text("ثابت")),
                    DropdownMenuItem(value: "مستحدث", child: Text("مستحدث")),
                  ],
                  onChanged: (v) => setState(() => type = v!),
                ),

                const SizedBox(height: 12),

                const Text("المنطقة"),

                DropdownButtonFormField<String>(
                  value: area,
                  validator: (value) {
                    if (value == null || value.toString().isEmpty) {
                      return "هذا الحقل مطلوب";
                    }
                    return null;
                  },
                  items: const [
                    DropdownMenuItem(
                      value: "مربع 1 - السوق العام",
                      child: Text("مربع 1 - السوق العام"),
                    ),
                    DropdownMenuItem(
                      value: "مربع 2 - الحي الشمالي",
                      child: Text("مربع 2 - الحي الشمالي"),
                    ),
                    DropdownMenuItem(
                      value: "مربع 3 - المنطقة الصناعية",
                      child: Text("مربع 3 - المنطقة الصناعية"),
                    ),
                    DropdownMenuItem(
                      value: "مربع 4 - الكورنيش",
                      child: Text("مربع 4 - الكورنيش"),
                    ),
                    DropdownMenuItem(
                      value: "مربع 5 - المركز",
                      child: Text("مربع 5 - المركز"),
                    ),
                  ],
                  onChanged: (value) {
                    setState(() => area = value!);
                  },
                ),

                const SizedBox(height: 12),

                const Text("عدد مرات الرفع في الأسبوع"),

                DropdownButtonFormField(
                  value: frequency,
                  validator: (value) {
                    if (value == null || value.toString().isEmpty) {
                      return "هذا الحقل مطلوب";
                    }
                    return null;
                  },
                  items: const [
                    DropdownMenuItem(value: "مرة", child: Text("مرة")),
                    DropdownMenuItem(value: "مرتان", child: Text("مرتان")),
                    DropdownMenuItem(value: "3 مرات", child: Text("3 مرات")),
                  ],
                  onChanged: (v) => setState(() => frequency = v!),
                ),

                const SizedBox(height: 12),

                const Text("الفترة الزمنية"),

                DropdownButtonFormField(
                  value: period,
                  validator: (value) {
                    if (value == null || value.toString().isEmpty) {
                      return "هذا الحقل مطلوب";
                    }
                    return null;
                  },
                  items: const [
                    DropdownMenuItem(value: "صباحي", child: Text("صباحي")),
                    DropdownMenuItem(value: "مسائي", child: Text("مسائي")),
                  ],
                  onChanged: (v) => setState(() => period = v!),
                ),

                const SizedBox(height: 12),

                const Text("التصنيف"),

                DropdownButtonFormField(
                  value: classification,
                  validator: (value) {
                    if (value == null || value.toString().isEmpty) {
                      return "هذا الحقل مطلوب";
                    }
                    return null;
                  },
                  items: const [
                    DropdownMenuItem(value: "رئيسي", child: Text("رئيسي")),
                    DropdownMenuItem(value: "فرعي", child: Text("فرعي")),
                  ],
                  onChanged: (v) => setState(() => classification = v!),
                ),

                const SizedBox(height: 16),

                const Text("الموقع على الخريطة"),

                const SizedBox(height: 8),

                OutlinedButton.icon(
                  onPressed: () async {

                    LatLng? pickedLocation;

                    await showDialog(
                      context: context,

                      builder: (_) {

                        return Dialog(
                          child: SizedBox(
                            width: 700,
                            height: 500,

                            child: StatefulBuilder(
                              builder: (context, setMapState) {

                                return Stack(
                                  children: [

                                    FlutterMap(

                                      options: MapOptions(
                                        initialCenter:
                                        const LatLng(15.943, 48.786),

                                        initialZoom: 13,

                                        onTap: (tapPosition, point) {

                                          setMapState(() {
                                            pickedLocation = point;
                                          });
                                        },
                                      ),

                                      children: [

                                        TileLayer(
                                          urlTemplate:
                                          'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                                        ),

                                        /// marker
                                        if (pickedLocation != null)
                                          MarkerLayer(
                                            markers: [
                                              Marker(
                                                point: pickedLocation!,
                                                width: 50,
                                                height: 50,

                                                child: const Icon(
                                                  Icons.location_on,
                                                  color: Colors.red,
                                                  size: 40,
                                                ),
                                              ),
                                            ],
                                          ),
                                      ],
                                    ),

                                    Positioned(
                                      bottom: 20,
                                      right: 20,

                                      child: ElevatedButton(
                                        onPressed: () {

                                          if (pickedLocation != null) {

                                            setState(() {

                                              location =
                                              "(${pickedLocation!.latitude.toStringAsFixed(5)}, "
                                                  "${pickedLocation!.longitude.toStringAsFixed(5)})";
                                            });

                                            Navigator.pop(context);
                                          }
                                        },

                                        child: const Text("تأكيد الموقع"),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                          ),
                        );
                      },
                    );
                  },

                  icon: const Icon(
                    Icons.map_outlined,
                    color: Colors.white,
                  ),

                  label: const Text(
                    "اختيار الموقع من الخريطة",
                    style: TextStyle(color: Colors.white),
                  ),

                  style: OutlinedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    minimumSize: const Size(double.infinity, 50),
                  ),
                ),

                const SizedBox(height: 8),

                Text(
                  "الإحداثيات: $location",
                  style: const TextStyle(color: Colors.grey),
                ),

                const SizedBox(height: 20),

                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [

                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.blue,
                      ),
                      child: const Text(
                        "إلغاء",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),

                    const SizedBox(width: 10),

                    ElevatedButton(
                      onPressed: () {

                        if (!_formKey.currentState!.validate()) {
                          return;
                        }

                        Navigator.pop(context, {
                          "area": area,
                          "name": nameController.text,
                          "type": type,
                          "period": period,
                          "classification": classification,
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                      ),
                      child: const Text(
                        "حفظ",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}