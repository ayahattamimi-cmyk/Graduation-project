import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:web2/dashboard/view/dashboard_view.dart';
import 'dashboard/view/dashboard_page.dart';

class AppScreen extends StatelessWidget {
  const AppScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(1440, 900), // مقاس التصميم الأساسي
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: LayoutBuilder(
            builder: (context, constraints) {
              return Scaffold(
                body: SafeArea(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minWidth: constraints.maxWidth,
                      minHeight: constraints.maxHeight,
                    ),
                    child: const DashboardView(),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
