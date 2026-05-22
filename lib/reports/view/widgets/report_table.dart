import 'package:flutter/material.dart';
import 'package:web2/reports/data/models/report_model.dart';

class ReportTable extends StatelessWidget {
  final List<ReportModel> reports;

  const ReportTable({super.key, required this.reports});

  Color getStatusColor(String status) {
    switch (status) {
      case "محلول":
      case "تم الحل":
        return Colors.green;
      case "قيد التنفيذ":
        return Colors.orange;
      case "قيد الانتظار":
        return Colors.blue;
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
            children: const [
              Expanded(
                flex: 1,
                child: Text(
                  "ID",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              Expanded(flex: 2, child: Text("التاريخ")),
              Expanded(flex: 2, child: Text("المنطقة")),
              Expanded(flex: 1, child: Text("النوع")),
              Expanded(flex: 2, child: Text("الحالة")),
              Expanded(flex: 2, child: Text("المواطن")),
            ],
          ),
          const Divider(thickness: 1.5),

          /// البيانات
          if (reports.isEmpty)
            const Padding(
              padding: EdgeInsets.all(20.0),
              child: Text("لا توجد بلاغات لعرضها حالياً"),
            )
          else
            ...reports.map((r) {
              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(child: Text("${r.id}")),
                        Expanded(child: Text(r.createdAt.split('T')[0])),
                        Expanded(child: Text(r.areaName)),

                        /// النوع
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.purple.shade100,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              r.reportType,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),

                        /// الحالة
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
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
                        Expanded(
                          flex: 2,
                          child: Text(
                            r.citizenName,
                            style: const TextStyle(fontSize: 12),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Divider(color: Color(0xffEEEEEE)),
                ],
              );
            }),
        ],
      ),
    );
  }
}
