import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:web2/supervisors/data/model/supervisor_model.dart';
import '../../viewmodel/supervisor_viewmodel.dart';

class AddSupervisorDialog extends StatefulWidget {
  const AddSupervisorDialog({super.key});

  @override
  State<AddSupervisorDialog> createState() => _AddSupervisorDialogState();
}

class _AddSupervisorDialogState extends State<AddSupervisorDialog> {
  final TextEditingController nameController = TextEditingController();
  String workType = "sweeping";
  
  // سنقوم بتخزين الـ ID أو اسم المربع المختار ديناميكياً
  String? selectedSquare; 

  @override
  void initState() {
    super.initState();
    // ✅ جلب المربعات من السيرفر فور فتح الديالوج بناءً على نوع العمل الافتراضي (sweeping)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SupervisorViewModel>().loadAreas(workType);
    });
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<SupervisorViewModel>();

    return Dialog(
      backgroundColor: const Color(0xffffffff),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
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
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                )
              ],
            ),
            const SizedBox(height: 8),
            const Text("أدخل بيانات المشرف الجديد", style: TextStyle(color: Colors.grey)),
            const SizedBox(height: 25),

            /// اسم المشرف
            const Text("اسم المشرف"),
            const SizedBox(height: 6),
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                hintText: "أدخل اسم المشرف",
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
            const SizedBox(height: 20),

            /// نوع العمل
            const Text("نوع العمل"),
            const SizedBox(height: 6),
            DropdownButtonFormField<String>(
              value: workType,
              decoration: InputDecoration(
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
              items: const [
                DropdownMenuItem(value: "sweeping", child: Text("كنس")),
                DropdownMenuItem(value: "lifting", child: Text("رفع")),
              ],
              onChanged: (value) {
                setState(() {
                  workType = value!;
                  selectedSquare = null; // تصفية الاختيار السابق عند تغيير النوع
                });
                // ✅ إعادة جلب المربعات المتوافقة مع النوع الجديد من السيرفر
                context.read<SupervisorViewModel>().loadAreas(workType);
              },
            ),
            const SizedBox(height: 20),

            /// المربع المسؤول (ديناميكي من السيرفر)
            const Text("المربع المسؤول"),
            const SizedBox(height: 6),
            DropdownButtonFormField<String>(
              value: selectedSquare,
              hint: const Text("اختر المربع المسؤول"),
              decoration: InputDecoration(
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
              // جلب العناصر الحقيقية القادمة من الـ ViewModel
              items: viewModel.areas.map((area) {
                final String areaLabel = area.label ?? area.name ?? area.id.toString();
                return DropdownMenuItem<String>(
                  value: areaLabel,
                  child: Text(areaLabel),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedSquare = value;
                });
              },
            ),
            const SizedBox(height: 30),

            /// زر الإجراء
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: const Color(0xff2563EB),
                ),
                child: viewModel.isLoading 
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text("إضافة المشرف", style: TextStyle(fontSize: 16, color: Colors.white)),
                onPressed: () {
                  if (nameController.text.trim().isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("اكتب اسم المشرف")),
                    );
                    return;
                  }
                  if (selectedSquare == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("الرجاء تحديد المربع المسؤول")),
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

  /// الديالوج الثاني لإنشاء حساب المشرف بـ Firebase
  void _showAccountDialog(BuildContext parentContext) {
    final emailController = TextEditingController();
    final passwordController = TextEditingController();
    bool isObscure = true;

    showDialog(
      context: parentContext,
      builder: (_) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Dialog(
              backgroundColor: const Color(0xffffffff),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
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
                      autofillHints: const [],
                      decoration: InputDecoration(
                        hintText: "أدخل الإيميل",
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                    const SizedBox(height: 15),

                    /// PASSWORD
                    const Text("كلمة المرور"),
                    const SizedBox(height: 6),
                    TextField(
                      controller: passwordController,
                      obscureText: isObscure,
                      autofillHints: const [],
                      decoration: InputDecoration(
                        hintText: "أدخل كلمة المرور",
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                        suffixIcon: IconButton(
                          icon: Icon(isObscure ? Icons.visibility_off : Icons.visibility),
                          onPressed: () => setState(() => isObscure = !isObscure),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    /// زر الحفظ وإنشاء الحساب بالتزامن
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xff2563EB),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        onPressed: () async {
                          if (emailController.text.isEmpty || passwordController.text.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text("عليك إكمال كتابة الحقول")),
                            );
                            return;
                          }

                          try {
                            // 1. إنشاء الحساب في الـ Firebase Authentication
                            await FirebaseAuth.instance.createUserWithEmailAndPassword(
                              email: emailController.text.trim(),
                              password: passwordController.text.trim(),
                            );

                            // 2. إرسال بيانات الكائن كاملة للـ API لحفظها في قاعدة البيانات (Laravel)
                            if (context.mounted) {
                              await parentContext.read<SupervisorViewModel>().addSupervisor(
                                    SupervisorModel(
                                      id: DateTime.now().millisecondsSinceEpoch,
                                      name: nameController.text.trim(),
                                      type: workType,
                                      area: selectedSquare!,
                                      areaDetails: const [],
                                    ),
                                  );
                            }

                            if (context.mounted) {
                              Navigator.pop(context);       // إغلاق ديالوج الحساب
                              Navigator.pop(parentContext); // إغلاق ديالوج المشرف الرئيسي
                            }

                            ScaffoldMessenger.of(parentContext).showSnackBar(
                              const SnackBar(content: Text("تم إضافة المشرف بنجاح")),
                            );
                          } on FirebaseAuthException catch (e) {
                            String msg = "حدث خطأ في النظام";
                            if (e.code == 'email-already-in-use') {
                              msg = "الإيميل مستخدم من قبل في نظام Firebase";
                            } else if (e.code == 'weak-password') {
                              msg = "كلمة المرور ضعيفة للغاية";
                            }
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("خطأ أثناء حفظ البيانات بالسيرفر: $e")),
                            );
                          }
                        },
                        child: const Text("إنشاء الحساب وإضافته", style: TextStyle(color: Colors.white)),
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