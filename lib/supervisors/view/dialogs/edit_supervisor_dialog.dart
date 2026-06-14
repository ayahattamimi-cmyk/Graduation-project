import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/model/supervisor_model.dart';
import '../../viewmodel/supervisor_viewmodel.dart';

class EditSupervisorDialog extends StatefulWidget {
  final SupervisorModel supervisor;
  final int index;

  const EditSupervisorDialog({
    super.key,
    required this.supervisor,
    required this.index,
  });

  @override
  State<EditSupervisorDialog> createState() => _EditSupervisorDialogState();
}

class _EditSupervisorDialogState extends State<EditSupervisorDialog> {
  late TextEditingController nameController;
  int? selectedAreaId;
  late String workType;

  @override
  void initState() {
    super.initState();
    final s = widget.supervisor;
    nameController = TextEditingController(text: s.name);
    workType = s.type;

    if (s.areaDetails.isNotEmpty) {
      selectedAreaId = s.areaDetails[0].id;
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SupervisorViewModel>().loadAreas(workType);
    });
  }

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<SupervisorViewModel>();

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: const Text(
        "تعديل بيانات المشرف",
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      content: SizedBox(
        width: 400,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "اسم المشرف",
                style: TextStyle(fontSize: 13, color: Color(0xFF616161)),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.person_outline, size: 20),
                  filled: true,
                  fillColor: Colors.grey.shade50,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              const Text(
                "نوع العمل",
                style: TextStyle(fontSize: 13, color: Color(0xFF616161)),
              ),
              const SizedBox(height: 8),

              DropdownButtonFormField<String>(
                value: workType,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.work_outline, size: 20),
                  filled: true,
                  fillColor: Colors.grey.shade50,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                ),
                items: const [
                  DropdownMenuItem(value: "sweeping", child: Text("كنس")),
                  DropdownMenuItem(value: "lifting", child: Text("رفع")),
                ],
                onChanged: (value) {
                  setState(() {
                    workType = value!;
                    selectedAreaId = null;
                  });
                  context.read<SupervisorViewModel>().loadAreas(workType);
                },
              ),

              const SizedBox(height: 20),

              const Text(
                "تعيين المربع الجغرافي",
                style: TextStyle(fontSize: 13, color: Color(0xFF616161)),
              ),
              const SizedBox(height: 8),

              if (vm.isLoadingAreas)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: Center(child: CircularProgressIndicator()),
                )
              else
                DropdownButtonFormField<int>(
                  value: selectedAreaId != null &&
                          vm.areas.any((a) => a.id == selectedAreaId)
                      ? selectedAreaId
                      : null,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.grid_view, size: 20),
                    filled: true,
                    fillColor: Colors.grey.shade50,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                  ),
                  items:
                      vm.areas.map((area) {
                        return DropdownMenuItem<int>(
                          value: area.id,
                          child: Text(
                            area.label ?? area.name ?? "مربع ${area.id}",
                          ),
                        );
                      }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedAreaId = value;
                    });
                  },
                  hint: const Text("اختر المربع"),
                ),
            ],
          ),
        ),
      ),
      actionsPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("إلغاء", style: TextStyle(color: Color(0xFF616161))),
        ),
        const SizedBox(width: 8),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xff2563EB),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 0,
          ),
          onPressed:
              vm.isLoading
                  ? null
                  : () async {
                    if (nameController.text.isEmpty) {
                      _showSnack("الرجاء إدخال الاسم", Colors.orange);
                      return;
                    }
                    if (selectedAreaId == null) {
                      _showSnack("الرجاء اختيار المربع", Colors.orange);
                      return;
                    }

                    final Map<String, dynamic> data = {
                      "name": nameController.text,
                      "area_id": selectedAreaId,
                      "type": workType,
                    };

                    bool success = await vm.updateSupervisor(
                      widget.supervisor.id,
                      data,
                    );

                    if (success) {
                      if (context.mounted) {
                        _showSnack("تم تحديث البيانات بنجاح", Colors.green);
                        Navigator.pop(context);
                      }
                    } else {
                      if (context.mounted) {
                        _showSnack(
                          "فشل تحديث البيانات، حاول مرة أخرى",
                          Colors.red,
                        );
                      }
                    }
                  },
          child:
              vm.isLoading
                  ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  )
                  : const Text("حفظ التعديلات"),
        ),
      ],
    );
  }

  /// يعرض شريط إشعارات بالرسالة واللون المحددين.
  void _showSnack(String msg, Color color) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(msg), backgroundColor: color));
  }
}
