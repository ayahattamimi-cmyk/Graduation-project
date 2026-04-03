import 'package:flutter/material.dart';

class AddLocationDialog extends StatefulWidget {
  final String? initialName;
  final String? initialType;
  final String? initialPeriod;
  final String? initialClassification;

  const AddLocationDialog({
    super.key,
    this.initialName,
    this.initialType,
    this.initialPeriod,
    this.initialClassification,
  });

  @override
  State<AddLocationDialog> createState() => _AddLocationDialogState();
}

class _AddLocationDialogState extends State<AddLocationDialog> {

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
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  hintText: "مثال: حاوية 1-أ",
                ),
              ),

              const SizedBox(height: 12),

              const Text("نوع الموقع"),
              DropdownButtonFormField(
                value: type,
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
                onPressed: () {},
                icon: const Icon(Icons.map_outlined,color: Colors.white,),
                label: const Text("اختيار الموقع من الخريطة",style: TextStyle(color: Colors.white),),
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
                    child: const Text("إلغاء",style: TextStyle(color: Colors.white)),
                  ),

                  const SizedBox(width: 10),

                  ElevatedButton(
                    onPressed: () {
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
                    child: const Text("حفظ",style: TextStyle(color: Colors.white)),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}