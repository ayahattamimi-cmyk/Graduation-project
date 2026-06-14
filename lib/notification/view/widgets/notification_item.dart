import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodel/notification_viewmodel.dart';
import '../notification_details_page.dart';
import '../../../dashboard/view/widgets/sidebar.dart';

/// عنصر قائمة يمثل إشعاراً مفرداً مع ألوان الحالة.
class NotificationItem extends StatelessWidget {
  final String id;
  final int reportId;
  final String category;
  final String priority;
  final String days;
  final String status;
  final String notificationId;
  final bool isRead;
  final String imageUrl;
  final String? supervisor;
  final String? note;
  final Function(AppPage) onPageSelected;

  const NotificationItem({
    super.key,
    required this.id,
    required this.reportId,
    required this.category,
    required this.priority,
    required this.days,
    required this.status,
    required this.notificationId,
    required this.isRead,
    required this.imageUrl,
    this.supervisor,
    this.note,
    required this.onPageSelected,
  });

  @override
  Widget build(BuildContext context) {
    final String lowerStatus = status.toLowerCase().trim();
    final String lowerTitle = id.toLowerCase();

    final bool isResolved =
        lowerStatus.contains("حل") ||
        lowerStatus.contains("إنجاز") ||
        lowerStatus.contains("مكتمل") ||
        lowerStatus.contains("solved") ||
        lowerStatus.contains("completed") ||
        lowerStatus.contains("resolved") ||
        lowerTitle.contains("إنجاز");

    final bool isProcessing =
        lowerStatus.contains("معالجة") || lowerStatus.contains("processing");

    final bool isCancelled =
        lowerStatus.contains("ملغ") ||
        lowerStatus.contains("رفض") ||
        lowerStatus.contains("تجاهل") ||
        lowerStatus.contains("reject") ||
        lowerStatus.contains("cancel") ||
        lowerTitle.contains("ملغ") ||
        lowerTitle.contains("إلغاء");

    Color borderColor;
    Color indicatorColor;

    if (isCancelled) {
      borderColor = Colors.red.shade200;
      indicatorColor = Colors.red.shade600;
    } else if (isResolved) {
      borderColor = const Color(0xffC8E6C9);
      indicatorColor = Colors.green.shade600;
    } else if (isProcessing) {
      borderColor = const Color(0xffBBDEFB);
      indicatorColor = Colors.blue.shade600;
    } else if (!isRead) {
      borderColor = const Color(0xffFFE0B2);
      indicatorColor = Colors.orange.shade600;
    } else {
      borderColor = const Color(0xffE0E0E0);
      indicatorColor = Colors.grey.shade400;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: isCancelled ? const Color(0xfffef2f2) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(
          color:
              isCancelled ? Colors.red.shade300 : borderColor.withOpacity(0.5),
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(width: 6, color: indicatorColor),
              if (imageUrl.isNotEmpty)
                Container(
                  width: 90,
                  height: 90,
                  margin: const EdgeInsets.all(8),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder:
                          (context, error, stackTrace) => Container(
                            color: Colors.grey.shade200,
                            child: const Icon(
                              Icons.image_not_supported,
                              color: Colors.grey,
                            ),
                          ),
                    ),
                  ),
                ),
              const SizedBox(width: 8),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              isCancelled
                                  ? "تم إلغاء البلاغ رقم $reportId"
                                  : id,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                                color:
                                    isCancelled
                                        ? Colors.red.shade700
                                        : (isRead && !isResolved
                                            ? const Color(0xFF616161)
                                            : const Color(0xFF1F2937)),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: [
                                _tagChip(
                                  category,
                                  Colors.blue.shade50,
                                  Colors.blue.shade700,
                                ),
                                _tagChip(
                                  priority,
                                  priority == 'عاجل'
                                      ? Colors.red.shade50
                                      : Colors.orange.shade50,
                                  priority == 'عاجل'
                                      ? Colors.red.shade700
                                      : Colors.orange.shade700,
                                ),
                                if (isCancelled)
                                  _tagChip(
                                    "ملغي",
                                    Colors.red.shade50,
                                    Colors.red.shade700,
                                  )
                                else if (isResolved)
                                  _tagChip(
                                    "تم الإنجاز ✓",
                                    const Color(0xFFD1FAE5),
                                    const Color(0xFF059669),
                                  )
                                else if (isProcessing)
                                  _tagChip(
                                    "قيد المعالجة",
                                    Colors.blue.shade50,
                                    Colors.blue.shade700,
                                  )
                                else if (!isRead)
                                  _tagChip(
                                    "جديد",
                                    Colors.orange.shade50,
                                    Colors.orange.shade700,
                                  ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              days,
                              style: const TextStyle(
                                color: Color(0xFF616161),
                                fontSize: 12,
                              ),
                            ),
                            if (supervisor != null &&
                                supervisor!.isNotEmpty) ...[
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.person,
                                    size: 14,
                                    color: Colors.green,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    "المشرف: $supervisor",
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.green,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              isRead
                                  ? Colors.grey.shade100
                                  : const Color(0xFF10B981),
                          foregroundColor:
                              isRead ? Colors.black87 : Colors.white,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: () {
                          context.read<NotificationsViewModel>().markRead(
                            notificationId,
                          );
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (_) => NotificationDetailsPage(
                                    reportId: reportId,
                                    onGoToAssignment: (page) {
                                      Navigator.pop(context);
                                      onPageSelected(AppPage.assignReports);
                                    },
                                  ),
                            ),
                          );
                        },
                        child: const Text('التفاصيل'),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// يبني شريحة علامة صغيرة ملونة لعرض الحالة/التسمية.
  Widget _tagChip(String text, Color bg, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 12,
          color: color,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
