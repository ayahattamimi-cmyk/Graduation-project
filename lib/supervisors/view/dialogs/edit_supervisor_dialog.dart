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

  @override
  void initState() {
    super.initState();
    final s = widget.supervisor;
    nameController = TextEditingController(text: s.name);

    // محاولة استخراج المعرف الحالي للمربع من البيانات
    // بما أن الـ supervisor model قد لا يحتوي على الـ area_id مباشرة في الـ root
    // سنحاول استخراجه من الـ area_details إذا وجد
    if (s.areaDetails.isNotEmpty) {
      selectedAreaId = s.areaDetails[0].id;
    }

    // تحميل المربعات المتاحة بناءً على نوع عمل المشرف الحالي
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SupervisorViewModel>().loadAreas(s.type);
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
                style: TextStyle(fontSize: 13, color: Colors.grey),
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
              const SizedBox(height: 24),

              const Text(
                "تعيين المربع الجغرافي",
                style: TextStyle(fontSize: 13, color: Colors.grey),
              ),
              const SizedBox(height: 8),

              DropdownButtonFormField<int>(
                value:
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
              const SizedBox(height: 10),
              Text(
                "نوع العمل الحالي: ${widget.supervisor.type == 'sweeping' ? 'كنس' : 'رفع'}",
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.blue.shade700,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
      actionsPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("إلغاء", style: TextStyle(color: Colors.grey)),
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

  void _showSnack(String msg, Color color) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(msg), backgroundColor: color));
  }
}
