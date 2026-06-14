import 'package:flutter/material.dart';
import 'package:web2/reports/data/models/report_model.dart';

class ReportTable extends StatefulWidget {
  final List<ReportModel> reports;

  const ReportTable({super.key, required this.reports});

  @override
  State<ReportTable> createState() => _ReportTableState();
}

class _ReportTableState extends State<ReportTable> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  /// يعيد لوناً بناءً على حالة البلاغ.
  Color getStatusColor(String status) {
    status = status.toLowerCase();
    if (status.contains("محلول") ||
        status.contains("تم الحل") ||
        status == "solved" ||
        status == "completed") {
      return Colors.green;
    }
    if (status.contains("معالجة") ||
        status.contains("تنفيذ") ||
        status == "processing" ||
        status == "in_progress") {
      return Colors.orange;
    }
    if (status.contains("ملغي") ||
        status.contains("تم الغاء") ||
        status == "cancelled" ||
        status == "deleted") {
      return Colors.red;
    }
    if (status.contains("انتظار") || status == "pending") {
      return Colors.blue;
    }
    return Colors.grey;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        children: [
          const Align(
            alignment: Alignment.centerRight,
            child: Text(
              "تفاصيل البلاغات",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
          ),

          const SizedBox(height: 20),

          Container(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                _headerItem('ID', 1),
                _headerItem('التاريخ', 2),
                _headerItem('المنطقة', 2),
                _headerItem('النوع', 2),
                _headerItem('الحالة', 2),
                _headerItem('المواطن', 3),
              ],
            ),
          ),
          const Divider(thickness: 1),

          if (widget.reports.isEmpty)
            const Padding(
              padding: EdgeInsets.all(40.0),
              child: Center(
                child: Text(
                  "لا توجد بلاغات لعرضها حالياً",
                  style: TextStyle(color: Color(0xFF616161)),
                ),
              ),
            )
          else
            SizedBox(
              height: 500,
              child: Scrollbar(
                controller: _scrollController,
                thumbVisibility: true,
                child: ListView.builder(
                  controller: _scrollController,
                  itemCount: widget.reports.length,
                  itemBuilder: (context, index) {
                    final r = widget.reports[index];
                    return Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 12.0,
                            horizontal: 8,
                          ),
                          child: Row(
                            children: [
                              Expanded(flex: 1, child: Text("${r.id}")),
                              Expanded(
                                flex: 2,
                                child: Text(
                                  r.createdAt.contains('T')
                                      ? r.createdAt.split('T')[0]
                                      : r.createdAt,
                                  style: const TextStyle(fontSize: 13),
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: Text(
                                  r.areaName,
                                  style: const TextStyle(fontSize: 13),
                                ),
                              ),

                              Expanded(
                                flex: 2,
                                child: Align(
                                  alignment: Alignment.centerRight,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.purple.shade50,
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Text(
                                      r.reportType,
                                      style: TextStyle(
                                        fontSize: 11,
                                        color: Colors.purple.shade700,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ),
                              ),

                              Expanded(
                                flex: 2,
                                child: Align(
                                  alignment: Alignment.centerRight,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: getStatusColor(
                                        r.status,
                                      ).withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Text(
                                      r.status,
                                      style: TextStyle(
                                        color: getStatusColor(r.status),
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ),

                              Expanded(
                                flex: 3,
                                child: Text(
                                  r.citizenName,
                                  style: const TextStyle(fontSize: 13),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Divider(height: 1, color: Color(0xffEEEEEE)),
                      ],
                    );
                  },
                ),
              ),
            ),
        ],
      ),
    );
  }

  /// ينشئ خلية رأس جدول.
  Widget _headerItem(String title, int flex) {
    return Expanded(
      flex: flex,
      child: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          color: Color(0xFF374151),
          fontSize: 14,
        ),
      ),
    );
  }
}
