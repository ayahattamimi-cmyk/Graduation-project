import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:web2/reports/viewmodel/reports_viewmodel.dart';
import 'widgets/report_filter_widget.dart';
import 'widgets/report_table.dart';
import 'widgets/top_supervisors_widget.dart';
import 'package:flutter/services.dart';
import 'widgets/supervisor_filter_widget.dart';

/// 🔹 مكتبات التصدير للويب
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:excel/excel.dart';
import 'dart:html' as html;

class ReportPage extends StatefulWidget {
  const ReportPage({super.key});

  @override
  State<ReportPage> createState() => _ReportPageState();
}

enum ExportMode { reports, supervisors, all }

class _ReportPageState extends State<ReportPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ReportViewModel>().loadAllData();
    });
  }

  /// دالة مساعدة لاستخراج التاريخ بأمان
  String _safeDate(String? dateStr) {
    if (dateStr == null || dateStr.trim().isEmpty) return '—';
    return dateStr.contains('T') ? dateStr.split('T')[0] : dateStr;
  }

  /// دالة مساعدة للنصوص تمنع الأخطاء نهائياً وتضع شرطة للأماكن الفارغة
  String _safeText(dynamic text) {
    if (text == null) return '—';
    String t = text.toString().trim();
    if (t.isEmpty || t == 'null' || t == '0') return '—';
    if (t.toLowerCase() == 'lifting') return 'رفع';
    if (t.toLowerCase() == 'sweeping') return 'كنس';
    return t;
  }

  /// دالة لتحويل الدقائق إلى تنسيق (ساعة ودقيقة) آمن ومحمي
  String _formatDuration(num? minutes) {
    if (minutes == null ||
        minutes.isNaN ||
        minutes.isInfinite ||
        minutes <= 0) {
      return '—'; // إرجاع شرطة في حال عدم وجود بيانات زمنية
    }
    int totalMinutes = minutes.round();
    if (totalMinutes < 60) return '$totalMinutes د';
    int h = totalMinutes ~/ 60;
    int m = totalMinutes % 60;
    if (m == 0) return '$h س';
    return '$h س $m د';
  }

  /// ================= PDF EXPORT =================
  /// ================= PDF EXPORT (النسخة النهائية المستقرة) =================
  Future<void> exportToPDF(ReportViewModel vm, ExportMode mode) async {
    try {
      final pdf = pw.Document();
      final fontData = await rootBundle.load(
        "assets/fonts/Tajawal-Regular.ttf",
      );
      final ttf = pw.Font.ttf(fontData);
      final style = pw.TextStyle(font: ttf, fontSize: 8);
      final boldStyle = pw.TextStyle(
        font: ttf,
        fontSize: 9,
        fontWeight: pw.FontWeight.bold,
      );

      // تجهيز البيانات
      final List<List<String>> reportRows =
          (mode == ExportMode.all || mode == ExportMode.reports)
              ? vm.filteredReports
                  .map(
                    (r) => [
                      _safeText(r.id),
                      _safeDate(r.createdAt),
                      _safeText(r.areaName),
                      _safeText(r.reportType),
                      _safeText(r.status),
                      _safeText(r.citizenName),
                    ],
                  )
                  .toList()
              : [];

      final List<List<String>> supervisorRows =
          (mode == ExportMode.all || mode == ExportMode.supervisors)
              ? vm.supervisorsPerformance
                  .map(
                    (s) => [
                      _safeText(s.name),
                      _safeText(s.type),
                      _safeText(s.receivedCount),
                      _safeText(s.completedCount),
                      _safeText(s.completionRate),
                      _formatDuration(s.avgResponseTime),
                      _formatDuration(s.avgProcessingTime),
                    ],
                  )
                  .toList()
              : [];

      pdf.addPage(
        pw.MultiPage(
          theme: pw.ThemeData(defaultTextStyle: style, paragraphStyle: style),
          textDirection: pw.TextDirection.rtl,
          margin: const pw.EdgeInsets.all(32),
          header:
              (context) => pw.Container(
                alignment: pw.Alignment.centerLeft,
                margin: const pw.EdgeInsets.only(bottom: 10),
                child: pw.Text(
                  "تاريخ التقرير: ${DateTime.now().toString().split(' ')[0]}",
                  style: style,
                ),
              ),
          build:
              (context) => [
                pw.Center(
                  child: pw.Text(
                    "تقرير أداء المنظومة",
                    style: boldStyle.copyWith(
                      fontSize: 16,
                      color: PdfColors.teal,
                    ),
                  ),
                ),
                pw.SizedBox(height: 20),

                if (reportRows.isNotEmpty) ...[
                  pw.Text("• بيانات البلاغات:", style: boldStyle),
                  pw.SizedBox(height: 8),
                  pw.Table(
                    border: pw.TableBorder.all(
                      color: PdfColors.grey400,
                      width: 0.5,
                    ),
                    children: [
                      pw.TableRow(
                        decoration: const pw.BoxDecoration(
                          color: PdfColors.teal,
                        ),
                        children:
                            [
                                  "ID",
                                  "التاريخ",
                                  "المنطقة",
                                  "النوع",
                                  "الحالة",
                                  "المواطن",
                                ]
                                .map(
                                  (h) => pw.Padding(
                                    padding: const pw.EdgeInsets.all(4),
                                    child: pw.Text(
                                      h,
                                      style: boldStyle.copyWith(
                                        color: PdfColors.white,
                                      ),
                                    ),
                                  ),
                                )
                                .toList(),
                      ),
                      ...reportRows.map(
                        (row) => pw.TableRow(
                          children:
                              row
                                  .map(
                                    (cell) => pw.Padding(
                                      padding: const pw.EdgeInsets.all(4),
                                      child: pw.Text(cell, style: style),
                                    ),
                                  )
                                  .toList(),
                        ),
                      ),
                    ],
                  ),
                  pw.SizedBox(height: 25),
                ],

                if (supervisorRows.isNotEmpty) ...[
                  pw.Text("• أداء المشرفين:", style: boldStyle),
                  pw.SizedBox(height: 8),
                  pw.Table(
                    border: pw.TableBorder.all(
                      color: PdfColors.grey400,
                      width: 0.5,
                    ),
                    children: [
                      pw.TableRow(
                        decoration: const pw.BoxDecoration(
                          color: PdfColors.blueGrey800,
                        ),
                        children:
                            [
                                  "المشرف",
                                  "النوع",
                                  "المستلم",
                                  "المنجز",
                                  "الإنجاز",
                                  "الاستجابة",
                                  "المعالجة",
                                ]
                                .map(
                                  (h) => pw.Padding(
                                    padding: const pw.EdgeInsets.all(4),
                                    child: pw.Text(
                                      h,
                                      style: boldStyle.copyWith(
                                        color: PdfColors.white,
                                      ),
                                    ),
                                  ),
                                )
                                .toList(),
                      ),
                      ...supervisorRows.map(
                        (row) => pw.TableRow(
                          children:
                              row
                                  .map(
                                    (cell) => pw.Padding(
                                      padding: const pw.EdgeInsets.all(4),
                                      child: pw.Text(cell, style: style),
                                    ),
                                  )
                                  .toList(),
                        ),
                      ),
                    ],
                  ),
                ],
              ],
        ),
      );

      final bytes = await pdf.save();
      final blob = html.Blob([bytes], 'application/pdf');
      final url = html.Url.createObjectUrlFromBlob(blob);
      html.AnchorElement(href: url)
        ..setAttribute(
          "download",
          "report_${DateTime.now().millisecondsSinceEpoch}.pdf",
        )
        ..click();
      _showSuccess("تم تصدير ملف PDF بنجاح");
    } catch (e) {
      debugPrint("❌ PDF Error: $e");
      _showError("فشل تصدير التقرير: $e");
    }
  }

  /// ================= EXCEL EXPORT =================
  void exportToExcel(ReportViewModel vm, ExportMode mode) {
    if (mode == ExportMode.reports && vm.filteredReports.isEmpty) return;
    if (mode == ExportMode.supervisors && vm.supervisorsPerformance.isEmpty) {
      return;
    }

    try {
      final excel = Excel.createExcel();
      final defaultSheet = excel.getDefaultSheet();
      final sheet = excel[defaultSheet ?? 'Sheet1'];

      // === قسم البلاغات ===
      if (mode == ExportMode.all || mode == ExportMode.reports) {
        sheet.appendRow(["تقرير البلاغات - نظام البلاغات"]);
        sheet.appendRow(["عدد البلاغات", "${vm.filteredReports.length}"]);
        sheet.appendRow([
          "تاريخ التصدير",
          DateTime.now().toString().split('.')[0],
        ]);
        sheet.appendRow([]);
        sheet.appendRow([
          "المواطن",
          "الحالة",
          "النوع",
          "المنطقة",
          "التاريخ",
          "رقم البلاغ",
        ]);

        for (var r in vm.filteredReports) {
          sheet.appendRow([
            _safeText(r.citizenName),
            _safeText(r.status),
            _safeText(r.reportType),
            _safeText(r.areaName),
            _safeDate(r.createdAt),
            _safeText(r.id),
          ]);
        }
      }

      // === قسم أداء المشرفين ===
      if (mode == ExportMode.all || mode == ExportMode.supervisors) {
        if (mode == ExportMode.all) {
          sheet.appendRow([]);
          sheet.appendRow([]);
          sheet.appendRow(["------------------------------------------"]);
        }
        sheet.appendRow(["تقرير أداء المشرفين"]);
        sheet.appendRow([
          "عدد المشرفين",
          "${vm.supervisorsPerformance.length}",
        ]);
        sheet.appendRow([]);
        sheet.appendRow([
          "وقت المعالجة",
          "وقت الاستجابة",
          "نسبة الإنجاز",
          "المنجز",
          "المستلم",
          "النوع",
          "المشرف",
        ]);

        for (var s in vm.supervisorsPerformance) {
          sheet.appendRow([
            _formatDuration(s.avgProcessingTime),
            _formatDuration(s.avgResponseTime),
            _safeText(s.completionRate),
            _safeText(s.completedCount),
            _safeText(s.receivedCount),
            _safeText(s.type),
            _safeText(s.name),
          ]);
        }
      }

      final bytes = excel.encode();
      if (bytes == null) return;
      final blob = html.Blob([
        bytes,
      ], 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet');
      final url = html.Url.createObjectUrlFromBlob(blob);
      html.AnchorElement(href: url)
        ..setAttribute(
          "download",
          "report_${mode.name}_${DateTime.now().millisecondsSinceEpoch}.xlsx",
        )
        ..click();
      _showSuccess("تم تحميل ملف Excel بنجاح");
    } catch (e) {
      _showError("خطأ في تصدير Excel: $e");
    }
  }

  void _showSuccess(String msg) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("✅ $msg"), backgroundColor: Colors.green),
    );
  }

  void _showError(String msg) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("❌ $msg"), backgroundColor: Colors.red),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff6f8fb),
      body: Consumer<ReportViewModel>(
        builder: (context, vm, _) {
          if (vm.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          return ListView(
            padding: const EdgeInsets.all(20),
            children: [
              /// --- HEADER SECTION ---
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        "التقارير والتحليلات",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        "متابعة أداء النظام والمشرفين والمربعات الجغرافية",
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      _buildExportMenu(
                        title: "تصدير PDF",
                        icon: Icons.picture_as_pdf,
                        color: Colors.redAccent,
                        onSelected: (mode) => exportToPDF(vm, mode),
                        isDisabled:
                            vm.filteredReports.isEmpty &&
                            vm.supervisorsPerformance.isEmpty,
                      ),
                      const SizedBox(width: 10),
                      _buildExportMenu(
                        title: "تصدير Excel",
                        icon: Icons.table_chart,
                        color: Colors.green,
                        onSelected: (mode) => exportToExcel(vm, mode),
                        isDisabled:
                            vm.filteredReports.isEmpty &&
                            vm.supervisorsPerformance.isEmpty,
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 20),

              ReportFilterWidget(
                selectedArea: vm.selectedArea,
                selectedType: vm.selectedType,
                selectedStatus: vm.selectedStatus,
                selectedPeriod: vm.selectedPeriod,
                onAreaChanged: vm.setArea,
                onTypeChanged: vm.setType,
                onStatusChanged: vm.setStatus,
                onPeriodChanged: vm.setPeriod,
                areas: vm.areas,
                types: vm.types,
                statuses: vm.status,
                periods: vm.periods,
              ),
              const SizedBox(height: 20),

              ReportTable(reports: vm.filteredReports),
              const SizedBox(height: 30),

              const SupervisorFilterWidget(),
              const SizedBox(height: 15),
              TopSupervisorsWidget(supervisors: vm.topSupervisors),
            ],
          );
        },
      ),
    );
  }

  Widget _buildExportMenu({
    required String title,
    required IconData icon,
    required Color color,
    required Function(ExportMode) onSelected,
    required bool isDisabled,
  }) {
    return PopupMenuButton<ExportMode>(
      enabled: !isDisabled,
      onSelected: onSelected,
      offset: const Offset(0, 50),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      itemBuilder:
          (context) => [
            PopupMenuItem(
              value: ExportMode.reports,
              child: Row(
                children: const [
                  Icon(Icons.assignment_outlined, size: 18),
                  SizedBox(width: 10),
                  Text("تصدير البلاغات فقط"),
                ],
              ),
            ),
            PopupMenuItem(
              value: ExportMode.supervisors,
              child: Row(
                children: const [
                  Icon(Icons.badge_outlined, size: 18),
                  SizedBox(width: 10),
                  Text("تصدير أداء المشرفين فقط"),
                ],
              ),
            ),
            const PopupMenuDivider(),
            PopupMenuItem(
              value: ExportMode.all,
              child: Row(
                children: const [
                  Icon(Icons.all_inclusive, size: 18),
                  SizedBox(width: 10),
                  Text("تصدير شامل (الكل)"),
                ],
              ),
            ),
          ],
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isDisabled ? Colors.grey.shade300 : color,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Icon(icon, size: 18, color: Colors.white),
            const SizedBox(width: 8),
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Icon(Icons.arrow_drop_down, color: Colors.white),
          ],
        ),
      ),
    );
  }
}
