import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:web2/dashboard/view/dashboard_view.dart';
import '../viewmodel/login_viewmodel.dart';

const primaryGreen = Color(0xFF13A8CA);
const primaryBrown = Color(0xFF497B93);

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
  Widget build(BuildContext context) {

    final authVM = context.watch<LoginViewModel>();
    final screenHeight = MediaQuery.of(context).size.height;

    return Directionality(
      textDirection: TextDirection.ltr,
      child: Scaffold(
        body: Stack(
          children: [

            /// الخلفية
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF20859F), Color(0xFF195268)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),

            /// الحاوية
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
                  padding: const EdgeInsets.all(25),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [

                        const Icon(Icons.forest_rounded,
                            size: 40, color: primaryGreen),

                        const SizedBox(height: 10),

                        const Text(
                          "Welcome ",
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: primaryGreen,
                          ),
                        ),

                        const SizedBox(height: 30),

                        /// Email
                        buildTextField(
                          controller: emailController,
                          label: "Email",
                          hint: "Enter Email",
                          isEmail: true,
                        ),

                        const SizedBox(height: 20),

                        /// Password
                        buildTextField(
                          controller: passwordController,
                          label: "Password",
                          hint: "Enter Password",
                          isPassword: true,
                        ),

                        const SizedBox(height: 30),

                        /// زر الدخول
                        SizedBox(
                          width: double.infinity,
                          height: 55,
                          child: ElevatedButton(

                            onPressed: authVM.isLoading
                                ? null
                                : () async {

                              if (!_formKey.currentState!.validate()) return;

                              final user = await context
                                  .read<LoginViewModel>()
                                  .signIn(
                                emailController.text.trim(),
                                passwordController.text.trim(),
                              );

                              if (user != null && context.mounted) {

                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const DashboardView(),
                                  ),
                                );

                              } else {

                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text("فشل تسجيل الدخول"),
                                  ),
                                );
                              }
                            },

                            style: ElevatedButton.styleFrom(
                              backgroundColor: primaryBrown,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                            ),

                            child: authVM.isLoading
                                ? const CircularProgressIndicator(
                              color: Colors.white,
                            )
                                : const Text(
                              "Sign In",
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),

                      ],
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
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

        Text(label),

        const SizedBox(height: 8),

        TextFormField(
          controller: controller,
          obscureText: isPassword ? _isObscure : false,

          validator: (value) {

            if (value == null || value.isEmpty) {
              return "يجب تعبئة الحقل";
            }

            if (isEmail) {
              final emailRegex =
              RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w]{2,4}$');

              if (!emailRegex.hasMatch(value)) {
                return "اكتب ايميل صحيح";
              }
            }

            if (isPassword && value.length < 6) {
              return "كلمة المرور ضعيفة";
            }

            return null;
          },

          decoration: InputDecoration(
            hintText: hint,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
            ),

            suffixIcon: isPassword
                ? IconButton(
              icon: Icon(
                _isObscure
                    ? Icons.visibility_off
                    : Icons.visibility,
              ),
              onPressed: () {
                setState(() {
                  _isObscure = !_isObscure;
                });
              },
            )
                : null,
          ),
        ),
      ],
    );
  }
}