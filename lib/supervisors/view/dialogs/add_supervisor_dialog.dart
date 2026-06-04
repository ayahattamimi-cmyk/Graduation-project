import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodel/supervisor_viewmodel.dart';
import '../../data/model/area_detail_model.dart';

class AddSupervisorDialog extends StatefulWidget {
  const AddSupervisorDialog({super.key});

  @override
  State<AddSupervisorDialog> createState() => _AddSupervisorDialogState();
}

class _AddSupervisorDialogState extends State<AddSupervisorDialog> {
  int currentStep = 1; // 1: Account, 2: Details

  // Step 1 Controllers
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isPasswordVisible = false;

  // Step 2 Controllers
  String workType = "sweeping";
  AreaDetailModel? selectedArea;
  String? selectedAreaName;

  bool internalLoading = false;
  int? newSupervisorId; // سنحفظ الـ ID هنا للخطوة الثانية
  String? newSupervisorServerToken; // توكن الباك إيند (Laravel)
  String? newSupervisorFirebaseToken; // توكن فايربيس

  @override
  void initState() {
    super.initState();
    // جلب المناطق مسبقاً للخطوة الثانية
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SupervisorViewModel>().loadAreas(workType);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Container(
        width: 480,
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with Stepper Indicator
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  currentStep == 1
                      ? "إنشاء حساب المشرف"
                      : "بيانات العمل للمشرف",
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1F2937),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF0FDF4),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    "خطوة $currentStep من 2",
                    style: const TextStyle(
                      color: Color(0xFF10B981),
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
            const Divider(height: 32),

            // Dialog Content based on Step
            if (currentStep == 1) _buildStep1() else _buildStep2(),

            const SizedBox(height: 32),

            // Actions
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF10B981),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                onPressed:
                    internalLoading
                        ? null
                        : (currentStep == 1 ? _handleStep1 : _handleStep2),
                child:
                    internalLoading
                        ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                        : Text(
                          currentStep == 1
                              ? "التالي: بيانات العمل"
                              : "إتمام الإضافة",
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStep1() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTextField("الاسم الكامل", nameController, Icons.person_outline),
        const SizedBox(height: 16),
        _buildTextField(
          "البريد الإلكتروني",
          emailController,
          Icons.email_outlined,
        ),
        const SizedBox(height: 16),
        _buildPasswordField(),
      ],
    );
  }

  Widget _buildStep2() {
    final viewModel = context.watch<SupervisorViewModel>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "نوع العمل",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: workType,
          decoration: _inputDecoration(Icons.work_outline),
          items: const [
            DropdownMenuItem(value: "sweeping", child: Text("كنس")),
            DropdownMenuItem(value: "lifting", child: Text("رفع")),
          ],
          onChanged: (value) {
            setState(() {
              workType = value!;
              selectedArea = null;
            });
            context.read<SupervisorViewModel>().loadAreas(workType);
          },
        ),
        const SizedBox(height: 20),
        const Text(
          "المربع المسؤول",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<AreaDetailModel>(
          value: selectedArea,
          hint: const Text("اختر المنطقة"),
          decoration: _inputDecoration(Icons.location_on_outlined),
          items:
              viewModel.areas.map((area) {
                return DropdownMenuItem<AreaDetailModel>(
                  value: area,
                  child: Text(area.label ?? area.name ?? area.id.toString()),
                );
              }).toList(),
          onChanged: (value) {
            setState(() => selectedArea = value);
            if (value != null) {
              debugPrint(
                "📍 Selected Area: ID=${value.id}, Name=${value.squareName}, Start=${value.startTime}, Period=${value.period}",
              );
            }
          },
        ),

        // عرض تفاصيل المربع المختار تلقائياً
        if (selectedArea != null) ...[
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.green.withOpacity(0.05),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.green.withOpacity(0.2)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      workType == "sweeping"
                          ? Icons.map_outlined
                          : Icons.access_time,
                      size: 16,
                      color: Colors.green,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      workType == "sweeping"
                          ? "نطاق الشوارع:"
                          : "النظام الزمني:",
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  workType == "sweeping"
                      ? "من: ${selectedArea!.nameStartStreet ?? '-'} \nإلى: ${selectedArea!.nameEndStreet ?? '-'}"
                      : "الفترة: ${selectedArea!.period ?? '-'} \nالوقت: ${selectedArea!.startTime?.substring(0, 5) ?? '-'} - ${selectedArea!.endTime?.substring(0, 5) ?? '-'}",
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey.shade700,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller,
    IconData icon,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
        const SizedBox(height: 8),
        TextField(controller: controller, decoration: _inputDecoration(icon)),
      ],
    );
  }

  Widget _buildPasswordField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "كلمة المرور",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: passwordController,
          obscureText: !isPasswordVisible,
          decoration: _inputDecoration(Icons.lock_outline).copyWith(
            suffixIcon: IconButton(
              icon: Icon(
                isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                size: 20,
              ),
              onPressed:
                  () => setState(() => isPasswordVisible = !isPasswordVisible),
            ),
          ),
        ),
      ],
    );
  }

  InputDecoration _inputDecoration(IconData icon) {
    return InputDecoration(
      prefixIcon: Icon(icon, size: 20, color: const Color(0xFF10B981)),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade200),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade200),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFF10B981)),
      ),
      filled: true,
      fillColor: Colors.grey.shade50,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    );
  }

  // تنفيذ الخطوة الأولى (Firebase + createUser API)
  Future<void> _handleStep1() async {
    if (nameController.text.isEmpty ||
        emailController.text.isEmpty ||
        passwordController.text.isEmpty) {
      _showError("يرجى إكمال جميع الحقول");
      return;
    }

    setState(() => internalLoading = true);
    try {
      // 1. استخدام Firebase App ثانوي لإنشاء الحساب دون تسجيل خروج الآدمن
      FirebaseApp secondaryApp;
      try {
        secondaryApp = Firebase.app('SecondaryAdd');
      } catch (e) {
        secondaryApp = await Firebase.initializeApp(
          name: 'SecondaryAdd',
          options: Firebase.app().options,
        );
      }

      final secondaryAuth = FirebaseAuth.instanceFor(app: secondaryApp);

      // إنشاء الحساب
      final userCredential = await secondaryAuth.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      // 2. الحصول على ID Token للمشرف الجديد
      final idToken = await userCredential.user!.getIdToken();
      newSupervisorFirebaseToken = idToken;

      // 3. API login (الذي ينشئ المشرف ويرجع التوكن)
      if (mounted) {
        final result = await context
            .read<SupervisorViewModel>()
            .createServerAccount(idToken!, nameController.text.trim());

        if (result != null) {
          setState(() {
            newSupervisorId = result['id'];
            newSupervisorServerToken =
                result['token']; // هذا هو توكن الباك إيند المهم
            currentStep = 2;
            internalLoading = false;
          });
        } else {
          _showError("فشل إنشاء الحساب بالسيرفر");
          setState(() => internalLoading = false);
        }
      }

      // تسجيل الخروج من التطبيق الثانوي فوراً لتنظيف الجلسة
      await secondaryAuth.signOut();
    } on FirebaseAuthException catch (e) {
      _showError("خطأ في Firebase: ${e.message}");
      setState(() => internalLoading = false);
    } catch (e) {
      debugPrint("❌ Error in Step 1: $e");
      _showError("حدث خطأ غير متوقع: $e");
      setState(() => internalLoading = false);
    }
  }

  // تنفيذ الخطوة الثانية (insertInformationUser API)
  Future<void> _handleStep2() async {
    if (selectedArea == null) {
      _showError("يرجى تحديد المنطقة");
      return;
    }

    setState(() => internalLoading = true);
    try {
      final success = await context
          .read<SupervisorViewModel>()
          .completeSupervisorData(
            workType,
            selectedArea!.id.toString(),
            userId: newSupervisorId,
            firebaseToken: newSupervisorFirebaseToken,
            serverToken: newSupervisorServerToken,
          );

      if (success) {
        if (mounted) {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("تمت إضافة المشرف بنجاح")),
          );
        }
      } else {
        _showError("فشل حفظ بيانات المشرف");
      }
    } catch (e) {
      _showError("خطأ: $e");
    } finally {
      if (mounted) setState(() => internalLoading = false);
    }
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), backgroundColor: Colors.redAccent),
    );
  }
}
