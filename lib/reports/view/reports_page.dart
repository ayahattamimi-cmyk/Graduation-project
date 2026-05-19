import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:web2/reports/viewmodel/reports_viewmodel.dart';
import 'widgets/report_filter_widget.dart';
import 'widgets/stat_card.dart';
import 'widgets/report_table.dart';
import 'widgets/top_supervisors_widget.dart';
import 'package:flutter/services.dart';
import 'widgets/supervisor_filter_widget.dart';

/// 🔹 التصدير
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
    // دالة التهيئة: تجلب البيانات بمجرد دخول المسؤول للصفحة
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ReportViewModel>().loadAllData();
    });
  }

  /// ================= PDF =================
  Future<void> exportToPDF(ReportViewModel vm) async {
    final pdf = pw.Document();
    final fontData = await rootBundle.load("assets/fonts/Tajawal-Regular.ttf");
    final ttf = pw.Font.ttf(fontData);

    pdf.addPage(
      pw.MultiPage(
        textDirection: pw.TextDirection.rtl,
        build:
            (context) => [
              pw.Text(
                "التقارير والتحليلات",
                style: pw.TextStyle(font: ttf, fontSize: 20),
              ),
              pw.SizedBox(height: 10),
              pw.Text(
                "إجمالي البلاغات: ${vm.total}",
                style: pw.TextStyle(font: ttf),
              ),
              pw.Text(
                "البلاغات المحلولة: ${vm.solved}",
                style: pw.TextStyle(font: ttf),
              ),
              pw.SizedBox(height: 20),

              // جدول البلاغات في PDF
              pw.Table.fromTextArray(
                headerStyle: pw.TextStyle(font: ttf),
                cellStyle: pw.TextStyle(font: ttf),
                headers: [
                  "رقم البلاغ",
                  "التاريخ",
                  "المنطقة",
                  "الحالة",
                  "المواطن",
                ],
                data:
                    vm.reports
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

  /// ================= EXCEL =================
  void exportToExcel(ReportViewModel vm) {
    final excel = Excel.createExcel();
    final sheet = excel['Reports'];
    sheet.appendRow(["📊 ملخص تقرير نظام البلاغات"]);
    sheet.appendRow(["إجمالي البلاغات", vm.total]);
    sheet.appendRow([]);
    sheet.appendRow(["رقم البلاغ", "التاريخ", "المنطقة", "الحالة"]);

    for (var r in vm.reports) {
      sheet.appendRow([r.id, r.createdAt.split('T')[0], r.areaName, r.status]);
    }

    final bytes = excel.encode();
    final blob = html.Blob([bytes]);
    final url = html.Url.createObjectUrlFromBlob(blob);
    html.AnchorElement(href: url)
      ..setAttribute("download", "report.xlsx")
      ..click();
    html.Url.revokeObjectUrl(url);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ReportViewModel>(
      builder: (context, vm, _) {
        if (vm.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        return ListView(
          padding: const EdgeInsets.all(20),
          children: [
            /// HEADER
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
                      "متابعة أداء النظام والمشرفين",
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
                Row(
                  children: [
                    ElevatedButton.icon(
                      onPressed: () => exportToPDF(vm),
                      icon: const Icon(Icons.picture_as_pdf, size: 18),
                      label: const Text("تصدير PDF"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.redAccent,
                        foregroundColor: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton.icon(
                      onPressed: () => exportToExcel(vm),
                      icon: const Icon(Icons.table_chart, size: 18),
                      label: const Text("تصدير Excel"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),

            /// FILTERS
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

            /// STATS CARDS
            Row(
              children: [
                StatCard(
                  title: "إجمالي البلاغات",
                  value: vm.generalStats?.total.toString() ?? vm.total.toString(),
                  color: Colors.blue,
                  icon: Icons.assignment,
                ),
                StatCard(
                  title: "البلاغات المحلولة",
                  value: vm.generalStats?.resolved.toString() ?? vm.solved.toString(),
                  color: Colors.green,
                  icon: Icons.check_circle,
                ),
                StatCard(
                  title: "قيد المعالجة",
                  value: vm.generalStats?.active.toString() ?? vm.pending.toString(),
                  color: Colors.orange,
                  icon: Icons.hourglass_bottom,
                ),
              ],
            ),

            const SizedBox(height: 20),

            /// MAIN TABLE
            ReportTable(reports: vm.reports),

            const SizedBox(height: 30),

            /// SUPERVISORS SECTION
            const SupervisorFilterWidget(),
            const SizedBox(height: 15),

            // ويدجت أفضل المشرفين (الذي عدلناه سابقاً)
            TopSupervisorsWidget(supervisors: vm.topSupervisors),
          ],
        );
      },
    );
  }
}
