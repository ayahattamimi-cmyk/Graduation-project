import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:web2/login%20screen/view/login_view.dart';
import 'package:web2/login%20screen/viewmodel/login_viewmodel.dart';
import 'package:web2/notification/viewmodel/notification_viewmodel.dart';

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
    required this.currentPage,
    required this.onPageSelected,
  });

  @override
  Widget build(BuildContext context) {
    // الاستماع لبيانات الإشعارات لعرض العداد
    final notificationVM = context.watch<NotificationsViewModel>();

    return Container(
      width: 250,
      color: Colors.white,
      child: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: constraints.maxHeight - 48,
              ),
              child: IntrinsicHeight(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Image.asset(
                          'assets/images/lorem.png',
                          width: 60,
                          height: 60,
                          fit: BoxFit.contain,
                          errorBuilder:
                              (context, error, stackTrace) => const Icon(
                                Icons.eco,
                                color: Color(0xFF10B981),
                                size: 28,
                              ),
                        ),
                        const SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'نظام البلاغات',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w900,
                                color: Color(0xFF064E3B),
                              ),
                            ),
                            Text(
                              'الإدارة المركزية',
                              style: TextStyle(
                                fontSize: 11,
                                color: Colors.grey.shade500,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),

                    _item('لوحة التحكم', Icons.home, AppPage.dashboard),

                    _item(
                      'الإشعارات',
                      Icons.notifications,
                      AppPage.notifications,
                      badgeCount:
                          notificationVM.unreadCount, // تمرير عدد الإشعارات
                    ),

                    _item(
                      'توجيه البلاغات',
                      Icons.alt_route,
                      AppPage.assignReports,
                    ),
                    _item('الخريطة', Icons.map, AppPage.map),
                    _item('إدارة المشرفين', Icons.people, AppPage.admins),

                    const Divider(height: 32),

                    _item('الأخبار والنصائح', Icons.article, AppPage.news),
                    _item(
                      'مواقع الرفع',
                      Icons.cloud_upload,
                      AppPage.uploadSites,
                    ),
                    _item('التقارير', Icons.bar_chart, AppPage.reports),

                    const Spacer(),
                    const Divider(),
                    _item(
                      'تسجيل الخروج',
                      Icons.logout,
                      AppPage.dashboard,
                      isLogout: true,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _item(
    String title,
    IconData icon,
    AppPage page, {
    bool isLogout = false,
    int badgeCount = 0, // إضافة متغير العداد
  }) {
    final bool active = !isLogout && currentPage == page;

    return Builder(
      builder:
          (context) => InkWell(
            onTap: () async {
              if (isLogout) {
                final confirm = await showDialog<bool>(
                  context: context,
                  builder:
                      (ctx) => Directionality(
                        textDirection: TextDirection.rtl,
                        child: AlertDialog(
                          title: const Text("تسجيل الخروج"),
                          content: const Text(
                            "هل أنت متأكد من رغبتك في تسجيل الخروج؟",
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(ctx, false),
                              child: const Text("إلغاء"),
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.redAccent,
                              ),
                              onPressed: () => Navigator.pop(ctx, true),
                              child: const Text(
                                "خروج",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                      ),
                );

                if (confirm == true) {
                  if (context.mounted) {
                    await context.read<LoginViewModel>().signOut();
                    if (context.mounted) {
                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (_) => const LoginScreen()),
                        (route) => false,
                      );
                    }
                  }
                }
              } else {
                onPageSelected(page);
              }
            },
            child: Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: active ? const Color(0xfff0fdf4) : Colors.transparent,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(
                    icon,
                    color:
                        isLogout
                            ? Colors.redAccent
                            : (active
                                ? const Color(0xFF10B981)
                                : Colors.black54),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      title,
                      style: TextStyle(
                        color: isLogout ? Colors.redAccent : Colors.black87,
                        fontWeight:
                            isLogout ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  ),
                  // رص العارضة (Badge) إذا كان هناك إشعارات
                  if (badgeCount > 0 && !isLogout)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.redAccent,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        badgeCount > 99 ? "+99" : badgeCount.toString(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
    );
  }
}
