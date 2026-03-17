
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:web2/dashboard/view/dashboard_view.dart';
import '../viewmodel/login_viewmodel.dart';

import '../../supervisors/viewmodel/supervisor_viewmodel.dart';
import '../../supervisors/model/supervisor_model.dart';

const primaryGreen = Color(0xFF13A8CA);
const primaryBrown = Color(0xFF497B93);

class LoginScreen extends StatefulWidget {
final bool isSignup;
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

/// الحاوية البيضاء
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

const Icon(
Icons.forest_rounded,
size: 40,
color: primaryGreen,
),

const SizedBox(height: 10),

Text(
isSignupMode
? "Get Started"
    : "Welcome Back",

style: const TextStyle(
fontSize: 28,
fontWeight: FontWeight.bold,
color: primaryGreen,
),
),

const SizedBox(height: 30),

/// الاسم
if (isSignupMode) ...[
buildTextField(
controller: nameController,
label: "Full Name",
hint: "Enter Full Name",
),
const SizedBox(height: 20),
],

/// ايميل
buildTextField(
controller: emailController,
label: "Email",
hint: "Enter Email",
isEmail: true,
),

const SizedBox(height: 20),

/// باسورد
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

if (!_formKey.currentState!.validate()) {
return;
}

final authVM = context.read<LoginViewModel>();
final supervisorVM =
context.read<SupervisorViewModel>();

if (isSignupMode) {

await authVM.signUp(
emailController.text.trim(),
passwordController.text.trim(),
);

final supervisor = SupervisorModel(
id: DateTime.now()
    .millisecondsSinceEpoch,
name: widget.supervisorName ??
nameController.text,
type: widget.supervisorType ?? "",
area: widget.supervisorArea ?? "",
squareName:
widget.supervisorArea ?? "",
);

supervisorVM.addSupervisor(supervisor);

} else {

await authVM.signIn(
emailController.text.trim(),
passwordController.text.trim(),
);

}

if (context.mounted) {
Navigator.pushReplacement(
context,
MaterialPageRoute(
builder: (_) =>
const DashboardView(),
),
);
}
},

style: ElevatedButton.styleFrom(
backgroundColor: primaryBrown,
shape: RoundedRectangleBorder(
borderRadius:
BorderRadius.circular(15),
),
),

child: authVM.isLoading
? const CircularProgressIndicator(
color: Colors.white,
)
    : Text(
isSignupMode
? "Sign Up"
    : "Sign In",
style: const TextStyle(
fontSize: 18,
color: Colors.white,
),
),
),
),

const SizedBox(height: 30),

/// تغيير الحالة
Row(
mainAxisAlignment:
MainAxisAlignment.center,
children: [

Text(
isSignupMode
? "Already have an account?"
    : "Don't have an account?",
),

const SizedBox(width: 5),

GestureDetector(
onTap: () {
setState(() {
isSignupMode = !isSignupMode;
});
},

child: Text(
isSignupMode
? "Sign In"
    : "Sign Up",

style: const TextStyle(
color: Colors.blue,
fontWeight: FontWeight.bold,
),
),
)
],
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
textDirection: TextDirection.ltr,
obscureText: isPassword ? _isObscure : false,

validator: (value) {

if (value == null || value.isEmpty) {
return "يجب عليك تعبئة الحقل";
}

if (isEmail) {

final emailRegex =
RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w]{2,4}$');

if (!emailRegex.hasMatch(value)) {
return "اكتب ايميل بشكل صحيح";
}
}

if (isPassword) {

if (value.length < 8) {
return "كلمة المرور يجب أن تكون 8 أحرف على الأقل";
}
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


