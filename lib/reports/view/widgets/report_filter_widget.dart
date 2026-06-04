import 'package:flutter/material.dart';

class ReportFilterWidget extends StatelessWidget {
  final String selectedArea;
  final String selectedType;
  final String selectedStatus;
  final String selectedPeriod;

  final Function(String) onAreaChanged;
  final Function(String) onTypeChanged;
  final Function(String) onStatusChanged;
  final Function(String) onPeriodChanged;

  final List<String> areas;
  final List<String> types;
  final List<String> statuses;
  final List<String> periods;

  const ReportFilterWidget({
    super.key,
    required this.selectedArea,
    required this.selectedType,
    required this.selectedStatus,
    required this.selectedPeriod,
    required this.onAreaChanged,
    required this.onTypeChanged,
    required this.onStatusChanged,
    required this.onPeriodChanged,
    required this.areas,
    required this.types,
    required this.statuses,
    required this.periods,
  });

  /// شكل الـ dropdown
  Widget _dropdown(
    String value,
    List<String> items,
    Function(String) onChanged,
  ) {
    return DropdownButtonFormField<String>(
      value: value,
      isExpanded: true,
      items:
          items
              .map(
                (e) => DropdownMenuItem(
                  value: e,
                  child: Text(e, overflow: TextOverflow.ellipsis),
                ),
              )
              .toList(),
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

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// العنوان
          Align(
            alignment: Alignment.centerRight,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Icon(Icons.filter_alt_outlined, color: Colors.blue),
                SizedBox(width: 6),
                Text(
                  "فلاتر التقرير",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          /// الليبلات
          Row(
            children: const [
              Expanded(child: Text("المنطقة")),
              SizedBox(width: 10),
              Expanded(child: Text("نوع البلاغ")),
              SizedBox(width: 10),
              Expanded(child: Text("الحالة")),
              SizedBox(width: 10),
              Expanded(child: Text("الفترة الزمنية")),
            ],
          ),

          const SizedBox(height: 8),

          /// الدروب داون
          Row(
            children: [
              Expanded(child: _dropdown(selectedArea, areas, onAreaChanged)),
              const SizedBox(width: 10),
              Expanded(child: _dropdown(selectedType, types, onTypeChanged)),
              const SizedBox(width: 10),
              Expanded(
                child: _dropdown(selectedStatus, statuses, onStatusChanged),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _dropdown(selectedPeriod, periods, onPeriodChanged),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
