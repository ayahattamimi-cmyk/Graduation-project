import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import '../../map/viewmodel/map_viewmodel.dart';
import '../data/container_model.dart';
import '../data/area_model.dart';

class AddLocationDialog extends StatefulWidget {
  final List<AreaModel> existingAreas;
  final ContainerModel? initialContainer;

  const AddLocationDialog({
    super.key,
    required this.existingAreas,
    this.initialContainer,
  });

  @override
  State<AddLocationDialog> createState() => _AddLocationDialogState();
}

class _AddLocationDialogState extends State<AddLocationDialog> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController nameController;
  late TextEditingController streetController;
  late TextEditingController latController;
  late TextEditingController lngController;
  late TextEditingController startTimeController;

  double? selectedLat;
  double? selectedLng;

  String type = "ثابتة";
  int frequency = 1;
  String period = "صباحي";
  String classification = "رئيسي";
  String? selectedAreaDetail;
  int? selectedAreaId;

  bool isDaily = false;
  List<String> selectedDays = [];
  final List<String> weekDays = [
    "الأحد",
    "الاثنين",
    "الثلاثاء",
    "الأربعاء",
    "الخميس",
    "الجمعة",
    "السبت",
  ];

  final List<String> typeOptions = ["ثابتة", "مستحدثة"];
  final List<int> frequencyOptions = [1, 2, 3, 4, 5, 6, 7];
  final List<String> periodOptions = ["صباحي", "مسائي"];
  final List<String> classificationOptions = ["رئيسي", "ثانوي"];

  @override
  void initState() {
    super.initState();
    final c = widget.initialContainer;
    nameController = TextEditingController(
      text: c?.locationName ?? "التنمية - قبلي مستشفى بن زبلع",
    );
    streetController = TextEditingController(
      text: c?.nameStreet ?? "لو الوحدة",
    );
    startTimeController = TextEditingController(
      text: c?.startTime ?? "13:30:00",
    );

    selectedLat = c?.lat;
    selectedLng = c?.lng;
    latController = TextEditingController(text: selectedLat?.toString() ?? "");
    lngController = TextEditingController(text: selectedLng?.toString() ?? "");

    if (c != null) {
      type = c.type;
      classification = c.classification;
      selectedAreaDetail = c.areaDetails;
      selectedAreaId = c.areaId;
      period = c.period;
      frequency = c.collectionFrequency;
      if (c.collectionDay.contains("يومياً")) {
        isDaily = true;
        selectedDays = List.from(weekDays);
      } else {
        selectedDays =
            c.collectionDay
                .split(',')
                .map((e) => e.trim())
                .where((e) => e.isNotEmpty)
                .toList();
      }
    } else {
      type = "مستحدثة";
      classification = "ثانوي";
      frequency = 2;
      selectedDays = ["الاثنين", "الأحد"];

      if (widget.existingAreas.isNotEmpty) {
        selectedAreaId = widget.existingAreas.first.id;
        selectedAreaDetail = widget.existingAreas.first.areaDetails;
      }
    }
  }

  /// يبدّل تحديد يوم واحد.
  void _toggleDay(String day) {
    setState(() {
      if (selectedDays.contains(day)) {
        selectedDays.remove(day);
        isDaily = false;
      } else {
        selectedDays.add(day);
        if (selectedDays.length == 7) isDaily = true;
      }
    });
  }

  /// يبدّل خيار "كل يوم"، ليحدد أو يمسح جميع الأيام.
  void _toggleDaily(bool? value) {
    setState(() {
      isDaily = value ?? false;
      if (isDaily) {
        selectedDays = List.from(weekDays);
      } else {
        selectedDays.clear();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        width: 650,
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 24),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.initialContainer == null
                          ? "إضافة موقع رفع جديد"
                          : "تعديل بيانات الموقع",
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close),
                    ),
                  ],
                ),
                Text(
                  widget.initialContainer == null
                      ? "أدخل بيانات موقع الرفع الجديد بدقة لتجنب التعارض"
                      : "قم بتعديل البيانات المطلوبة ثم اضغط على زر التحديث",
                  style: const TextStyle(color: Color(0xFF616161), fontSize: 13),
                ),
                const SizedBox(height: 24),

                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildLabel("اسم الموقع"),
                          _buildTextField(
                            nameController,
                            "مثال: حاوية التنمية",
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildLabel("اسم الشارع"),
                          _buildTextField(streetController, "مثال: لو الوحدة"),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildLabel("نوع الموقع"),
                          _buildDropdown<String>(
                            type,
                            typeOptions,
                            (v) => setState(() => type = v!),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildLabel("التصنيف"),
                          _buildDropdown<String>(
                            classification,
                            classificationOptions,
                            (v) => setState(() => classification = v!),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                _buildLabel("المنطقة"),
                DropdownButtonFormField<String>(
                  value: selectedAreaDetail,
                  decoration: _inputDecoration("اختر المنطقة"),
                  validator:
                      (v) =>
                          (v == null || v.isEmpty)
                              ? "يرجى اختيار المنطقة"
                              : null,
                  items:
                      widget.existingAreas.map((area) {
                        return DropdownMenuItem(
                          value: area.areaDetails,
                          child: Text(area.areaDetails),
                        );
                      }).toList(),
                  onChanged: (v) {
                    setState(() {
                      selectedAreaDetail = v;
                      final area = widget.existingAreas.firstWhere(
                        (a) => a.areaDetails == v,
                      );
                      selectedAreaId = area.id;
                    });
                  },
                ),

                const SizedBox(height: 24),
                const Divider(),
                const SizedBox(height: 16),

                Row(
                  children: [
                    const Icon(Icons.calendar_month_outlined, size: 20),
                    const SizedBox(width: 8),
                    const Text(
                      "جدولة أوقات الرفع",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: CheckboxListTile(
                    title: const Text("يومياً (جميع أيام الأسبوع)"),
                    value: isDaily,
                    onChanged: _toggleDaily,
                    controlAffinity: ListTileControlAffinity.trailing,
                    contentPadding: EdgeInsets.zero,
                  ),
                ),

                const SizedBox(height: 16),
                const Text(
                  "اختر أيام الرفع المحدد",
                  style: const TextStyle(fontSize: 13, color: Color(0xFF616161)),
                ),
                const SizedBox(height: 8),

                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children:
                      weekDays.map((day) {
                        final isSelected = selectedDays.contains(day);
                        return InkWell(
                          onTap: () => _toggleDay(day),
                          child: Container(
                            width: 140,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 10,
                            ),
                            decoration: BoxDecoration(
                              color:
                                  isSelected
                                      ? Colors.green.withOpacity(0.1)
                                      : Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color:
                                    isSelected
                                        ? Colors.green
                                        : Colors.grey.shade300,
                                width: isSelected ? 1.5 : 1,
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  day,
                                  style: TextStyle(
                                    fontWeight:
                                        isSelected
                                            ? FontWeight.bold
                                            : FontWeight.normal,
                                    color:
                                        isSelected
                                            ? Colors.green.shade700
                                            : Colors.black87,
                                  ),
                                ),
                                if (isSelected)
                                  const Icon(
                                    Icons.check_circle,
                                    size: 18,
                                    color: Colors.green,
                                  ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                ),

                const SizedBox(height: 24),

                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildLabel("عدد مرات الرفع / أسبوع"),
                          _buildDropdown<int>(
                            frequency,
                            frequencyOptions,
                            (v) => setState(() => frequency = v!),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildLabel("وقت بدء الرفع"),
                          _buildTextField(startTimeController, "13:30:00"),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildLabel("الفترة"),
                          _buildDropdown<String>(
                            period,
                            periodOptions,
                            (v) => setState(() => period = v!),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),
                const Divider(),
                const SizedBox(height: 16),

                _buildLabel("الموقع الجغرافي (Picker)"),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: OutlinedButton.icon(
                    onPressed: () async {
                      final mapVM = context.read<WebMapViewModel>();
                      mapVM.enablePickerMode();
                      final dynamic result = await Navigator.pushNamed(
                        context,
                        '/mapPage',
                      );
                      if (result is LatLng) {
                        setState(() {
                          selectedLat = result.latitude;
                          selectedLng = result.longitude;
                          latController.text = selectedLat!.toString();
                          lngController.text = selectedLng!.toString();
                        });
                      } else {
                        mapVM.disablePickerMode();
                      }
                    },
                    icon: Icon(
                      selectedLat != null
                          ? Icons.location_on
                          : Icons.map_outlined,
                      color: selectedLat != null ? Colors.green : Colors.grey,
                    ),
                    label: Text(
                      selectedLat != null
                          ? "تم تحديد الإحداثيات بنجاح"
                          : "تحديد الموقع من الخريطة",
                      style: TextStyle(
                        color:
                            selectedLat != null
                                ? Colors.green.shade700
                                : Colors.black87,
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      side: BorderSide(
                        color:
                            selectedLat != null
                                ? Colors.green
                                : Colors.grey.shade300,
                        width: selectedLat != null ? 2 : 1,
                      ),
                    ),
                  ),
                ),

                if (selectedLat != null) ...[
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(child: _buildTextField(latController, "Lat")),
                      const SizedBox(width: 12),
                      Expanded(child: _buildTextField(lngController, "Lng")),
                    ],
                  ),
                ],

                const SizedBox(height: 32),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xff2563EB),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        if (selectedAreaId == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("يرجى اختيار المنطقة أولاً"),
                            ),
                          );
                          return;
                        }

                        Navigator.pop(context, {
                          "location_name": nameController.text,
                          "name_street": streetController.text,
                          "type": type,
                          "classification": classification,
                          "area_id": selectedAreaId,
                          "area_details": selectedAreaDetail,
                          "lat":
                              double.tryParse(latController.text) ??
                              selectedLat,
                          "lng":
                              double.tryParse(lngController.text) ??
                              selectedLng,
                          "collection_frequency": frequency,
                          "collection_day":
                              isDaily ? "يومياً" : selectedDays.join(", "),
                          "start_time": startTimeController.text,
                          "period": period,
                        });
                      }
                    },
                    child: Text(
                      widget.initialContainer == null
                          ? "حفظ البيانات وإرسالها"
                          : "تحديث بيانات الموقع",
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// ينشئ عنصر واجهة تسمية لحقول النموذج.
  Widget _buildLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        label,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
      ),
    );
  }

  /// ينشئ حقل نص نموذج مع التحقق.
  Widget _buildTextField(TextEditingController controller, String hint) {
    return TextFormField(
      controller: controller,
      decoration: _inputDecoration(hint),
      validator: (v) => (v == null || v.isEmpty) ? "مطلوب" : null,
    );
  }

  /// ينشئ حقل قائمة منسدلة للنموذج.
  Widget _buildDropdown<T>(T value, List<T> options, Function(T?) onChanged) {
    return DropdownButtonFormField<T>(
      value: value,
      decoration: _inputDecoration(null),
      items:
          options
              .map(
                (o) => DropdownMenuItem<T>(value: o, child: Text(o.toString())),
              )
              .toList(),
      onChanged: onChanged,
    );
  }

  /// يعيد [InputDecoration] قياسي مع نص التلميح المحدد.
  InputDecoration _inputDecoration(String? hint) {
    return InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: const Color(0xFFF9FAFB),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: Colors.grey.shade200),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: Colors.grey.shade200),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    );
  }
}
