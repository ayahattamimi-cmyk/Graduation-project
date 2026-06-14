import 'package:flutter/material.dart';
import 'package:web2/notification/viewmodel/notification_viewmodel.dart';
import '../../dashboard/view/widgets/sidebar.dart';
import 'package:provider/provider.dart';
import 'widgets/notification_item.dart';
import 'package:web2/dashboard/view/widgets/stat_card.dart';

/// صفحة تعرض جميع الإشعارات مجمّعة حسب فئات الحالة.
class NotificationsPage extends StatefulWidget {
  final Function(AppPage) onPageSelected;

  const NotificationsPage({super.key, required this.onPageSelected});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => context.read<NotificationsViewModel>().loadDashboardData(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<NotificationsViewModel>();

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
                        'جميع التحديثات والبلاغات الواردة من المواطنين بشكل مباشر',
                        style: TextStyle(color: Color(0xFF616161)),
                      ),
                      const SizedBox(height: 32),

                      Row(
                        children: [
                          Expanded(
                            child: StatCard(
                              title: 'إجمالي الإشعارات',
                              value:
                                  viewModel.totalNotificationsCount.toString(),
                              subtitle: 'جميع التنبيهات المستلمة',
                              icon: Icons.notifications_none,
                              color: const Color(0xFF10B981),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: StatCard(
                              title: 'إشعارات مقروءة',
                              value:
                                  viewModel.readNotificationsCount.toString(),
                              subtitle: 'تمت معاينتها مسبقاً',
                              icon: Icons.mark_email_read_outlined,
                              color: Colors.blue,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: StatCard(
                              title: 'إشعارات غير مقروءة',
                              value:
                                  viewModel.unreadNotificationsCount.toString(),
                              subtitle: 'تنتظر المراجعة',
                              icon: Icons.mark_email_unread_outlined,
                              color: Colors.orange,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 32),

                      if (viewModel.notifications.isEmpty)
                        const Center(
                          child: Padding(
                            padding: EdgeInsets.all(40.0),
                            child: Text(
                              "لا توجد إشعارات أو بلاغات مسجلة حالياً.",
                              style: TextStyle(
                                color: Color(0xFF616161),
                                fontSize: 16,
                              ),
                            ),
                          ),
                        )
                      else ...[
                        _buildNotificationSection(
                          context,
                          ' بلاغات جديدة (قيد الانتظار)',
                          viewModel.notifications
                              .where((n) => n.status.contains("انتظار"))
                              .toList(),
                          widget.onPageSelected,
                          Colors.orange,
                        ),
                        _buildNotificationSection(
                          context,
                          ' بلاغات قيد المعالجة',
                          viewModel.notifications
                              .where((n) => n.status.contains("معالجة"))
                              .toList(),
                          widget.onPageSelected,
                          Colors.blue,
                        ),
                        _buildNotificationSection(
                          context,
                          ' بلاغات منجزة  ',
                          viewModel.notifications
                              .where(
                                (n) =>
                                    n.status.contains("حل") ||
                                    n.status.contains("إنجاز"),
                              )
                              .toList(),
                          widget.onPageSelected,
                          Colors.green,
                        ),
                        _buildNotificationSection(
                          context,
                          ' بلاغات ملغية',
                          viewModel.notifications
                              .where((n) => n.status.contains("ملغي"))
                              .toList(),
                          widget.onPageSelected,
                          Colors.red,
                        ),
                      ],
                    ],
                  ),
                ),
      ),
    );
  }

  /// يبني رأس القسم وقائمة لفئة حالة الإشعارات.
  Widget _buildNotificationSection(
    BuildContext context,
    String title,
    List<dynamic> items,
    Function(AppPage) onPageSelected,
    Color color,
  ) {
    if (items.isEmpty) return const SizedBox();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Row(
            children: [
              Container(width: 4, height: 24, color: color),
              const SizedBox(width: 12),
              Text(
                "$title (${items.length})",
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        ...items.map(
          (notif) => NotificationItem(
            id: notif.title,
            reportId: notif.reportId,
            category: notif.reportType,
            priority: notif.priority,
            days: notif.createdAt,
            status: notif.status,
            notificationId: notif.id,
            isRead: notif.isRead,
            imageUrl: notif.image,
            supervisor: notif.supervisor,
            note: notif.note,
            onPageSelected: onPageSelected,
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }
}
