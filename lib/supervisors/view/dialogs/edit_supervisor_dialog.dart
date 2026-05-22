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
  late TextEditingController areaController;

  late TextEditingController startStreetController;
  late TextEditingController endStreetController;

  late TextEditingController startTimeController;
  late TextEditingController endTimeController;

  String type = "sweeping";
  String period = "صباحية";

  @override
  void initState() {
    super.initState();

    final s = widget.supervisor;
    final details = s.areaDetails.isNotEmpty ? s.areaDetails[0] : null;

    nameController = TextEditingController(text: s.name);
    areaController = TextEditingController(text: s.area);

    startStreetController = TextEditingController(
      text: details?.nameStartStreet,
    );

    endStreetController = TextEditingController(text: details?.nameEndStreet);

    startTimeController = TextEditingController(text: details?.startTime);

    endTimeController = TextEditingController(text: details?.endTime);

    type = s.type;

    if (details?.period != null) {
      period = details!.period!;
    }
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.read<SupervisorViewModel>();

    return AlertDialog(
      title: const Text("تعديل المشرف"),

      content: SizedBox(
        width: 400,

        child: SingleChildScrollView(
          child: Column(
            children: [
              /// الاسم
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: "الاسم"),
              ),

              const SizedBox(height: 15),

              /// المربع
              TextField(
                controller: areaController,
                decoration: const InputDecoration(labelText: "المربع"),
              ),

              const SizedBox(height: 15),

              /// نوع العمل
              DropdownButtonFormField<String>(
                value: type,

                items: const [
                  DropdownMenuItem(value: "sweeping", child: Text("كنس")),

                  DropdownMenuItem(value: "lifting", child: Text("رفع")),
                ],

                onChanged: (v) {
                  setState(() {
                    type = v!;
                  });
                },
              ),

              const SizedBox(height: 20),

              /// تفاصيل الكنس
              if (type == "sweeping") ...[
                TextField(
                  controller: startStreetController,
                  decoration: const InputDecoration(labelText: "بداية الشارع"),
                ),

                const SizedBox(height: 12),

                TextField(
                  controller: endStreetController,
                  decoration: const InputDecoration(labelText: "نهاية الشارع"),
                ),
              ],

              /// تفاصيل الرفع
              if (type == "lifting") ...[
                DropdownButtonFormField<String>(
                  value: period,

                  items: const [
                    DropdownMenuItem(value: "صباحية", child: Text("صباحية")),

                    DropdownMenuItem(value: "مسائية", child: Text("مسائية")),
                  ],

                  onChanged: (v) {
                    setState(() {
                      period = v!;
                    });
                  },
                ),

                const SizedBox(height: 12),

                TextField(
                  controller: startTimeController,
                  decoration: const InputDecoration(labelText: "بداية الوقت"),
                ),

                const SizedBox(height: 12),

                TextField(
                  controller: endTimeController,
                  decoration: const InputDecoration(labelText: "نهاية الوقت"),
                ),
              ],
            ],
          ),
        ),
      ),

      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text("إلغاء"),
        ),
        ElevatedButton(
          child: const Text("حفظ"),
          onPressed: () async {
            // تجهيز البيانات بالشكل الذي يتوقعه الـ Laravel API (حسب البوست مان)
            final Map<String, dynamic> data = {
              "name": nameController.text,
              "type": type,
              "area": areaController.text,
              "square_name": areaController.text, // أو حسب الحقل المطلوب
            };

            if (type == "sweeping") {
              data.addAll({
                "name_start_street": startStreetController.text,
                "name_end_street": endStreetController.text,
              });
            } else {
              data.addAll({
                "period": period,
                "start_time": startTimeController.text,
                "end_time": endTimeController.text,
              });
            }

            // استدعاء دالة التحديث من الـ ViewModel التي أنشأناها سابقاً
            bool success = await vm.updateSupervisor(
              widget.supervisor.id,
              data,
            );

            if (success) {
              if (context.mounted) Navigator.pop(context);
            } else {
              // يمكنك إظهار رسالة خطأ هنا
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("فشل تحديث البيانات")),
              );
            }
          },
        ),
      ],
    );
  }
}
