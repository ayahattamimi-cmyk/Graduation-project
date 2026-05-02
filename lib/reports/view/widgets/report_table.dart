import 'package:flutter/material.dart';
import '../../data/report_data.dart';

class ReportTable extends StatelessWidget {
  final List<ReportData> reports;

  const ReportTable({super.key, required this.reports});

  Color getStatusColor(String status) {
    switch (status) {
      case "محلول":
        return Colors.green;
      case "قيد التنفيذ":
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        children: [

          /// العنوان
          const Align(
            alignment: Alignment.centerRight,
            child: Text(
              "تفاصيل البلاغات",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),

          const SizedBox(height: 20),

          /// الهيدر
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Expanded(child: Text("رقم البلاغ")),
              Expanded(child: Text("التاريخ")),
              Expanded(child: Text("المنطقة")),
              Expanded(child: Text("النوع")),
              Expanded(child: Text("الحالة")),
              Expanded(child: Text("مدة الإنجاز")),
              Expanded(child: Text("المشرف")),
            ],
          ),

          const Divider(),

          /// البيانات
          ...reports.map((r) {
            return Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [

                    Expanded(child: Text(r.id)),
                    Expanded(child: Text(r.date)),
                    Expanded(child: Text(r.area)),

                    /// النوع
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.purple.shade100,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(r.type, textAlign: TextAlign.center),
                      ),
                    ),

                    /// الحالة
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: getStatusColor(r.status).withOpacity(0.2),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          r.status,
                          textAlign: TextAlign.center,
                          style: TextStyle(color: getStatusColor(r.status)),
                        ),
                      ),
                    ),

                    Expanded(child: Text("${r.duration} ساعة")),
                    Expanded(child: Text(r.supervisor)),
                  ],
                ),
                const Divider(),
              ],
            );
          }),
        ],
      ),
    );
  }
}