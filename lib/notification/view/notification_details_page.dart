import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../dashboard/view/widgets/sidebar.dart';
import '../../../report_assignment/view/report_assignment_page.dart';
import 'widgets/detail_card.dart';
import 'widgets/reporter_info_card.dart';
import 'widgets/report_detail_widgets.dart';
import '../viewmodel/notification_viewmodel.dart';
import '../data/models/notification_model.dart';

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
    Future.microtask(
      () => context.read<NotificationsViewModel>().loadReportDetails(
        widget.reportId,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<NotificationsViewModel>();
    final report = viewModel.selectedReport;

    if (report != null) {
      debugPrint(
        "📢 Report #${report.reportNumber} | Status: ${report.status} | isPublished: ${report.isPublished}",
      );
    }

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
                                  style: const TextStyle(color: Colors.grey),
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
                                        report.reportNumber,
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
                              report.status == "تم الإنجاز")
                            Builder(
                              builder: (context) {
                                // البحث عن الإشعار الخاص بهذا البلاغ لمعرفة حالة النشر منه
                                bool isPublishedFromNotif = false;
                                try {
                                  final notif = viewModel.notifications
                                      .firstWhere(
                                        (n) =>
                                            n.reportId == report.reportNumber,
                                      );
                                  isPublishedFromNotif = notif.isPublished;
                                } catch (_) {}

                                // استخدام الحالة من الإشعار أو من موديل البلاغ كاحتياط
                                final bool isPublished =
                                    isPublishedFromNotif || report.isPublished;

                                return ElevatedButton.icon(
                                  onPressed:
                                      !isPublished
                                          ? () async {
                                            await viewModel.publishReport(
                                              report.reportNumber,
                                            );
                                            if (mounted) {
                                              ScaffoldMessenger.of(
                                                context,
                                              ).showSnackBar(
                                                const SnackBar(
                                                  content: Text(
                                                    "تم نشر البلاغ بنجاح",
                                                  ),
                                                ),
                                              );
                                            }
                                          }
                                          : null,
                                  icon: const Icon(Icons.public),
                                  label: Text(
                                    isPublished ? 'تم النشر' : 'نشر للجمهور',
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        isPublished
                                            ? Colors.grey.shade400
                                            : const Color(0xFF10B981),
                                    foregroundColor: Colors.white,
                                  ),
                                );
                              },
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
                              // العمود الرئيسي (المعلومات الأساسية للبلاغ)
                              Flexible(
                                flex: isMobile ? 0 : 2,
                                child: Column(
                                  children: [
                                    ReportInfoCard(report: report),
                                    const SizedBox(height: 16),
                                    LocationCard(report: report),
                                    const SizedBox(height: 16),

                                    // قسم الصور والمقارنة
                                    if (report.status == "تم الحل" ||
                                        report.status == "تم الإنجاز") ...[
                                      if (isMobile) ...[
                                        _buildProcessingResults(
                                          context,
                                          viewModel,
                                          report.reportNumber,
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
                                                report.reportNumber,
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
                                      // إذا لم يتم الحل، نعرض الصورة الأصلية فقط
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

                              // العمود الجانبي (البيانات الإضافية)
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
              style: TextStyle(color: Colors.grey),
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
                            style: TextStyle(color: Colors.grey, fontSize: 12),
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
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            ),
        ],
      ),
    );
  }

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
                    await vm.cancelReport(reportId, textController.text.trim());
                    if (mounted) {
                      Navigator.pop(context); // إغلاق النافذة المنبثقة
                      Navigator.pop(context); // الرجوع لشاشة الإشعارات
                      ScaffoldMessenger.of(context).showSnackBar(
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
