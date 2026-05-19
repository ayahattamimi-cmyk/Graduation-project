import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodel/reports_viewmodel.dart';

class SupervisorFilterWidget extends StatelessWidget {
  const SupervisorFilterWidget({super.key});

  Widget _dropdown(String value,
      List<String> items,
      Function(String) onChanged,) {
    return DropdownButtonFormField<String>(
      value: value,
      items: items
          .map((e) => DropdownMenuItem(value: e, child: Text(e)))
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
    final vm = context.watch<ReportViewModel>();

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

          /// 🔹 العنوان
          Align(
            alignment: Alignment.centerRight,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Icon(Icons.supervisor_account, color: Colors.blue),
                SizedBox(width: 6),
                Text(
                  "فلترة المشرفين",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          /// 🔹 labels
          Row(
            children: const [

              Expanded(
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Text("نوع العمل"),
                ),
              ),

              SizedBox(width: 10),

              Expanded(
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Text("المشرف"),
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          /// 🔹 dropdowns
          Row(
            children: [

              Expanded(
                child: _dropdown(
                  vm.selectedSupervisorType,
                  vm.supervisorTypes,
                  vm.setSupervisorType,
                ),
              ),

              const SizedBox(width: 10),

              Expanded(
                child: _dropdown(
                  vm.selectedSupervisor,
                  vm.supervisors,
                  vm.setSupervisor,
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),


          Row(
            children: const [
              Expanded(child: Text("المشرف")),
              SizedBox(width: 10),
              Expanded(child: Text(" البلاغ منجز")),
              SizedBox(width: 10),
              Expanded(child: Text("البلاغ الغير منجز")),
              SizedBox(width: 10),
              Expanded(child: Text("الإجمالي")),
              SizedBox(width: 10),
              Expanded(child: Text("النسبة")),
            ],
          ),

          const SizedBox(height: 10),

          Column(
            children: vm.supervisorStats.map((s) {
              return Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.symmetric(
                    vertical: 10, horizontal: 10),
                decoration: BoxDecoration(
                  color: const Color(0xffF9FAFB),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    Expanded(child: Text(s["name"])),
                    const SizedBox(width: 10),
                    Expanded(child: Text("${s["done"]}")),
                    const SizedBox(width: 10),
                    Expanded(child: Text("${s["notDone"]}")),
                    const SizedBox(width: 10),
                    Expanded(child: Text("${s["total"]}")),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        "${(s["rate"] ?? 0).toDouble().toStringAsFixed(1)}%",
                        style: const TextStyle(color: Colors.green),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}