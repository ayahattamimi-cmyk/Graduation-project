import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodel/reports_viewmodel.dart';
import '../../data/models/SupervisorPerformanceModel.dart';

class SupervisorFilterWidget extends StatefulWidget {
  const SupervisorFilterWidget({super.key});

  @override
  State<SupervisorFilterWidget> createState() => _SupervisorFilterWidgetState();
}

class _SupervisorFilterWidgetState extends State<SupervisorFilterWidget> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Widget _dropdown(
    String value,
    List<String> items,
    Function(String) onChanged,
  ) {
    final String safeValue =
        items.contains(value) ? value : (items.isNotEmpty ? items.first : '');

    return DropdownButtonFormField<String>(
      value: safeValue,
      items:
          items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
      onChanged: (v) => onChanged(v!),
      icon: const Icon(Icons.keyboard_arrow_down),
      decoration: InputDecoration(
        filled: true,
        fillColor: const Color(0xffF3F4F6),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 10,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  /// تحويل وقت الدقائق إلى نص مقروء (مثل: 2 ساعة 3 دقيقة)
  String _formatMinutes(num? minutes) {
    if (minutes == null || minutes == 0) return '—';
    final int total = minutes.round();
    if (total < 60) return '$total د';
    final int h = total ~/ 60;
    final int m = total % 60;
    return m == 0 ? '$h س' : '$h س $m د';
  }

  /// لون حسب نسبة الإنجاز
  Color _rateColor(String rate) {
    final v = double.tryParse(rate.replaceAll('%', '')) ?? 0;
    if (v >= 75) return Colors.green;
    if (v >= 40) return Colors.orange;
    return Colors.red;
  }

  /// ترجمة نوع العمل من الإنجليزية
  String _translateType(String type) {
    switch (type.toLowerCase()) {
      case 'lifting':
        return 'رفع';
      case 'sweeping':
        return 'كنس';
      default:
        return type;
    }
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<ReportViewModel>();

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// 🔹 العنوان
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: const [
                  Icon(Icons.supervisor_account_rounded, color: Colors.blue),
                  SizedBox(width: 8),
                  const Text(
                    'أداء المشرفين',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ],
              ),
              // عداد النتائج
              if (vm.supervisorsPerformance.isNotEmpty)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '${vm.supervisorsPerformance.length} مشرف',
                    style: TextStyle(
                      color: Colors.blue.shade700,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
            ],
          ),

          const SizedBox(height: 20),

          /// 🔹 صف الفلاتر
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'نوع العمل',
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                    const SizedBox(height: 6),
                    _dropdown(vm.selectedSupType, vm.types, vm.setSupType),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'المشرف',
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                    const SizedBox(height: 6),
                    _dropdown(
                      vm.selectedSupervisor,
                      vm.supervisors,
                      vm.setSupervisor,
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),
          const Divider(height: 1),
          const SizedBox(height: 12),

          /// 🔹 هيدر الجدول
          _buildTableHeader(),

          const SizedBox(height: 8),

          /// 🔹 محتوى الجدول
          if (vm.isLoadingSupervisors)
            const Padding(
              padding: EdgeInsets.all(30),
              child: Center(child: CircularProgressIndicator()),
            )
          else if (vm.supervisorsPerformance.isEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.all(30),
                child: Column(
                  children: [
                    Icon(
                      Icons.search_off_rounded,
                      size: 40,
                      color: Colors.grey.shade400,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'لا توجد بيانات للمشرفين بهذه الفلترة',
                      style: TextStyle(color: Colors.grey.shade500),
                    ),
                  ],
                ),
              ),
            )
          else
            SizedBox(
              height: 400, // ارتفاع ثابت لمنطقة تمرير المشرفين
              child: Scrollbar(
                controller: _scrollController,
                thumbVisibility: true,
                child: ListView.builder(
                  controller: _scrollController,
                  itemCount: vm.supervisorsPerformance.length,
                  itemBuilder: (context, index) {
                    return _buildTableRow(vm.supervisorsPerformance[index]);
                  },
                ),
              ),
            ),
        ],
      ),
    );
  }

  /// هيدر الجدول
  Widget _buildTableHeader() {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 12,
      color: Color(0xff6B7280),
    );
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xffF9FAFB),
        borderRadius: BorderRadius.circular(10),
      ),
      child: const Row(
        children: [
          Expanded(flex: 3, child: Text('المشرف', style: style)),
          Expanded(flex: 2, child: Text('نوع العمل', style: style)),
          Expanded(
            flex: 1,
            child: Text('المستلم', style: style, textAlign: TextAlign.center),
          ),
          Expanded(
            flex: 1,
            child: Text('المنجز', style: style, textAlign: TextAlign.center),
          ),
          Expanded(
            flex: 2,
            child: Text(
              'نسبة الإنجاز',
              style: style,
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              'وقت الاستجابة',
              style: style,
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              'وقت المعالجة',
              style: style,
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  /// صف بيانات مشرف
  Widget _buildTableRow(SupervisorPerformanceModel s) {
    final rateColor = _rateColor(s.completionRate);

    return Container(
      margin: const EdgeInsets.only(bottom: 6),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Row(
        children: [
          /// الاسم
          Expanded(
            flex: 3,
            child: Text(
              s.name,
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
              overflow: TextOverflow.ellipsis,
            ),
          ),

          /// نوع العمل
          Expanded(
            flex: 2,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color:
                    s.type.toLowerCase() == 'lifting'
                        ? Colors.orange.shade50
                        : Colors.teal.shade50,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                _translateType(s.type),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color:
                      s.type.toLowerCase() == 'lifting'
                          ? Colors.orange.shade700
                          : Colors.teal.shade700,
                ),
              ),
            ),
          ),

          /// المستلم
          Expanded(
            flex: 1,
            child: Text(
              '${s.receivedCount}',
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),

          /// المنجز
          Expanded(
            flex: 1,
            child: Text(
              '${s.completedCount}',
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),

          /// نسبة الإنجاز
          Expanded(
            flex: 2,
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: rateColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  s.completionRate,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: rateColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
              ),
            ),
          ),

          /// وقت الاستجابة
          Expanded(
            flex: 2,
            child: Text(
              _formatMinutes(s.avgResponseTime),
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
            ),
          ),

          /// وقت المعالجة
          Expanded(
            flex: 2,
            child: Text(
              _formatMinutes(s.avgProcessingTime),
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
            ),
          ),
        ],
      ),
    );
  }
}
