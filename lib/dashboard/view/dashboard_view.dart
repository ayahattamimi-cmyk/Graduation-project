import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodel/dashboard_viewmodel.dart';
import 'sidebar.dart';
import 'stat_card.dart';
import 'chart_box.dart';
import '../../notification/view/notifications_page.dart';
import '../../content/view/ContentPage.dart';
import '../../supervisors/view/supervisor_page.dart';

class DashboardView extends StatefulWidget {
  const DashboardView({super.key});

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {

  AppPage currentPage = AppPage.dashboard;

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      context.read<DashboardViewModel>().loadStats();
    });
  }

  @override
  Widget build(BuildContext context) {

    final vm = context.watch<DashboardViewModel>();

    return Scaffold(
      backgroundColor: const Color(0xfff6f8fb),

      body: Row(
        children: [

          Sidebar(
            currentPage: currentPage,
            onPageSelected: (page) {
              setState(() {
                currentPage = page;
              });
            },
          ),

          Expanded(child: _buildContent(vm)),

        ],
      ),
    );
  }

  Widget _buildContent(DashboardViewModel vm) {

    switch (currentPage) {

      case AppPage.dashboard:
        return _dashboardContent(vm);

      case AppPage.notifications:
        return const NotificationsPage();

      case AppPage.assignReports:
        return const Center(child: Text('توجيه البلاغات'));

      case AppPage.map:
        return const Center(child: Text('الخريطة'));

      case AppPage.admins:
        return const SupervisorPage();

      case AppPage.news:
        return const ContentPage();

      case AppPage.uploadSites:
        return const Center(child: Text('مواقع الرفع'));

      case AppPage.reports:
        return const Center(child: Text('التقارير'));
    }
  }

  Widget _dashboardContent(DashboardViewModel vm) {

    return Padding(
      padding: const EdgeInsets.all(24),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          const Text(
            'لوحة التحكم',
            style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 24),

          Row(
            children: [

              Expanded(
                child: StatCard(
                  title: 'إجمالي البلاغات',
                  value: vm.totalReports,
                  subtitle: 'جميع البلاغات المسجلة',
                  icon: Icons.trending_up,
                  color: Colors.blue,
                ),
              ),

              const SizedBox(width: 16),

              Expanded(
                child: StatCard(
                  title: 'البلاغات المحلولة',
                  value: vm.resolvedReports,
                  subtitle: 'نسبة البلاغات المنجزة',
                  icon: Icons.check_circle,
                  color: Colors.green,
                ),
              ),

              const SizedBox(width: 16),

              Expanded(
                child: StatCard(
                  title: 'قيد المعالجة',
                  value: vm.processingReports,
                  subtitle: 'بلاغات تحت الإجراء',
                  icon: Icons.schedule,
                  color: Colors.orange,
                ),
              ),

              const SizedBox(width: 16),

              Expanded(
                child: StatCard(
                  title: 'المناطق النشطة',
                  value: vm.activeAreas,
                  subtitle: 'مربعات جغرافية مسجلة',
                  icon: Icons.location_on,
                  color: Colors.purple,
                ),
              ),

            ],
          ),

          const SizedBox(height: 24),

          Row(
            children: const [

              Expanded(child: ChartBox(title: 'التتبع الشهري')),

              SizedBox(width: 16),

              Expanded(child: ChartBox(title: 'تصنيف البلاغات')),

            ],
          ),

          const SizedBox(height: 24),

          const Expanded(
            child: ChartBox(title: 'أكثر المناطق تفاعلاً'),
          ),

        ],
      ),
    );
  }
}