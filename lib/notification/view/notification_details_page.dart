import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../data/models/report_details_model.dart';
import '../data/notification_repository.dart';
import 'package:web2/report_assignment/view/report_assignment_page.dart';
import 'package:web2/dashboard/view/sidebar.dart';

class NotificationDetailsPage extends StatefulWidget {
  final int reportId;
  final String? status;
  final Function(AppPage)? onGoToAssignment;

  const NotificationDetailsPage({
    super.key,
    required this.reportId,
    this.status,
    this.onGoToAssignment,
  });

  @override
  State<NotificationDetailsPage> createState() =>
      _NotificationDetailsPageState();
}

class _NotificationDetailsPageState extends State<NotificationDetailsPage> {
  ReportDetailsModel? report;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadReportDetails();
  }

  // دالة جلب التفاصيل من السيرفر بمجرد فتح الصفحة
  Future<void> _loadReportDetails() async {
    try {
      final repository = context.read<NotificationRepository>();
      final data = await repository.fetchReportDetails(widget.reportId);
      setState(() {
        report = data;
        isLoading = false;
      });
    } catch (e) {
      debugPrint("Error loading report details: $e");
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {

    return Directionality(
      textDirection: TextDirection.rtl,

      child: Scaffold(
        backgroundColor: const Color(0xfff6f8fb),
        body:
            isLoading
                ? const Center(
                  child: CircularProgressIndicator(),
                ) // عرض تحميل أثناء جلب البيانات
                : report == null
                ? const Center(child: Text("تعذر تحميل بيانات البلاغ"))
                : SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // --- العنوان والزر ---
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
                              crossAxisAlignment:
                                  CrossAxisAlignment
                                      .start, // تعديل للاتجاه الصحيح
                              children: [
                                Text(
                                  'تفاصيل البلاغ #${report!.reportNumber}',
                                  style: const TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  report!.title, // العنوان من السيرفر
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
                                  builder: (_) => ReportAssignmentPage(reportId: widget.reportId),
                                ),
                              );
                            },
                            icon: const Icon(Icons.swap_horiz),
                            label: const Text('توجيه البلاغ'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              foregroundColor: Colors.white,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 24),

                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // العمود الأيمن (المعلومات الأساسية)
                          Expanded(
                            child: Column(
                              children: [
                                _reportInfoCard(),
                                const SizedBox(height: 16),
                                _locationCard(),
                                const SizedBox(height: 16),
                                _imageCard(),
                              ],
                            ),
                          ),
                          const SizedBox(width: 24),
                          // العمود الأيسر (البيانات الجانبية)
                          SizedBox(
                            width: 320,
                            child: Column(
                              children: [
                                _quickSummaryCard(),
                                const SizedBox(height: 16),
                                _reporterInfoCard(),
                                const SizedBox(height: 16),
                                _timeCard(),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
      ),
    );
  }

  // --- الكروت المعدلة لتقرأ من مودل report ---

  Widget _quickSummaryCard() {

    return _card(
      title: 'ملخص سريع',

      child: Column(
        children: [
          _rowItem('النوع', report!.type),
          _rowItem('الأولوية', report!.priority),
          _rowItem('الحالة', report!.status),
        ],
      ),
    );
  }

  /// بيانات المبلغ
  Widget _reporterInfoCard() {
    final currentStatus = widget.status ?? report?.status;

    return _card(
      title: 'بيانات المبلّغ',

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text('الاسم', style: TextStyle(color: Colors.grey)),
          const SizedBox(height: 4),
          Text(
            report!.reporter.name, // من المودل المنفصل
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          const Text('رقم الجوال', style: TextStyle(color: Colors.grey)),
          const SizedBox(height: 4),
          Text(
            report!.reporter.phone, // من المودل المنفصل
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),

          if (currentStatus == 'قيد المعالجة') ...[

            const SizedBox(height: 12),

            SizedBox(
              width: double.infinity,

              child: ElevatedButton.icon(

                onPressed: () {
                  widget.onGoToAssignment
                      ?.call(AppPage.assignReports);
                },

                icon: const Icon(Icons.swap_horiz),

                label: const Text(
                  'إعادة توجيه لمشرف آخر',

                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),

                style: ElevatedButton.styleFrom(
                  backgroundColor:
                  const Color(0xff2563EB),

                  foregroundColor: Colors.white,

                  padding:
                  const EdgeInsets.symmetric(
                    vertical: 14,
                  ),

                  shape: RoundedRectangleBorder(
                    borderRadius:
                    BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  /// الوقت
  Widget _timeCard() {

    return _card(
      title: 'توقيت البلاغ',

      child: Column(
        children: [
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Icons.calendar_today),
            title: const Text('التاريخ'),
            trailing: Text(report!.createdAt),
          ),

          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Icons.access_time),
            title: const Text('الوقت'),
            trailing: Text(report!.createdTime),
          ),
        ],
      ),
    );
  }

  /// معلومات البلاغ
  Widget _reportInfoCard() {

    return _card(
      title: 'معلومات البلاغ',

      child: Column(
        children: [
          _rowItem('رقم البلاغ', report!.reportNumber.toString()),
          _rowItem('نوع العمل', report!.type),
          _rowItem('الحالة', report!.status),
          const Divider(),

          const Align(
            alignment: Alignment.centerRight,

            child: Text(
              'الوصف',

              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          const SizedBox(height: 6),
          Align(
            alignment: Alignment.centerRight,
            child: Text(report!.description), // الوصف من السيرفر
          ),
        ],
      ),
    );
  }

  /// الموقع
  Widget _locationCard() {

    return _card(
      title: 'موقع البلاغ',

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('المربع الجغرافي', style: TextStyle(color: Colors.grey)),
          const SizedBox(height: 4),
          Text(
            report!.square,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          const Text('المنطقة', style: TextStyle(color: Colors.grey)),
          const SizedBox(height: 6),
          Text(
            report!.area,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  /// الصورة
  Widget _imageCard() {

    return _card(
      title: 'صورة البلاغ من المواطن',

      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: report!.imageUrl.isNotEmpty
            ? Image.network(
                report!.imageUrl, // رابط الصورة الحقيقي
                height: 400,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => const Center(
                  child: Icon(Icons.broken_image, size: 50, color: Colors.grey),
                ),
              )
            : const Center(
                child: Padding(
                  padding: EdgeInsets.all(40.0),
                  child: Column(
                    children: [
                      Icon(Icons.image_not_supported_outlined, size: 50, color: Colors.grey),
                      SizedBox(height: 10),
                      Text("لا توجد صورة متوفرة لهذا البلاغ", style: TextStyle(color: Colors.grey)),
                    ],
                  ),
                ),
              ),
      ),
    );
  }

  // --- الأدوات المساعدة ---

  Widget _card({required String title, required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius:
        BorderRadius.circular(14),

        border: Border.all(
          color: Colors.grey.shade200,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Text(
            title,

            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 12),

          child,
        ],
      ),
    );
  }

  /// عنصر صف
  Widget _rowItem(
      String label,
      String value,
      ) {

    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 6,
      ),

      child: Row(
        mainAxisAlignment:
        MainAxisAlignment.spaceBetween,

        children: [

          Text(
            label,

            style: const TextStyle(
              color: Colors.grey,
            ),
          ),

          Text(
            value,

            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}