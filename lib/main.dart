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
import 'login screen/data/firebase_options.dart';
import 'login screen/view/login_view.dart';
import 'login screen/viewmodel/login_viewmodel.dart';
import 'dashboard/viewmodel/dashboard_viewmodel.dart';
import 'notification/viewmodel/notification_viewmodel.dart';
import 'package:web2/login%20screen/data/AuthService.dart';
import 'notification/data/notification_repository.dart';
import 'notification/data/notification_service.dart';
import 'report_assignment/data/assignment_repository.dart';
import 'report_assignment/data/assignment_service.dart';
import 'report_assignment/viewmodel/assignment_viewmodel.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  final String? token = await SharedPrefsService.getToken();
  debugPrint("🔑 Startup Token: $token"); // جملة للتشخيص
  final bool isLoggedIn = token != null && token.isNotEmpty;
  debugPrint("✅ Is User Logged In: $isLoggedIn");

  final dioClient = DioClient();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => LoginViewModel(AuthService(dioClient.dio)),
        ),

        ChangeNotifierProvider(
          create:
              (context) => DashboardViewModel(
                DashboardRepository(DashboardService(dioClient.dio)),
              ),
        ),
        ChangeNotifierProvider(
          create:
              (_) => NotificationsViewModel(
                NotificationRepository(NotificationService(dioClient.dio)),
              ),
        ),
        Provider<NotificationRepository>(
          create:
              (_) => NotificationRepository(NotificationService(dioClient.dio)),
        ),
        // --- تعديل NewsTipsViewModel ليعمل مع السيرفر ---
        ChangeNotifierProvider(
          create:
              (context) => NewsTipsViewModel(
                NewsRepository(ContentService(ApiService(dioClient))),
              ),
        ),

        // --- تعديل المشرفين ليعمل عبر الـ ApiService الموحد ---
        ChangeNotifierProvider(
          create:
              (context) => SupervisorViewModel(
                SupervisorRepository(SupervisorService(dioClient.dio)),
              ),
        ),

        // --- تعديل مواقع الحاويات لضمان عمل التعديل والحذف ---
        ChangeNotifierProvider(
          create:
              (context) => DropLocationsViewModel(
                ContainerRepository(ContainerService(dioClient.dio)),
              ),
        ),
        ChangeNotifierProvider(
          create:
              (context) => ReportViewModel(
                ReportRepository(ReportService(dioClient.dio)),
                SupervisorRepository(
                  SupervisorService(dioClient.dio),
                ), // تمرير الريبو الثاني
              ),
        ),
        ChangeNotifierProvider(
          create:
              (context) => AssignmentViewModel(
                AssignmentRepository(AssignmentService(dioClient.dio)),
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
      locale: const Locale('ar'),
      builder: (context, child) {
        return Directionality(textDirection: TextDirection.rtl, child: child!);
      },
      home: isLoggedIn ? const DashboardView() : const LoginScreen(),
    );
  }
}
