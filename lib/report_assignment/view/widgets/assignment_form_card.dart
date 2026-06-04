import 'package:flutter/material.dart';
import '../../viewmodel/assignment_viewmodel.dart';

class AssignmentFormCard extends StatelessWidget {
  final AssignmentViewModel vm;
  final int reportId;

  const AssignmentFormCard({
    super.key,
    required this.vm,
    required this.reportId,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 0,
      shape: RoundedRectangleBorder(
        side: BorderSide(color: Colors.grey.shade200),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: Text(
                "نموذج توجيه البلاغ الآلي",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 20),

            const Text(
              "المربع الجغرافي المقترح",
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),

            InputDecorator(
              decoration: _inputDecoration(),
              child: Text(
                vm.selectedArea.isNotEmpty
                    ? vm.selectedArea
                    : "لم يتم تحديد المنطقة بعد",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
            ),

            const SizedBox(height: 16),
            const Text(
              "نوع العمل",
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),

            DropdownButtonFormField<String>(
              value: vm.selectedWorkType,
              dropdownColor: Colors.white,
              decoration: _inputDecoration(),
              items:
                  vm.workTypes
                      .map(
                        (e) => DropdownMenuItem(
                          value: e,
                          child: Text(e == "sweeping" ? "كنس" : "رفع"),
                        ),
                      )
                      .toList(),
              onChanged: (v) {
                if (v != null) vm.setWorkType(v);
              },
            ),

            const SizedBox(height: 16),
            const Text(
              "المشرف المسؤول",
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),

            DropdownButtonFormField<int>(
              value:
                  vm.supervisors.any((s) => s.id == vm.selectedSupervisorId)
                      ? vm.selectedSupervisorId
                      : null,
              dropdownColor: Colors.white,
              decoration: _inputDecoration().copyWith(
                prefixIcon: const Icon(Icons.person, color: Colors.blue),
                hintText: "اختر المشرف المسؤول",
              ),
              items:
                  vm.supervisors.map((s) {
                    return DropdownMenuItem<int>(
                      value: s.id,
                      child: Text(s.name),
                    );
                  }).toList(),
              onChanged: (v) {
                if (v != null) vm.setSupervisor(v);
              },
            ),

            if (vm.suggestion != null &&
                vm.selectedSupervisorId == vm.suggestion!.supervisorId)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Row(
                  children: [
                    Icon(
                      Icons.auto_awesome,
                      size: 14,
                      color: Colors.blue.shade700,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      "هذا هو المشرف المقترح آلياً حسب موقع البلاغ",
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.blue.shade700,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),

            Container(
              margin: const EdgeInsets.only(top: 16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "إجمالي البلاغات النشطة في هذا المربع جغرافياً:",
                    style: TextStyle(fontSize: 13),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.orange.shade100,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      vm.reportsCount.toString(),
                      style: const TextStyle(
                        color: Colors.orange,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed:
                    vm.isLoading
                        ? null
                        : () async {
                          bool success = await vm.sendAssignment(reportId);

                          if (context.mounted && success) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  "تم بنجاح تعيين البلاغ ومشاركته مع المشرف: ${vm.selectedSupervisorName}",
                                ),
                                backgroundColor: Colors.green,
                              ),
                            );
                            Navigator.pop(context);
                          } else if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  "عذراً، فشل إرسال التعيين الحقيقي، تأكد من الاتصال",
                                ),
                                backgroundColor: Colors.redAccent,
                              ),
                            );
                          }
                        },
                icon:
                    vm.isLoading
                        ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                        : const Icon(Icons.check, color: Colors.white),
                label: Text(
                  vm.isLoading
                      ? "جاري التوجيه بالسيرفر..."
                      : "تأكيد التوجيه النهائي",
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  InputDecoration _inputDecoration() {
    return InputDecoration(
      filled: true,
      fillColor: Colors.grey.shade100,
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
    );
  }
}
