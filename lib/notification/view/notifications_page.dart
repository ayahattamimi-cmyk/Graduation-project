import 'package:flutter/material.dart';
import 'package:web2/notification/viewmodel/notification_viewmodel.dart';
import '../../dashboard/view/sidebar.dart';
import 'notification_details_page.dart';
import 'package:provider/provider.dart';

class NotificationsPage extends StatefulWidget {

  final Function(AppPage) onPageSelected;

  const NotificationsPage({
    super.key,
    required this.onPageSelected,
  });

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();

  static Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  static Widget _notificationItem(
    BuildContext context, {
    required String id,
    required int reportId,
    required String category,
    required String priority,
    required String days,
    required String status,
    required String notificationId,
    required bool isRead,
  }) {
    // تحديد الألوان بناء على الحالة والتقدم
    final bool isResolved = status == "تم الحل" ||
        status == "محلول" ||
        status == "تم إنجازه" ||
        status == "solved" ||
        status == "resolved";

    Color backgroundColor;
    Color borderColor;
    Color indicatorColor;

    if (isResolved) {
      backgroundColor = const Color(0xffE8F5E9); // أخضر خفيف جداً للبلاغات المنجزة
      borderColor = const Color(0xffC8E6C9);
      indicatorColor = Colors.green.shade600;
    } else if (!isRead) {
      backgroundColor = const Color(0xffE3F2FD); // أزرق خفيف جداً لغير المقروء
      borderColor = const Color(0xffBBDEFB);
      indicatorColor = Colors.blue.shade600;
    } else {
      backgroundColor = const Color(0xffF5F5F5); // رمادي خفيف جداً للمقروء
      borderColor = const Color(0xffE0E0E0);
      indicatorColor = Colors.grey.shade400;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: borderColor),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(13),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // الشريط الجانبي الملون لجمالية فائقة
              Container(
                width: 6,
                color: indicatorColor,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              id, 
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: isRead && !isResolved ? Colors.black54 : Colors.black87,
                              )
                            ),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                _tagChip(category, Colors.blue.shade100, Colors.blue),
                                const SizedBox(width: 6),
                                _tagChip(
                                  priority,
                                  priority == 'عاجل'
                                      ? Colors.red.shade100
                                      : Colors.orange.shade100,
                                  priority == 'عاجل' ? Colors.red : Colors.orange,
                                ),
                                if (isResolved) ...[
                                  const SizedBox(width: 6),
                                  _tagChip(
                                    "تم الإنجاز ✓",
                                    Colors.green.shade100,
                                    Colors.green.shade700,
                                  ),
                                ] else if (!isRead) ...[
                                  const SizedBox(width: 6),
                                  _tagChip(
                                    "جديد",
                                    Colors.blue.shade100,
                                    Colors.blue.shade700,
                                  ),
                                ]
                              ],
                            ),
                            const SizedBox(height: 6),
                            Text(days, style: const TextStyle(color: Colors.grey, fontSize: 12)),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 16),
                        child: OutlinedButton.icon(
                          onPressed: () {
                            context.read<NotificationsViewModel>().markRead(notificationId);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => NotificationDetailsPage(reportId: reportId),
                              ),
                            );
                          },
                          icon: const Icon(Icons.visibility),
                          label: const Text('عرض التفاصيل'),
                          style: OutlinedButton.styleFrom(
                            backgroundColor: Colors.white,
                            side: BorderSide(color: isResolved ? Colors.green.shade300 : (isRead ? Colors.grey.shade400 : Colors.blue.shade300)),
                            foregroundColor: isResolved ? Colors.green.shade700 : (isRead ? Colors.black87 : Colors.blue.shade700),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 10),

              Text(
                id,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static Widget _tagChip(String text, Color bg, Color color) {

              const SizedBox(height: 6),

              Text(
                days,
                style: const TextStyle(
                  color: Colors.grey,
                ),
              ),
            ],
          ),

          /// الجهة اليسار
          Row(
            children: [

              OutlinedButton.icon(
                onPressed: () {

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => NotificationDetailsPage(

                        id: id,
                        category: category,
                        priority: 'مكتمل',
                        days: days,
                        status: 'مكتمل',
                        imageUrl: 'https://picsum.photos/800/400',

                        onGoToAssignment: (page) {

                          Navigator.pop(context);

                          onPageSelected(AppPage.assignReports);
                        },
                      ),
                    ),
                  );
                },

                icon: const Icon(Icons.visibility),

                label: const Text('عرض التفاصيل'),
              ),

              const SizedBox(width: 12),

              const Icon(
                Icons.check_circle,
                color: Colors.green,
                size: 32,
              ),
            ],
          ),
        ],
      ),
    );
  }

  static Widget _tagChip(
      String text,
      Color bg,
      Color color,
      ) {

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 4,
      ),

      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
      ),

      child: Text(
        text,
        style: TextStyle(
          fontSize: 12,
          color: color,
        ),
      ),
    );
  }
}

class _NotificationsPageState extends State<NotificationsPage> {

  @override
  void initState() {
    super.initState();
    // استخدام الدالة الشاملة لجلب الإحصائيات والبلاغات معاً
    Future.microtask(
      () => context.read<NotificationsViewModel>().loadDashboardData(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<NotificationsViewModel>();
  Widget build(BuildContext context) {

    return Directionality(
      textDirection: TextDirection.rtl,

      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [

            const Text(
              'الإشعارات',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 4),

            const Text(
              'جميع التحديثات والبلاغات الواردة',
              style: TextStyle(color: Colors.grey),
            ),

            const SizedBox(height: 32),

            Row(
              children: const [

                _NotificationStat(
                  title: 'إجمالي الإشعارات',
                  value: '6',
                  icon: Icons.notifications,
                  color: Colors.blue,
                ),

                SizedBox(width: 16),

                _NotificationStat(
                  title: 'البلاغات المحلولة',
                  value: '2',
                  icon: Icons.check_circle,
                  color: Colors.green,
                ),

                SizedBox(width: 16),

                _NotificationStat(
                  title: 'البلاغات الجديدة',
                  value: '4',
                  icon: Icons.error,
                  color: Colors.orange,
                ),
              ],
            ),

            const SizedBox(height: 32),

            /// البلاغات الجديدة
            NotificationsPage._sectionTitle(
              'البلاغات الجديدة (2)',
            ),

            NotificationsPage._notificationItem(
              context,
              onPageSelected: widget.onPageSelected,
              id: '#2025-001',
              category: 'نظافة الشوارع',
              priority: 'عاجل',
              days: 'منذ 57 يوم',
              status: 'جديد',
            ),

            NotificationsPage._notificationItem(
              context,
              onPageSelected: widget.onPageSelected,
              id: '#2025-002',
              category: 'تركيب المخلفات',
              priority: 'متوسط',
              days: 'منذ 57 يوم',
              status: 'جديد',
            ),

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xfff6f8fb),
        body:
            viewModel.isLoading
                ? const Center(child: CircularProgressIndicator())
                : SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'الإشعارات',
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Text(
                        'جميع التحديثات والبلاغات الواردة',
                        style: TextStyle(color: Colors.grey),
                      ),
                      const SizedBox(height: 32),

                      // [تعديل] ربط المربعات بالإحصائيات الحقيقية من البوست مان
                      Row(
                        children: [
                          _NotificationStat(
                            title: 'إجمالي الإشعارات',
                            value:
                                viewModel.stats?.total.toString() ??
                                '0', // من البوست مان total
                            icon: Icons.notifications,
                            color: Colors.blue,
                          ),
                          const SizedBox(width: 16),
                          _NotificationStat(
                            title: 'البلاغات المحلولة',
                            value:
                                viewModel.stats?.resolved.toString() ??
                                '0', // من البوست مان resolved
                            icon: Icons.check_circle,
                            color: Colors.green,
                          ),
                          const SizedBox(width: 16),
                          _NotificationStat(
                            title: 'البلاغات النشطة',
                            value:
                                viewModel.stats?.active.toString() ??
                                '0', // من البوست مان active
                            icon: Icons.error,
                            color: Colors.orange,
                          ),
                        ],
                      ),

                      const SizedBox(height: 32),
            /// قيد المعالجة
            NotificationsPage._sectionTitle(
              'البلاغات قيد المعالجة',
            ),

            NotificationsPage._notificationItem(
              context,
              onPageSelected: widget.onPageSelected,
              id: '#2025-010',
              category: 'مكافحة الآفات',
              priority: 'متوسط',
              days: 'منذ 20 يوم',
              status: 'قيد المعالجة',
            ),

                      // عرض قائمة البلاغات الجديدة ديناميكياً
                      NotificationsPage._sectionTitle(
                        'البلاغات الجديدة (${viewModel.notifications.length})',
                      ),

                      if (viewModel.notifications.isEmpty)
                        const Center(
                          child: Padding(
                            padding: EdgeInsets.all(20.0),
                            child: Text("لا توجد إشعارات جديدة حالياً"),
                          ),
                        )
                      else
                        ...viewModel.notifications
                            .map(
                              (notif) => NotificationsPage._notificationItem(
                                context,
                                id: notif.title,
                                reportId: notif.reportId,
                                category: notif.reportType,
                                priority: notif.priority,
                                days: notif.createdAt,
                                status: notif.status,
                                notificationId: notif.id,
                                isRead: notif.isRead,
                              ),
                            )
                            .toList(),
                    ],
                  ),
                ),
            /// البلاغات المحلولة
            /// البلاغات المحلولة
            Row(
              textDirection: TextDirection.rtl,
              children: const [

                Icon(
                  Icons.check_circle,
                  color: Colors.green,
                  size: 30,
                ),

                SizedBox(width: 10),

                Text(
                  'البلاغات المحلولة (2)',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            NotificationsPage._solvedNotificationItem(
              context,
              onPageSelected: widget.onPageSelected,
              id: '#2025-004',
              category: 'أعطال الحدائق',
              tag: 'كنس',
              days: 'منذ 58 يوم',
            ),

            NotificationsPage._solvedNotificationItem(
              context,
              onPageSelected: widget.onPageSelected,
              id: '#2025-006',
              category: 'تركيب المخلفات',
              tag: 'رفع',
              days: 'منذ 59 يوم',
            ),
          ],
        ),
      ),
    );
  }
}

class _NotificationStat extends StatelessWidget {

  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _NotificationStat({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {

    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(20),

        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
        ),

        child: Row(
          children: [

            Icon(
              icon,
              color: color,
              size: 28,
            ),

            const SizedBox(width: 12),

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                Text(title, style: const TextStyle(color: Colors.black54)),
                const SizedBox(height: 6),

                Text(
                  value,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}