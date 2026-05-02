import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodel/reports_viewmodel.dart';
import 'widgets/report_filter_widget.dart';
import 'widgets/stat_card.dart';
import 'widgets/report_table.dart';
import 'widgets/top_supervisors_widget.dart';
import 'package:flutter/services.dart';

/// 🔹 التصدير
import 'package:pdf/widgets.dart' as pw;
import 'package:excel/excel.dart';
import 'dart:html' as html;
import 'dart:typed_data';

class ReportPage extends StatelessWidget {
  const ReportPage({super.key});

  /// ================= PDF =================
  Future<void> exportToPDF(vm) async {
    final pdf = pw.Document();

    /// 🔥 تحميل الخط
    final fontData =
    await rootBundle.load("assets/fonts/Tajawal-Regular.ttf");
    final ttf = pw.Font.ttf(fontData);

    pdf.addPage(
      pw.MultiPage(
        textDirection: pw.TextDirection.rtl, // 👈 دعم العربي
        build: (context) => [

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
          pw.Text(
            "قيد المعالجة: ${vm.pending}",
            style: pw.TextStyle(font: ttf),
          ),

          pw.SizedBox(height: 20),

          pw.Table.fromTextArray(
            headerStyle: pw.TextStyle(font: ttf),
            cellStyle: pw.TextStyle(font: ttf),
            headers: [
              "رقم البلاغ",
              "التاريخ",
              "المنطقة",
              "النوع",
              "الحالة",
              "المشرف"
            ],
            data: vm.filteredReports.map<List<dynamic>>((r) => [
              r.id,
              r.date,
              r.area,
              r.type,
              r.status,
              r.supervisor
            ]).toList(),
          ),

          pw.SizedBox(height: 20),

          pw.Text(
            "أفضل المشرفين",
            style: pw.TextStyle(font: ttf),
          ),

          ...vm.topSupervisors.map(
                (s) => pw.Text(
              s,
              style: pw.TextStyle(font: ttf),
            ),
          ),
        ],
      ),
    );

    final Uint8List bytes = await pdf.save();

    final blob = html.Blob([bytes], 'application/pdf');
    final url = html.Url.createObjectUrlFromBlob(blob);

    /// 🔥 فتح الملف (حل مضمون)
    html.window.open(url, "_blank");
  }

  /// ================= EXCEL =================
  void exportToExcel(vm) {
    final excel = Excel.createExcel();

    final sheet = excel['Reports'];

    sheet.appendRow(["📊 ملخص التقرير"]);
    sheet.appendRow([]);

    sheet.appendRow(["إجمالي البلاغات", vm.total]);
    sheet.appendRow(["البلاغات المحلولة", vm.solved]);
    sheet.appendRow(["قيد المعالجة", vm.pending]);
    sheet.appendRow(["معدل الإنجاز", vm.pending]);

    sheet.appendRow([]);

    sheet.appendRow([
      "رقم البلاغ",
      "التاريخ",
      "المنطقة",
      "النوع",
      "الحالة",
      "المشرف"
    ]);

    for (var r in vm.filteredReports) {
      sheet.appendRow([
        r.id,
        r.date,
        r.area,
        r.type,
        r.status,
        r.supervisor
      ]);
    }

    final supSheet = excel['Supervisors'];

    supSheet.appendRow(["أفضل 3 مشرفين"]);

    for (var s in vm.topSupervisors) {
      supSheet.appendRow([s]);
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
    return ChangeNotifierProvider(
      create: (_) => ReportViewModel()..loadData(),
      child: Consumer<ReportViewModel>(
        builder: (context, vm, _) {

          if (vm.reports.isEmpty) {
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
                    crossAxisAlignment: CrossAxisAlignment.end,
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
                        "متابعة الأداء واتخاذ القرار",
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),

                  Row(
                    children: [

                      /// PDF
                      SizedBox(
                        height: 45,
                        child: ElevatedButton(
                          onPressed: () async {
                            if (vm.filteredReports.isEmpty) return;
                            await exportToPDF(vm);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 12),
                          ),
                          child: const Text("تصدير PDF",style: TextStyle(color: Colors.white)),
                        ),
                      ),

                      const SizedBox(width: 10),

                      /// Excel
                      SizedBox(
                        height: 45,
                        child:ElevatedButton(

                          onPressed: () {
                            if (vm.filteredReports.isEmpty) return;
                            exportToExcel(vm);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 12),
                          ),
                          child: const Text(
                            "تصدير Excel",
                            style: TextStyle(color: Colors.white),
                          ),
                        ), 
                      )

                    ],
                  )
                ],
              ),

              const SizedBox(height: 20),

              /// FILTER
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

              /// STATS
              Row(
                children: [
                  StatCard(title: "إجمالي البلاغات", value: vm.total.toString(), color: Colors.blue, icon: Icons.trending_up),
                  StatCard(title: "البلاغات المحلولة", value: vm.solved.toString(), color: Colors.green, icon: Icons.trending_up),
                  StatCard(title: "قيد المعالجة", value: vm.pending.toString(), color: Colors.orange, icon: Icons.trending_up),
                  StatCard(title: "معدل الانجاز", value: vm.pending.toString(), color: Colors.orange, icon: Icons.trending_up),
                ],
              ),

              const SizedBox(height: 20),

              /// TABLE
              ReportTable(reports: vm.filteredReports),

              const SizedBox(height: 20),

              /// TOP SUPERVISORS
              TopSupervisorsWidget(supervisors: vm.topSupervisors),
            ],
          );
        },
      ),
    );
  }
}