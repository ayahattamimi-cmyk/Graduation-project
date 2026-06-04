import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:web2/core/network/api_service.dart';
import 'package:web2/core/network/dio_client.dart';
import 'package:web2/core/services/shared_pref.dart';
import 'package:web2/dashboard/data/dashboard_repository.dart';
import 'package:web2/dashboard/data/dashboard_service.dart';
import 'package:web2/dashboard/view/dashboard_view.dart';
import 'package:web2/drop_locations/data/container_repository.dart';
import 'package:web2/drop_locations/data/container_service.dart';
import 'package:web2/drop_locations/viewmodel/drop_locations_viewmodel.dart';
import 'package:web2/reports/data/report_repository.dart';
import 'package:web2/reports/data/report_service.dart';
import 'package:web2/reports/viewmodel/reports_viewmodel.dart';
import 'package:web2/supervisors/data/supervisor_repository.dart';
import 'package:web2/supervisors/data/supervisor_service.dart';
import 'firebase_options.dart';
import 'package:web2/supervisors/viewmodel/supervisor_viewmodel.dart';
import 'content/viewmodel/content_viewmodel.dart';
import 'content/data/content_repository.dart';
import 'content/data/content_service.dart';
import 'login screen/view/login_view.dart';
import 'login screen/viewmodel/login_viewmodel.dart';
import 'dashboard/viewmodel/dashboard_viewmodel.dart';
import 'map/view/map_screen.dart';
import 'notification/viewmodel/notification_viewmodel.dart';
import 'package:web2/login%20screen/data/AuthService.dart';
import 'notification/data/notification_repository.dart';
import 'notification/data/notification_service.dart';
import 'report_assignment/data/assignment_repository.dart';
import 'report_assignment/data/assignment_service.dart';
import 'report_assignment/viewmodel/assignment_viewmodel.dart';
import 'map/data/map_repository.dart';
import 'map/data/map_service.dart';
import 'map/viewmodel/map_viewmodel.dart';
import 'package:google_fonts/google_fonts.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  final String? token = await SharedPrefsService.getToken();
  debugPrint("🔑 Startup Token: $token");
  final bool isLoggedIn = token != null && token.isNotEmpty;
  debugPrint("✅ Is User Logged In: $isLoggedIn");

  final dioClient = DioClient();

  //  نقوم بإنشاء نسخة الـ ApiService الموحدة هنا باستخدام الـ dioClient المجهز للمشروع بالكامل
  final apiService = ApiService(dioClient);

  runApp(
    MultiProvider(
      providers: [
        // 1. حقن الـ ApiService الموحد ليكون متاحاً لكل الفيو مودلز بالأسفل
        Provider<ApiService>.value(value: apiService),

        ChangeNotifierProvider(
          create: (_) => LoginViewModel(AuthService(apiService)),
        ),

        ChangeNotifierProvider(
          create:
              (context) => DashboardViewModel(
                DashboardRepository(DashboardService(apiService)),
              ),
        ),

        ChangeNotifierProvider(
          create:
              (_) => NotificationsViewModel(
                NotificationRepository(NotificationService(apiService)),
              ),
        ),

        Provider<NotificationRepository>(
          create:
              (_) => NotificationRepository(NotificationService(apiService)),
        ),

        ChangeNotifierProvider(
          create:
              (context) => NewsTipsViewModel(
                NewsRepository(ContentService(context.read<ApiService>())),
              ),
        ),

        // --- قسم المشرفين ---
        ChangeNotifierProvider(
          create:
              (context) => SupervisorViewModel(
                SupervisorRepository(SupervisorService(apiService)),
              ),
        ),

        ChangeNotifierProvider(
          create:
              (context) => DropLocationsViewModel(
                ContainerRepository(ContainerService(apiService)),
                SupervisorRepository(SupervisorService(apiService)),
              ),
        ),

        ChangeNotifierProvider(
          create:
              (context) => ReportViewModel(
                ReportRepository(ReportService(apiService)),
                SupervisorRepository(SupervisorService(apiService)),
              ),
        ),

        ChangeNotifierProvider(
          create:
              (context) => AssignmentViewModel(
                AssignmentRepository(AssignmentService(apiService)),
                SupervisorRepository(SupervisorService(apiService)),
              ),
        ),

        ChangeNotifierProvider(
          create:
              (context) => WebMapViewModel(
                WebMapRepository(MapService(context.read<ApiService>())),
              ),
        ),
      ],

      child: MyApp(isLoggedIn: isLoggedIn),
    ),
  );
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;
  const MyApp({super.key, required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'نظام إدارة البلاغات',
      theme: ThemeData(
        useMaterial3: true,
        primaryColor: const Color(0xFF10B981),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF059669),
          primary: const Color(0xFF10B981),
          secondary: const Color(0xFF34D399),
        ),
        textTheme: GoogleFonts.cairoTextTheme(),
      ),
      locale: const Locale('ar'),
      builder: (context, child) {
        return Directionality(textDirection: TextDirection.rtl, child: child!);
      },
      home: isLoggedIn ? const DashboardView() : const LoginScreen(),
      routes: {'/mapPage': (context) => const WebMapScreen()},
    );
  }
}
