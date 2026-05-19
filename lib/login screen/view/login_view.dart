import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:web2/dashboard/view/dashboard_view.dart';
import '../viewmodel/login_viewmodel.dart';
import '../../supervisors/viewmodel/supervisor_viewmodel.dart';
import '../../supervisors/data/model/supervisor_model.dart';

class LoginScreen extends StatefulWidget {
  final bool isSignup; // نتحكم من خلالها هل الشاشة للدخول أم لإنشاء مشرف
  final String? supervisorName;
  final String? supervisorType;
  final String? supervisorArea;

  const LoginScreen({
    super.key,
    this.isSignup = false,
    this.supervisorName,
    this.supervisorType,
    this.supervisorArea,
  });

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isObscure = true;
  late bool isSignupMode;

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    isSignupMode = widget.isSignup;
  }

  @override
  Widget build(BuildContext context) {
    final authVM = context.watch<LoginViewModel>();
    final screenHeight = MediaQuery.of(context).size.height;

    return Directionality(
      textDirection: TextDirection.ltr,
      child: Scaffold(
        body: Stack(
          children: [
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF20859F), Color(0xFF195268)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: screenHeight * 0.8,
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40),
                    topRight: Radius.circular(40),
                  ),
                ),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(30),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        const Icon(
                          Icons.forest_rounded,
                          size: 50,
                          color: Color(0xFF13A8CA),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          isSignupMode ? "Create Account" : "Welcome Back",
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF13A8CA),
                          ),
                        ),
                        const SizedBox(height: 30),

                        if (isSignupMode) ...[
                          buildTextField(
                            controller: nameController,
                            label: "Full Name",
                            hint: "Enter name",
                          ),
                          const SizedBox(height: 20),
                        ],
                        buildTextField(
                          controller: emailController,
                          label: "Email",
                          hint: "Enter email",
                          isEmail: true,
                        ),
                        const SizedBox(height: 20),
                        buildTextField(
                          controller: passwordController,
                          label: "Password",
                          hint: "Enter password",
                          isPassword: true,
                        ),
                        const SizedBox(height: 30),

                        SizedBox(
                          width: double.infinity,
                          height: 55,
                          child: ElevatedButton(
                            onPressed: authVM.isLoading ? null : _processAuth,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF497B93),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                            ),
                            child:
                                authVM.isLoading
                                    ? const CircularProgressIndicator(
                                      color: Colors.white,
                                    )
                                    : Text(
                                      isSignupMode ? "Sign Up" : "Sign In",
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                      ),
                                    ),
                          ),
                        ),

                        const SizedBox(height: 20),
                        // زر التبديل بين الدخول والإنشاء
                        TextButton(
                          onPressed:
                              () =>
                                  setState(() => isSignupMode = !isSignupMode),
                          child: Text(
                            isSignupMode
                                ? "Already have an account? Sign In"
                                : "Don't have an account? Sign Up",
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _processAuth() async {
    if (!_formKey.currentState!.validate()) return;

    try {
      final authVM = context.read<LoginViewModel>();
      final supervisorVM = context.read<SupervisorViewModel>();
      User? user;

      if (isSignupMode) {
        user = await authVM.signUp(
          emailController.text.trim(),
          passwordController.text.trim(),
        );
        if (user != null) {
          // إضافة بيانات المشرف لـ لارفل/فايربيس
          final supervisor = SupervisorModel(
            id: DateTime.now().millisecondsSinceEpoch,
            name: widget.supervisorName ?? nameController.text,
            type: widget.supervisorType ?? "",
            area: widget.supervisorArea ?? "",
            areaDetails: [],
          );
          await supervisorVM.addSupervisor(supervisor);
        }
      } else {
        user = await authVM.signIn(
          emailController.text.trim(),
          passwordController.text.trim(),
        );
      }

      if (user != null && mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const DashboardView()),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  Widget buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    bool isPassword = false,
    bool isEmail = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          obscureText: isPassword ? _isObscure : false,
          decoration: InputDecoration(
            hintText: hint,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
            suffixIcon:
                isPassword
                    ? IconButton(
                      icon: Icon(
                        _isObscure ? Icons.visibility_off : Icons.visibility,
                      ),
                      onPressed: () => setState(() => _isObscure = !_isObscure),
                    )
                    : null,
          ),
          validator:
              (value) =>
                  (value == null || value.isEmpty) ? "Field required" : null,
        ),
      ],
    );
  }
}
