import 'package:flutter/material.dart';
import '../../dashboard/view/sidebar.dart';
import 'notification_details_page.dart';

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

  /// بلاغ جديد / قيد المعالجة
  static Widget _notificationItem(
      BuildContext context, {
        required String id,
        required String category,
        required String priority,
        required String days,
        required String status,
        required Function(AppPage) onPageSelected,
      }) {

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),

      decoration: BoxDecoration(
        color: status == 'ملغي'
            ? const Color(0xffFDECEC)
            : Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: status == 'ملغي'
              ? Colors.red.shade200
              : Colors.grey.shade200,
        ),
      ),

      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,

        children: [

          /// البيانات - اليمين
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [

              Text(
                id,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),

              const SizedBox(height: 8),

              Row(
                mainAxisSize: MainAxisSize.min,
                children: [

                  _tagChip(
                    category,
                    Colors.blue.shade100,
                    Colors.blue,
                  ),

                  const SizedBox(width: 6),

                  _tagChip(
                    priority,
                    priority == 'عاجل'
                        ? Colors.red.shade100
                        : Colors.orange.shade100,

                    priority == 'عاجل'
                        ? Colors.red
                        : Colors.orange,
                  ),
                ],
              ),

              const SizedBox(height: 8),

              Text(
                days,
                style: const TextStyle(
                  color: Colors.grey,
                ),
              ),
            ],
          ),

          /// اليسار
          OutlinedButton.icon(
            onPressed: () {

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => NotificationDetailsPage(

                    id: id,
                    category: category,
                    priority: priority,
                    days: days,
                    status: status,
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
        ],
      ),
    );
  }

  /// البلاغات المحلولة
  static Widget _solvedNotificationItem(
      BuildContext context, {
        required String id,
        required String category,
        required String tag,
        required String days,
        required Function(AppPage) onPageSelected,
      }) {

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),

      decoration: BoxDecoration(
        color: const Color(0xffeefcf3),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: Colors.green.shade200,
        ),
      ),

      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [

          /// البيانات - جهة اليمين
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [

              Row(
                mainAxisSize: MainAxisSize.min,
                children: [

                  _tagChip(
                    category,
                    Colors.red.shade100,
                    Colors.red,
                  ),

                  const SizedBox(width: 6),

                  _tagChip(
                    tag,
                    Colors.purple.shade100,
                    Colors.purple,
                  ),

                  const SizedBox(width: 6),

                  _tagChip(
                    'مكتمل',
                    Colors.green.shade100,
                    Colors.green,
                  ),
                ),
              ),

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

            const SizedBox(height: 32),

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

                Text(title),

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