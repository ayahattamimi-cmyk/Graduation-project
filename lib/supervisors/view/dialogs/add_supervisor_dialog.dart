import 'package:flutter/material.dart';
import 'package:web2/login screen/view/login_view.dart';

class AddSupervisorDialog extends StatefulWidget {
  const AddSupervisorDialog({super.key});

  @override
  State<AddSupervisorDialog> createState() => _AddSupervisorDialogState();
}

class _AddSupervisorDialogState extends State<AddSupervisorDialog> {

  final TextEditingController nameController = TextEditingController();

  String workType = "sweeping";
  String selectedSquare = "مربع 1 - السوق العام";

  final List<String> squares = [
    "مربع 1 - السوق العام",
    "مربع 2 - الحي الشمالي",
    "مربع 3 - المنطقة الصناعية",
    "مربع 4 - الكورنيش",
  ];

  @override
  Widget build(BuildContext context) {

    return Dialog(

      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),

      child: Container(
        width: 500,
        padding: const EdgeInsets.all(24),

        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [

            /// العنوان
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [

                const Text(
                  "إضافة مشرف جديد",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: (){
                    Navigator.pop(context);
                  },
                )
              ],
            ),

            const SizedBox(height: 8),

            const Text(
              "أدخل بيانات المشرف الجديد",
              style: TextStyle(color: Colors.grey),
            ),

            const SizedBox(height: 25),

            /// اسم المشرف
            const Text("اسم المشرف"),

            const SizedBox(height: 6),

            TextField(
              controller: nameController,
              decoration: InputDecoration(
                hintText: "أدخل اسم المشرف",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),

            const SizedBox(height: 20),

            /// نوع العمل
            const Text("نوع العمل"),

            const SizedBox(height: 6),

            DropdownButtonFormField<String>(

              value: workType,

              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),

              items: const [

                DropdownMenuItem(
                  value: "sweeping",
                  child: Text("كنس"),
                ),

                DropdownMenuItem(
                  value: "lifting",
                  child: Text("رفع"),
                ),
              ],

              onChanged: (value){
                setState(() {
                  workType = value!;
                });
              },
            ),

            const SizedBox(height: 20),

            /// المربع
            const Text("المربع المسؤول"),

            const SizedBox(height: 6),

            DropdownButtonFormField<String>(

              value: selectedSquare,

              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),

              items: squares.map((square){

                return DropdownMenuItem(
                  value: square,
                  child: Text(square),
                );

              }).toList(),

              onChanged: (value){
                setState(() {
                  selectedSquare = value!;
                });
              },
            ),

            const SizedBox(height: 30),

            /// زر إضافة المشرف
            SizedBox(
              width: double.infinity,

              child: ElevatedButton(

                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: const Color(0xff2563EB),
                ),

                child: const Text(
                  "إضافة المشرف",
                  style: TextStyle(fontSize: 16,color: Colors.white),
                ),

                onPressed: () {

                  if(nameController.text.trim().isEmpty){
                    return;
                  }

                  Navigator.pop(context);

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => LoginScreen(
                        isSignup: true,
                        supervisorName: nameController.text,
                        supervisorType: workType,
                        supervisorArea: selectedSquare,
                      ),
                    ),
                  );

                },
              ),
            )

          ],
        ),
      ),
    );
  }
}