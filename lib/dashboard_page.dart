import 'package:flutter/material.dart';
import 'sidebar.dart';//عشان موضوع التنقل بين الصفحات
import 'stat_card.dart';
import 'chart_box.dart';
import 'notifications_page.dart';


class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  AppPage currentPage = AppPage.dashboard;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff6f8fb),
      body: Row(
        children: [
          Sidebar(//القائمة الجانبية
            currentPage: currentPage,
            onPageSelected: (page) {//دالة تستدعى لمن نضغط ع عنصر من القائمة
              setState(() {
                currentPage = page;
              });
            },
          ),
          Expanded(child: _buildContent()),

        ],
      ),
    );
  }

  Widget _buildContent() {
    switch (currentPage) {
      case AppPage.dashboard:
        return _dashboardContent();

      case AppPage.notifications:
        return const NotificationsPage();

      case AppPage.assignReports:
        return const Center(child: Text('توجيه البلاغات'));

      case AppPage.map:
        return const Center(child: Text('الخريطة'));

      case AppPage.admins:
        return const Center(child: Text('إدارة المشرفين'));

      case AppPage.news:
        return const Center(child: Text('الأخبار والنصائح'));

      case AppPage.uploadSites:
        return const Center(child: Text('مواقع الرفع'));

      case AppPage.reports:
        return const Center(child: Text('التقارير'));
    }
  }


  // لوحة التحكم
  Widget _dashboardContent() {
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

          //🔹 بطاقات الإحصائيات بتتعبى لمن تجي من الباك اند
          Row(
            children: [
              Expanded(
                child: StatCard(
                  title: 'إجمالي البلاغات',
                  subtitle: 'جميع البلاغات المسجلة',
                  icon: Icons.trending_up,
                  color: Colors.blue,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: StatCard(
                  title: 'البلاغات المحلولة',
                  subtitle: 'نسبة البلاغات المنجزة',
                  icon: Icons.check_circle,
                  color: Colors.green,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: StatCard(
                  title: 'قيد المعالجة',
                  subtitle: 'بلاغات تحت الإجراء',
                  icon: Icons.schedule,
                  color: Colors.orange,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: StatCard(
                  title: 'المناطق النشطة',
                  subtitle: 'مربعات جغرافية مسجلة',
                  icon: Icons.location_on,
                  color: Colors.purple,
                ),
              ),
            ],
          ),



          const SizedBox(height: 24),

          //حق الرسوم البيانية
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

  Widget _simplePage(String title) {
    return Center(
      child: Text(
        title,
        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      ),
    );
  }
}
