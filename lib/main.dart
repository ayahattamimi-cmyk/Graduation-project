import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:web2/supervisors/viewmodel/supervisor_viewmodel.dart';

import 'content/viewmodel/content_viewmodel.dart';
import 'login screen/data/firebase_options.dart';

import 'login screen/view/login_view.dart';
import 'login screen/viewmodel/login_viewmodel.dart';

import 'dashboard/viewmodel/dashboard_viewmodel.dart';
import 'notification/viewmodel/notification_viewmodel.dart';


void main() async {

  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    MultiProvider(
      providers: [

        ChangeNotifierProvider(
          create: (_) => LoginViewModel(),
        ),

        ChangeNotifierProvider(
          create: (_) => DashboardViewModel(),
        ),
        ChangeNotifierProvider(
          create: (_) => NotificationsViewModel(),
        ),
        ChangeNotifierProvider(
          create: (_) => ContentViewModel(),
        ),
        ChangeNotifierProvider(
          create: (_) => SupervisorViewModel(),
        ),

      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      debugShowCheckedModeBanner: false,

      locale: const Locale('ar'),

      builder: (context, child) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: child!,
        );
      },

      home: const LoginScreen(),
    );
  }
}