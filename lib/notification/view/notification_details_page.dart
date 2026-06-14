import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../dashboard/view/widgets/sidebar.dart';
import '../../../report_assignment/view/report_assignment_page.dart';
import 'widgets/detail_card.dart';
import 'widgets/reporter_info_card.dart';
import 'widgets/report_detail_widgets.dart';
import '../viewmodel/notification_viewmodel.dart';
import '../data/models/notification_model.dart';

/// صفحة تعرض التفاصيل الكاملة لبلاغ محدّد، بما في ذلك إجراءات
/// مثل التوجيه والإلغاء والنشر.
class NotificationDetailsPage extends StatefulWidget {
  final int reportId;
  final Function(AppPage)? onGoToAssignment;

  const NotificationDetailsPage({
    super.key,
    required this.reportId,
    this.onGoToAssignment,
  });

  @override
  State<NotificationDetailsPage> createState() =>
      _NotificationDetailsPageState();
}

class _NotificationDetailsPageState extends State<NotificationDetailsPage> {
  @override
  void initState() {
    super.initState();
    final viewModel = context.read<NotificationsViewModel>();
    Future.microtask(() => viewModel.loadReportDetails(widget.reportId));
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<NotificationsViewModel>();
    final report = viewModel.selectedReport;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xfff6f8fb),
        body:
            viewModel.isLoading
                ? const Center(child: CircularProgressIndicator())
                : report == null
                ? const Center(child: Text("تعذر تحميل بيانات البلاغ"))
                : SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (report.status == "ملغي" ||
                          report.status == "Cancelled" ||
                          (report.cancelReason != null &&
                              report.cancelReason!.isNotEmpty))
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          margin: const EdgeInsets.only(bottom: 24),
                          decoration: BoxDecoration(
                            color: Colors.red.shade50,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.red.shade200),
                          ),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.red.shade100,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.error_outline,
                                  color: Colors.red,
                                  size: 24,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      "هذا البلاغ ملغي",
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.red,
                                      ),
                                    ),
                                    if (report.cancelReason != null &&
                                        report.cancelReason!.isNotEmpty)
                                      Padding(
                                        padding: const EdgeInsets.only(top: 4),
                                        child: Text(
                                          "سبب الإلغاء: ${report.cancelReason}",
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.red.shade800,
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          OutlinedButton.icon(
                            onPressed: () => Navigator.pop(context),
                            icon: const Icon(Icons.arrow_back),
                            label: const Text('رجوع'),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'تفاصيل البلاغ #${report.reportNumber}',
                                  style: const TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  report.title,
                                  style: const TextStyle(color: Color(0xFF616161)),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 16),
                          ElevatedButton.icon(
                            onPressed:
                                report.status == "قيد الانتظار"
                                    ? () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder:
                                              (_) => ReportAssignmentPage(
                                                reportId: widget.reportId,
                                              ),
                                        ),
                                      );
                                    }
                                    : null,
                            icon: const Icon(Icons.swap_horiz),
                            label: Text(
                              report.status == "قيد الانتظار"
                                  ? 'توجيه البلاغ'
                                  : 'تم توجيه البلاغ',
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  report.status == "قيد الانتظار"
                                      ? Colors.blue
                                      : Colors.grey.shade400,
                              foregroundColor: Colors.white,
                            ),
                          ),
                          const SizedBox(width: 8),
                          ElevatedButton.icon(
                            onPressed:
                                (report.status == "قيد الانتظار" ||
                                        report.status == "Pending")
                                    ? () {
                                      _showCancelDialog(
                                        context,
                                        viewModel,
                                        report.id,
                                      );
                                    }
                                    : null,
                            icon: Icon(
                              report.status == "ملغي" ||
                                      report.status == "Cancelled"
                                  ? Icons.block
                                  : Icons.cancel_outlined,
                            ),
                            label: Text(
                              report.status == "ملغي" ||
                                      report.status == "Cancelled"
                                  ? 'تم إلغاء البلاغ'
                                  : 'إلغاء البلاغ',
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  (report.status == "قيد الانتظار" ||
                                          report.status == "Pending")
                                      ? Colors.redAccent
                                      : Colors.grey.shade400,
                              foregroundColor: Colors.white,
                            ),
                          ),
                          const SizedBox(width: 8),
                          if (report.status == "تم الحل" ||
                              report.status == "تم الإنجاز" ||
                              report.status == "مكتمل" ||
                              report.status == "Solved" ||
                              report.status == "Completed")
                            ElevatedButton.icon(
                              onPressed: () async {
                                await viewModel.publishReport(
                                  widget.reportId,
                                );
                              },
                              icon: Icon(
                                report.isPublished
                                    ? Icons.visibility_off
                                    : Icons.public,
                              ),
                              label: Text(
                                report.isPublished
                                    ? 'إلغاء النشر'
                                    : 'نشر البلاغ',
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    report.isPublished
                                        ? const Color(0xFFF97316)
                                        : const Color(0xFF10B981),
                                foregroundColor: Colors.white,
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      LayoutBuilder(
                        builder: (context, constraints) {
                          bool isMobile = constraints.maxWidth < 900;
                          return Flex(
                            direction:
                                isMobile ? Axis.vertical : Axis.horizontal,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Flexible(
                                flex: isMobile ? 0 : 2,
                                child: Column(
                                  children: [
                                    ReportInfoCard(report: report),
                                    const SizedBox(height: 16),
                                    LocationCard(report: report),
                                    const SizedBox(height: 16),
                                    if (report.status == "تم الحل" ||
                                        report.status == "تم الإنجاز") ...[
                                      if (isMobile) ...[
                                        _buildProcessingResults(
                                          context,
                                          viewModel,
                                          report.id,
                                        ),
                                        const SizedBox(height: 16),
                                        ReportImageCard(
                                          imageUrl: report.imageUrl,
                                        ),
                                      ] else ...[
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Expanded(
                                              child: _buildProcessingResults(
                                                context,
                                                viewModel,
                                                report.id,
                                              ),
                                            ),
                                            const SizedBox(width: 16),
                                            Expanded(
                                              child: ReportImageCard(
                                                imageUrl: report.imageUrl,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                      const SizedBox(height: 16),
                                    ] else ...[
                                      ReportImageCard(
                                        imageUrl: report.imageUrl,
                                      ),
                                      const SizedBox(height: 16),
                                    ],
                                    if (isMobile) const SizedBox(height: 16),
                                  ],
                                ),
                              ),
                              if (!isMobile) const SizedBox(width: 24),
                              Flexible(
                                flex: isMobile ? 0 : 1,
                                child: SizedBox(
                                  width: isMobile ? double.infinity : 350,
                                  child: Column(
                                    children: [
                                      DetailCard(
                                        title: 'ملخص سريع',
                                        child: Column(
                                          children: [
                                            DetailRowItem(
                                              label: 'النوع',
                                              value: report.type,
                                            ),
                                            DetailRowItem(
                                              label: 'الأولوية',
                                              value: report.priority,
                                            ),
                                            DetailRowItem(
                                              label: 'الحالة',
                                              value: report.status,
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(height: 16),
                                      ReporterInfoCard(
                                        reporter: report.reporter,
                                        status: report.status,
                                        onGoToAssignment:
                                            widget.onGoToAssignment,
                                      ),
                                      const SizedBox(height: 16),
                                      DetailCard(
                                        title: 'توقيت البلاغ',
                                        child: Column(
                                          children: [
                                            ListTile(
                                              contentPadding: EdgeInsets.zero,
                                              leading: const Icon(
                                                Icons.calendar_today,
                                                size: 20,
                                              ),
                                              title: const Text(
                                                'التاريخ',
                                                style: TextStyle(fontSize: 14),
                                              ),
                                              trailing: Text(
                                                report.createdAt,
                                                style: const TextStyle(
                                                  fontSize: 14,
                                                ),
                                              ),
                                            ),
                                            ListTile(
                                              contentPadding: EdgeInsets.zero,
                                              leading: const Icon(
                                                Icons.access_time,
                                                size: 20,
                                              ),
                                              title: const Text(
                                                'الوقت',
                                                style: TextStyle(fontSize: 14),
                                              ),
                                              trailing: Text(
                                                report.createdTime,
                                                style: const TextStyle(
                                                  fontSize: 14,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                ),
      ),
    );
  }

  /// يبني بطاقة تعرض نتائج المعالجة من المشرف.
  Widget _buildProcessingResults(
    BuildContext context,
    NotificationsViewModel vm,
    int reportId,
  ) {
    NotificationModel? notification;
    try {
      notification = vm.notifications.firstWhere(
        (n) =>
            n.reportId == reportId &&
            (n.status.contains("حل") ||
                n.status.contains("إنجاز") ||
                n.status.contains("مكتمل")),
      );
    } catch (e) {
      notification = null;
    }

    if (notification == null) {
      return const DetailCard(
        title: 'نتائج المعالجة',
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              "لم يتم العثور على بيانات المعالجة في الإشعارات الحالية.",
              style: TextStyle(color: Color(0xFF616161)),
            ),
          ),
        ),
      );
    }

    return DetailCard(
      title: 'نتائج المعالجة من قبل المشرف',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.verified_user, color: Colors.green, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  "بإشراف: ${notification.supervisor ?? 'غير محدد'}",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.green,
                  ),
                ),
              ),
            ],
          ),
          const Divider(height: 24),
          const Text(
            "ملاحظة الإنجاز:",
            style: TextStyle(
              color: Colors.black54,
              fontWeight: FontWeight.bold,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 4),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.green.shade50,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.green.shade100),
            ),
            child: Text(
              notification.note ?? "تم التنفيذ بدون ملاحظات إضافية.",
              style: const TextStyle(fontSize: 14, height: 1.5),
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            "الصورة بعد المعالجة (التنفيذ):",
            style: TextStyle(
              color: Colors.black54,
              fontWeight: FontWeight.bold,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 8),
          if (notification.image.isNotEmpty)
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                notification.image,
                height: 250,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder:
                    (context, error, stackTrace) => Container(
                      height: 250,
                      width: double.infinity,
                      color: Colors.grey.shade100,
                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.broken_image, color: Colors.grey),
                          Text(
                            "تعذر تحميل صورة المعالجة",
                            style: TextStyle(color: Color(0xFF616161), fontSize: 12),
                          ),
                        ],
                      ),
                    ),
              ),
            )
          else
            const Center(
              child: Padding(
                padding: EdgeInsets.all(20.0),
                child: Text(
                  "لا توجد صورة مرفقة للإنجاز",
                  style: TextStyle(color: Color(0xFF616161)),
                ),
              ),
            ),
        ],
      ),
    );
  }

  /// يعرض حواراً لإلغاء بلاغ مع سبب مطلوب.
  void _showCancelDialog(
    BuildContext context,
    NotificationsViewModel vm,
    int reportId,
  ) {
    final textController = TextEditingController();
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('إلغاء البلاغ'),
            content: TextField(
              controller: textController,
              decoration: const InputDecoration(
                hintText: 'أدخل سبب الإلغاء هنا...',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('تراجع'),
              ),
              ElevatedButton(
                onPressed: () async {
                  if (textController.text.trim().isNotEmpty) {
                    final navigator = Navigator.of(context);
                    final messenger = ScaffoldMessenger.of(context);
                    await vm.cancelReport(reportId, textController.text.trim());
                    if (context.mounted) {
                      navigator.pop();
                      navigator.pop();
                      messenger.showSnackBar(
                        const SnackBar(
                          content: Text("تم إلغاء البلاغ بنجاح"),
                          backgroundColor: Colors.green,
                        ),
                      );
                    }
                  }
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                child: const Text('تأكيد الإلغاء'),
              ),
            ],
          ),
    );
  }
}
