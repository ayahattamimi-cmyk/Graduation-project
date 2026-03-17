/*
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

import '../model/supervisor_model.dart';
import '../viewmodel/supervisor_viewmodel.dart';


class CreateSupervisorAccountPage extends StatefulWidget {

  final String name;
  final String type;
  final String area;

  const CreateSupervisorAccountPage({
    super.key,
    required this.name,
    required this.type,
    required this.area,
  });

  @override
  State<CreateSupervisorAccountPage> createState() =>
      _CreateSupervisorAccountPageState();
}

class _CreateSupervisorAccountPageState
    extends State<CreateSupervisorAccountPage> {

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool isLoading = false;

  Future<void> createAccount() async {

    final vm = context.read<SupervisorViewModel>();

    setState(() {
      isLoading = true;
    });

    try {

      FirebaseApp secondaryApp;

      try {

        /// إذا كان موجود
        secondaryApp = Firebase.app('Secondary');

      } catch (e) {

        /// إذا غير موجود أنشئه
        secondaryApp = await Firebase.initializeApp(
          name: 'Secondary',
          options: Firebase.app().options,
        );
      }

      final secondaryAuth =
      FirebaseAuth.instanceFor(app: secondaryApp);

      final result =
      await secondaryAuth.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      /// إنشاء المشرف
      final supervisor = SupervisorModel(
        id: DateTime.now().millisecondsSinceEpoch,
        name: widget.name,
        type: widget.type,
        area: widget.area,
        squareName: widget.area,
      );

      /// إضافته في الجدول
      vm.addSupervisor(supervisor);

      Navigator.pop(context);

    } catch (e) {

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("خطأ: $e"),
        ),
      );

    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor: const Color(0xfff6f8fb),

      appBar: AppBar(
        title: const Text("إنشاء حساب للمشرف"),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.black,
      ),

      body: Center(

        child: Container(

          width: 450,
          padding: const EdgeInsets.all(30),

          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),

          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [

              Text(
                "المشرف: ${widget.name}",
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 25),

              const Text("الإيميل"),

              const SizedBox(height: 8),

              TextField(
                controller: emailController,
                decoration: const InputDecoration(
                  hintText: "أدخل الإيميل",
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 20),

              const Text("كلمة المرور"),

              const SizedBox(height: 8),

              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  hintText: "أدخل كلمة المرور",
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 30),

              SizedBox(
                width: double.infinity,

                child: ElevatedButton(

                  onPressed: isLoading ? null : createAccount,

                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      vertical: 16,
                    ),
                  ),

                  child: isLoading
                      ? const CircularProgressIndicator()
                      : const Text(
                    "إنشاء الحساب",
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              )

            ],
          ),
        ),
      ),
    );
  }
}

 */