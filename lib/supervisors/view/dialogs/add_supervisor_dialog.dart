import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/model/supervisor_model.dart';
import '../../viewmodel/supervisor_viewmodel.dart';

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
      backgroundColor: const Color(0xffffffff),
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
                DropdownMenuItem(value: "sweeping", child: Text("كنس")),
                DropdownMenuItem(value: "lifting", child: Text("رفع")),
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

                  if (nameController.text.trim().isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("اكتب اسم المشرف")),
                    );
                    return;
                  }

                  _showAccountDialog(context);
                },
              ),
            )

          ],
        ),
      ),
    );
  }

  /// ✅ الديالوج الثاني (خارج build)
  void _showAccountDialog(BuildContext context) {

    final emailController = TextEditingController();
    final passwordController = TextEditingController();

    bool isObscure = true;

    showDialog(
      context: context,
      builder: (_) {

        return StatefulBuilder(
          builder: (context, setState) {

            return Dialog(
              backgroundColor: const Color(0xffffffff),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),

              child: Container(
                width: 400,
                padding: const EdgeInsets.all(24),

                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [

                    const Text(
                      "إنشاء حساب للمشرف",
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),

                    const SizedBox(height: 20),

                    /// EMAIL
                    const Text("الإيميل"),
                    const SizedBox(height: 6),

                    TextField(
                      controller: emailController,
                      autofillHints: const [], // 🚫 يمنع التعبئة التلقائية
                      decoration: InputDecoration(
                        hintText: "أدخل الإيميل",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),

                    const SizedBox(height: 15),

                    /// PASSWORD
                    const Text("كلمة المرور"),
                    const SizedBox(height: 6),

                    TextField(
                      controller: passwordController,
                      obscureText: isObscure,
                      autofillHints: const [], // 🚫 يمنع التعبئة التلقائية
                      decoration: InputDecoration(
                        hintText: "أدخل كلمة المرور",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),

                        suffixIcon: IconButton(
                          icon: Icon(
                            isObscure
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                          onPressed: () {
                            setState(() {
                              isObscure = !isObscure;
                            });
                          },
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    /// BUTTON
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xff2563EB),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),

                        onPressed: () async {

                          /// ✅ تحقق من الحقول
                          if (emailController.text.isEmpty ||
                              passwordController.text.isEmpty) {

                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("عليك إكمال كتابة الحقول"),
                              ),
                            );
                            return;
                          }

                          try {

                            /// 🔥 إنشاء الحساب
                            final user = await FirebaseAuth.instance
                                .createUserWithEmailAndPassword(
                              email: emailController.text.trim(),
                              password: passwordController.text.trim(),
                            );

                            /// ✅ هنا تضيف المشرف للقائمة (Provider)
                            context.read<SupervisorViewModel>().addSupervisor(
                              SupervisorModel(
                                id: DateTime.now().millisecondsSinceEpoch,
                                name: nameController.text,
                                type: workType,
                                area: selectedSquare,
                                areaDetails: [],
                              ),
                            );

                            Navigator.pop(context); // يقفل الديالوج الثاني
                            Navigator.pop(context); // يقفل الأول

                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("تم إضافة المشرف بنجاح"),
                              ),
                            );

                          } on FirebaseAuthException catch (e) {

                            String msg = "حدث خطأ";

                            if (e.code == 'email-already-in-use') {
                              msg = "الإيميل مستخدم من قبل";
                            } else if (e.code == 'weak-password') {
                              msg = "كلمة المرور ضعيفة";
                            }

                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(msg)),
                            );
                          }
                        },

                        child: const Text(
                          "إنشاء الحساب",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    )

                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}