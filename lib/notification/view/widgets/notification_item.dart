import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodel/notification_viewmodel.dart';
import '../notification_details_page.dart';
import '../../../dashboard/view/widgets/sidebar.dart';

class NotificationItem extends StatelessWidget {
  final String id;
  final int reportId;
  final String category;
  final String priority;
  final String days;
  final String status;
  final String notificationId;
  final bool isRead;
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
    required this.onPageSelected,
  });

  @override
  Widget build(BuildContext context) {
    final bool isResolved =
        status == "تم الحل" ||
        status == "محلول" ||
        status == "تم إنجازه" ||
        status == "solved" ||
        status == "resolved";

    final bool isProcessing =
        status == "قيد المعالجة" || status == "processing";

    Color borderColor;
    Color indicatorColor;

    if (isResolved) {
      borderColor = const Color(0xffC8E6C9);
      indicatorColor = Colors.green.shade600;
    } else if (isProcessing) {
      borderColor = const Color(0xffFFE0B2);
      indicatorColor = Colors.orange.shade600;
    } else if (!isRead) {
      borderColor = const Color(0xffBBDEFB);
      indicatorColor = Colors.blue.shade600;
    } else {
      borderColor = const Color(0xffE0E0E0);
      indicatorColor = Colors.grey.shade400;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: borderColor.withOpacity(0.5)),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 5,
              height:
                  100, // Fixed or flexible via IntrinsicHeight if needed, but safer fixed or flex
              color: indicatorColor,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 16,
                  horizontal: 8,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            id,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              color:
                                  isRead && !isResolved
                                      ? Colors.black54
                                      : const Color(0xFF1F2937),
                            ),
                          ),
                          const SizedBox(height: 10),
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
                              if (isResolved)
                                _tagChip(
                                  "تم الإنجاز ✓",
                                  const Color(0xFFD1FAE5),
                                  const Color(0xFF059669),
                                )
                              else if (isProcessing)
                                _tagChip(
                                  "قيد المعالجة",
                                  Colors.orange.shade50,
                                  Colors.orange.shade700,
                                )
                              else if (!isRead)
                                _tagChip(
                                  "جديد",
                                  Colors.blue.shade50,
                                  Colors.blue.shade700,
                                ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            days,
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 20),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            isResolved
                                ? const Color(0xFFD1FAE5)
                                : (isRead
                                    ? Colors.grey.shade50
                                    : const Color(0xfff0fdf4)),
                        foregroundColor:
                            isResolved
                                ? const Color(0xFF059669)
                                : (isRead
                                    ? Colors.black87
                                    : const Color(0xFF10B981)),
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                          side: BorderSide(
                            color:
                                isResolved
                                    ? const Color(0xFF059669).withOpacity(0.3)
                                    : (isRead
                                        ? Colors.grey.shade300
                                        : const Color(
                                          0xFF10B981,
                                        ).withOpacity(0.3)),
                          ),
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
                      icon: const Icon(Icons.arrow_forward_ios, size: 14),
                      label: const Text(
                        'عرض التفاصيل',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

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
