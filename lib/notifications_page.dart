import 'package:flutter/material.dart';
import 'notification_details_page.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();

  static Widget _sectionTitle(String title) {
    return Padding(//مسافة اسفل العنوان
      padding: const EdgeInsets.only(bottom: 16),
      child: Text(
        title,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }

  //  بلاغ (جديد / قيد المعالجة
  static Widget _notificationItem(
      BuildContext context, {
        required String id,
        required String category,
        required String priority,
        required String days,
        required String status,
      }) {
    return Container(//الشكل الكامل حق كرت البلاغ
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(//قسيم المحتوى حقت البلاغ
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [

          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(id, style: const TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 6),
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
                ],
              ),
              const SizedBox(height: 6),
              Text(days, style: const TextStyle(color: Colors.grey)),
            ],
          ),

     //الزر حق عرض التفاصيل
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


  static Widget _solvedNotificationItem(
      BuildContext context, {
        required String id,
        required String category,
        required String tag,
        required String days,
      }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xffeefcf3),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.green.shade200),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    _tagChip(category, Colors.red.shade100, Colors.red),
                    const SizedBox(width: 6),
                    _tagChip(tag, Colors.purple.shade100, Colors.purple),
                    const SizedBox(width: 6),
                    _tagChip('مكتمل', Colors.green.shade100, Colors.green),
                  ],
                ),
                const SizedBox(height: 6),
                Text(id, style: const TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(days, style: const TextStyle(color: Colors.grey)),
              ],
            ),
          ),

          const SizedBox(width: 16),

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
                  ),
                ),
              );
            },
            icon: const Icon(Icons.visibility),
            label: const Text('عرض التفاصيل'),
          ),

          const SizedBox(width: 8),
          const Icon(Icons.check_circle, color: Colors.green),
        ],
      ),
    );
  }


  static Widget _tagChip(String text, Color bg, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(text, style: TextStyle(fontSize: 12, color: color)),
    );
  }
}

class _NotificationsPageState extends State<NotificationsPage> {
  @override
  Widget build(BuildContext context) {
    return Directionality(//ذا عشان الاتجاه حق النص من اليمين الى اليسار
      textDirection: TextDirection.rtl,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),//مسافة حول المحتوى كله
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //العنوان
            const Text(
              'الإشعارات',
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            const Text(
              'جميع التحديثات والبلاغات الواردة',
              style: TextStyle(color: Colors.grey),
            ),

            const SizedBox(height: 32),

            //
            Row(
              children: const [
                _NotificationStat(//الشرطة يعني انه خاص م نقدر نستدعية من ملف ثاني
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

            //   البلاغات الجديدة
            NotificationsPage._sectionTitle('البلاغات الجديدة (2)'),

            NotificationsPage._notificationItem(
              context,
              id: '#2025-001',
              category: 'نظافة الشوارع',
              priority: 'عاجل',
              days: 'منذ 57 يوم',
              status: 'جديد',
            ),
            NotificationsPage._notificationItem(
              context,
              id: '#2025-002',
              category: 'تركيب المخلفات',
              priority: 'متوسط',
              days: 'منذ 57 يوم',
              status: 'جديد',
            ),

            const SizedBox(height: 32),

            // قيد المعالجة
            NotificationsPage._sectionTitle('البلاغات قيد المعالجة'),

            NotificationsPage._notificationItem(
              context,
              id: '#2025-010',
              category: 'مكافحة الآفات',
              priority: 'متوسط',
              days: 'منذ 20 يوم',
              status: 'قيد المعالجة',
            ),

            const SizedBox(height: 32),

            // البلاغات المحلولة
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text(
                  'البلاغات المحلولة (2)',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Icon(Icons.check_circle, color: Colors.green),
              ],
            ),

            const SizedBox(height: 16),

            NotificationsPage._solvedNotificationItem(
              context,
              id: '#2025-004',
              category: 'أعطال الحدائق',
              tag: 'كنس',
              days: 'منذ 58 يوم',
            ),
            NotificationsPage._solvedNotificationItem(
              context,
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
            Icon(icon, color: color, size: 28),
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
