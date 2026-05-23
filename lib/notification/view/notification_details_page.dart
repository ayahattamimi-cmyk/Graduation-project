import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:web2/dashboard/view/widgets/sidebar.dart';
import 'package:web2/notification/viewmodel/notification_viewmodel.dart';
import 'package:web2/report_assignment/view/report_assignment_page.dart';
import 'widgets/detail_card.dart';
import 'widgets/reporter_info_card.dart';
import 'widgets/report_detail_widgets.dart';

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
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (_) => ReportAssignmentPage(
                                        reportId: widget.reportId,
                                      ),
                                ),
                              );
                            },
                            icon: const Icon(Icons.swap_horiz),
                            label: const Text('توجيه البلاغ'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF10B981),
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
                              // العمود الرئيسي (المعلومات الأساسية للبلاغ)
                              Flexible(
                                flex: isMobile ? 0 : 2,
                                child: Column(
                                  children: [
                                    ReportInfoCard(report: report),
                                    const SizedBox(height: 16),
                                    LocationCard(report: report),
                                    const SizedBox(height: 16),
                                    ReportImageCard(imageUrl: report.imageUrl),
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
}
