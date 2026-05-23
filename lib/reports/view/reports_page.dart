import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:web2/reports/viewmodel/reports_viewmodel.dart';
import 'widgets/report_filter_widget.dart';
import 'widgets/stat_card.dart';
import 'widgets/report_table.dart';
import 'widgets/top_supervisors_widget.dart';
import 'package:flutter/services.dart';
import 'widgets/supervisor_filter_widget.dart';

/// 🔹 مكتبات التصدير للويب
import 'package:pdf/widgets.dart' as pw;
import 'package:excel/excel.dart';
import 'dart:html' as html;
import 'dart:typed_data';

class ReportPage extends StatefulWidget {
  const ReportPage({super.key});

  @override
  State<ReportPage> createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  @override
  void initState() {
    super.initState();
    // جلب البيانات بمجرد دخول المسؤول للصفحة
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ReportViewModel>().loadAllData();
    });
  }

  /// ================= PDF EXPORT =================
  Future<void> exportToPDF(ReportViewModel vm) async {
    if (vm.filteredReports.isEmpty) return;

    final pdf = pw.Document();
    final fontData = await rootBundle.load("assets/fonts/Tajawal-Regular.ttf");
    final ttf = pw.Font.ttf(fontData);

    pdf.addPage(
      pw.MultiPage(
        textDirection: pw.TextDirection.rtl,
        build: (context) => [
          pw.Text(
            "التقارير والتحليلات - نظام البلاغات",
            style: pw.TextStyle(font: ttf, fontSize: 20, fontWeight: pw.FontWeight.bold),
          ),
          pw.SizedBox(height: 10),
          pw.Text(
            "إجمالي البلاغات الحالية: ${vm.filteredReports.length}",
            style: pw.TextStyle(font: ttf),
          ),
          pw.SizedBox(height: 20),

          // جدول البلاغات في PDF
          pw.Table.fromTextArray(
            headerStyle: pw.TextStyle(font: ttf, fontWeight: pw.FontWeight.bold),
            cellStyle: pw.TextStyle(font: ttf),
            headers: [
              "رقم البلاغ",
              "التاريخ",
              "المنطقة",
              "الحالة",
              "المواطن",
            ],
            data: vm.filteredReports
                .map<List<dynamic>>(
                  (r) => [
                    r.id,
                    r.createdAt.split('T')[0],
                    r.areaName,
                    r.status,
                    r.citizenName,
                  ],
                )
                .toList(),
          ),
        ],
      ),
    );

    final Uint8List bytes = await pdf.save();
    final blob = html.Blob([bytes], 'application/pdf');
    final url = html.Url.createObjectUrlFromBlob(blob);
    html.window.open(url, "_blank");
  }

  /// ================= EXCEL EXPORT =================
  void exportToExcel(ReportViewModel vm) {
    if (vm.filteredReports.isEmpty) return;

    final excel = Excel.createExcel();
    final sheet = excel['Reports'];
    
    sheet.appendRow(["📊 ملخص تقرير نظام البلاغات (مفلتر)"]);
    sheet.appendRow(["عدد البلاغات المصدرة", vm.filteredReports.length]);
    sheet.appendRow([]);
    sheet.appendRow(["رقم البلاغ", "التاريخ", "المنطقة", "الحالة"]);

    for (var r in vm.filteredReports) {
      sheet.appendRow([r.id, r.createdAt.split('T')[0], r.areaName, r.status]);
    }

    final bytes = excel.encode();
    if (bytes == null) return;
    
    final blob = html.Blob([bytes]);
    final url = html.Url.createObjectUrlFromBlob(blob);
    html.AnchorElement(href: url)
      ..setAttribute("download", "report_${DateTime.now().millisecondsSinceEpoch}.xlsx")
      ..click();
    html.Url.revokeObjectUrl(url);
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
                      ElevatedButton.icon(
                        onPressed: vm.filteredReports.isEmpty ? null : () => exportToPDF(vm),
                        icon: const Icon(Icons.picture_as_pdf, size: 18),
                        label: const Text("تصدير PDF"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.redAccent,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                      ),
                      const SizedBox(width: 10),
                      ElevatedButton.icon(
                        onPressed: vm.filteredReports.isEmpty ? null : () => exportToExcel(vm),
                        icon: const Icon(Icons.table_chart, size: 18),
                        label: const Text("تصدير Excel"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 20),

              /// --- FILTERS WIDGET ---
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

              /// --- STATS CARDS ---
              Row(
                children: [
                  Expanded(
                    child: StatCard(
                      title: "إجمالي البلاغات",
                      value: vm.generalStats?.total.toString() ?? vm.total.toString(),
                      color: Colors.blue,
                      icon: Icons.assignment,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: StatCard(
                      title: "البلاغات المحلولة",
                      value: vm.generalStats?.resolved.toString() ?? vm.solved.toString(),
                      color: Colors.green,
                      icon: Icons.check_circle,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: StatCard(
                      title: "قيد المعالجة",
                      value: vm.generalStats?.active.toString() ?? vm.pending.toString(),
                      color: Colors.orange,
                      icon: Icons.hourglass_bottom,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              /// --- MAIN DATA TABLE ---
              ReportTable(reports: vm.filteredReports),
              const SizedBox(height: 30),

              /// --- SUPERVISORS PERFORMANCE SECTION ---
              const SupervisorFilterWidget(),
              const SizedBox(height: 15),
              TopSupervisorsWidget(supervisors: vm.topSupervisors),
            ],
          );
        },
      ),
    );
  }
}