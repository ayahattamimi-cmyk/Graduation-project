import 'package:flutter/material.dart';
import 'package:web2/notification/viewmodel/notification_viewmodel.dart';
import '../../dashboard/view/widgets/sidebar.dart';

import 'package:provider/provider.dart';

import 'widgets/notification_item.dart';
import 'widgets/notification_stat.dart';

class NotificationsPage extends StatefulWidget {
  final Function(AppPage) onPageSelected;

  const NotificationsPage({super.key, required this.onPageSelected});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();

  static Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16, top: 8),
      child: Text(
        title,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }
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
                        style: TextStyle(color: Colors.grey),
                      ),
                      const SizedBox(height: 32),

                      Wrap(
                        spacing: 16,
                        runSpacing: 16,
                        children: [
                          NotificationStat(
                            title: 'إجمالي الإشعارات',
                            value: viewModel.stats?.total.toString() ?? '0',
                            icon: Icons.notifications,
                            color: const Color(0xFF10B981),
                          ),

                          NotificationStat(
                            title: 'البلاغات المحلولة',
                            value: viewModel.stats?.resolved.toString() ?? '0',
                            icon: Icons.check_circle,
                            color: Colors.green,
                          ),
                          NotificationStat(
                            title: 'البلاغات النشطة',
                            value: viewModel.stats?.active.toString() ?? '0',
                            icon: Icons.error,
                            color: Colors.orange,
                          ),
                        ],
                      ),

                      const SizedBox(height: 32),

                      NotificationsPage._sectionTitle(
                        'قائمة الإشعارات والتحديثات الحالية (${viewModel.notifications.length})',
                      ),

                      if (viewModel.notifications.isEmpty)
                        const Center(
                          child: Padding(
                            padding: EdgeInsets.all(40.0),
                            child: Text(
                              "لا توجد إشعارات أو بلاغات مسجلة حالياً.",
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        )
                      else
                        ...viewModel.notifications
                            .map(
                              (notif) => NotificationItem(
                                id: notif.title,
                                reportId: notif.reportId,
                                category: notif.reportType,
                                priority: notif.priority,
                                days: notif.createdAt,
                                status: notif.status,
                                notificationId: notif.id,
                                isRead: notif.isRead,
                                onPageSelected: widget.onPageSelected,
                              ),
                            )
                            .toList(),
                    ],
                  ),
                ),
      ),
    );
  }
}
