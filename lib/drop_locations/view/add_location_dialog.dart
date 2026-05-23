import 'package:flutter/material.dart';

import '../../dashboard/view/widgets/sidebar.dart';

// ... نفس الـ imports
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

  // تعريف القوائم المتاحة للتأكد من مطابقة القيم
  final List<String> typeOptions = ["ثابت", "مستحدث"];
  final List<String> periodOptions = ["صباحي", "مسائي"];
  final List<String> classificationOptions = ["رئيسي", "ثانوي"];

  @override
  void initState() {
    super.initState();

    nameController = TextEditingController(text: widget.initialName ?? "");

    // --- تعديل مهم: فحص الأمان للقيم القادمة من السيرفر ---
    // نتأكد أن القيمة موجودة في القائمة، وإلا نختار القيمة الافتراضية
    if (widget.initialType != null &&
        typeOptions.contains(widget.initialType)) {
      type = widget.initialType!;
    } else if (widget.initialType == "مستحدثة") {
      // حل مشكلة التاء المربوطة يدوياً إذا كانت تأتي هكذا من السيرفر
      type = "مستحدث";
    }

    if (widget.initialPeriod != null &&
        periodOptions.contains(widget.initialPeriod)) {
      period = widget.initialPeriod!;
    }

    if (widget.initialClassification != null &&
        classificationOptions.contains(widget.initialClassification)) {
      classification = widget.initialClassification!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      child: Container(
        width: 500,
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "بيانات موقع الرفع",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),

              const Text("اسم الموقع"),
              TextField(
                controller: nameController,
                decoration: const InputDecoration(hintText: "مثال: حاوية 1-أ"),
              ),

              const SizedBox(height: 12),

              const Text("نوع الموقع"),
              // استخدام DropdownButtonFormField مع التأكد من القيم
              DropdownButtonFormField<String>(
                value: type,
                items:
                    typeOptions.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                onChanged: (v) => setState(() => type = v!),
              ),

              const SizedBox(height: 12),

              // ... باقي الحقول (المنطقة، التكرار، إلخ) بنفس الطريقة
              const Text("الفترة الزمنية"),
              DropdownButtonFormField<String>(
                value: period,
                items:
                    periodOptions.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                onChanged: (v) => setState(() => period = v!),
              ),

              const SizedBox(height: 12),

              const Text("التصنيف"),
              DropdownButtonFormField<String>(
                value: classification,
                items:
                    classificationOptions.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                onChanged: (v) => setState(() => classification = v!),
              ),

              const SizedBox(height: 20),

              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text("إلغاء"),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context, {
                        "name": nameController.text,
                        "type": type,
                        "period": period,
                        "classification": classification,
                        "area": area,
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
