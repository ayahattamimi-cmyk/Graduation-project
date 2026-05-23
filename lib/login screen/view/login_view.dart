import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:web2/dashboard/view/dashboard_view.dart';
import '../viewmodel/login_viewmodel.dart';
import 'widgets/login_text_field.dart';
import 'widgets/auth_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isObscure = true;

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authVM = context.watch<LoginViewModel>();

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF064E3B), // Deep Emerald
                Color(0xFF022C22), // Darker Emerald
                Color(0xFF064E3B),
              ],
            ),
          ),
          child: Stack(
            children: [
              /// تأثير دوائر ضوئية خفيفة في الخلفية
              Positioned(
                top: -100,
                right: -100,
                child: Container(
                  width: 300,
                  height: 300,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(0.03),
                  ),
                ),
              ),
              Positioned(
                bottom: -50,
                left: -50,
                child: Container(
                  width: 250,
                  height: 250,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color(0xFF10B981).withOpacity(0.05),
                  ),
                ),
              ),

              Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      /// العنوان العلوي
                      const Icon(
                        Icons.eco_rounded,
                        size: 48,
                        color: Color(0xFF34D399),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        "نظام إدارة البلاغات",
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 24),

                      /// بطاقة تسجيل الدخول
                      Container(
                        width:
                            MediaQuery.of(context).size.width > 600
                                ? 480
                                : double.infinity,
                        margin: const EdgeInsets.symmetric(horizontal: 24),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 32,
                          vertical: 32,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(28),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 30,
                              offset: const Offset(0, 15),
                            ),
                          ],
                        ),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Text(
                                    "تسجيل الدخول",
                                    style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF064E3B),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  const Text(
                                    "🌿",
                                    style: TextStyle(fontSize: 22),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Text(
                                "يرجى إدخال بياناتك للمتابعة",
                                style: TextStyle(
                                  color: Colors.grey.shade500,
                                  fontSize: 13,
                                ),
                              ),
                              const SizedBox(height: 24),

                              const Text(
                                "البريد الإلكتروني",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF374151),
                                ),
                              ),
                              const SizedBox(height: 8),
                              LoginTextField(
                                controller: emailController,
                                label: "",
                                hint: "admin@environment.gov",
                                isEmail: true,
                              ),

                              const SizedBox(height: 20),

                              const Text(
                                "كلمة المرور",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF374151),
                                ),
                              ),
                              const SizedBox(height: 8),
                              LoginTextField(
                                controller: passwordController,
                                label: "",
                                hint: "••••••••",
                                isPassword: true,
                                isObscure: _isObscure,
                                onToggleObscure:
                                    () => setState(
                                      () => _isObscure = !_isObscure,
                                    ),
                              ),

                              const SizedBox(height: 32),

                              AuthButton(
                                isLoading: authVM.isLoading,
                                text: "دخول للنظام",
                                onPressed: _processAuth,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _processAuth() async {
    if (!_formKey.currentState!.validate()) return;

    try {
      final authVM = context.read<LoginViewModel>();
      User? user = await authVM.signIn(
        emailController.text.trim(),
        passwordController.text.trim(),
      );

      if (user != null && mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const DashboardView()),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("فشل تسجيل الدخول: ${e.toString()}"),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    }
  }
}
