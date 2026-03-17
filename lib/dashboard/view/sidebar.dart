import 'package:flutter/material.dart';

enum AppPage {
  dashboard,
  notifications,
  assignReports,
  map,
  admins,
  news,
  uploadSites,
  reports,
}

class Sidebar extends StatelessWidget {
  final AppPage currentPage;
  final Function(AppPage) onPageSelected;

  const Sidebar({
    super.key,
    required this.currentPage,//required يعني لازم امرر قيمتها
    required this.onPageSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250,
      color: Colors.white,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'نظام إدارة البلاغات',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 24),

          _item('لوحة التحكم', Icons.home, AppPage.dashboard),
          _item('الإشعارات', Icons.notifications, AppPage.notifications),
          _item('توجيه البلاغات', Icons.alt_route, AppPage.assignReports),
          _item('الخريطة', Icons.map, AppPage.map),
          _item('إدارة المشرفين', Icons.people, AppPage.admins),

          const Divider(height: 32),//خط فاصل بين أقسام القائمة.

          _item('الأخبار والنصائح', Icons.article, AppPage.news),
          _item('مواقع الرفع', Icons.cloud_upload, AppPage.uploadSites),
          _item('التقارير', Icons.bar_chart, AppPage.reports),
        ],
      ),
    );
  }

  Widget _item(String title, IconData icon, AppPage page) {
    final bool active = currentPage == page;

    return InkWell(//العنصر الموجود يكون قابل للضغط عليه
      onTap: () => onPageSelected(page),
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: active ? const Color(0xffeef4ff) : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Icon(icon, color: active ? Colors.blue : Colors.black54),
            const SizedBox(width: 10),
            Text(title),
          ],
        ),
      ),
    );
  }
}
