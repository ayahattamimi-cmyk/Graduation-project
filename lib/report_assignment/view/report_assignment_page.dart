import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodel/assignment_viewmodel.dart';

class ReportAssignmentPage extends StatefulWidget {
  // 1. التعديل: استقبال معرف البلاغ بشكل اختياري للسماح بفتحه من القائمة الجانبية دون كراش
  final int? reportId;

  const ReportAssignmentPage({super.key, this.reportId});

  @override
  State<ReportAssignmentPage> createState() => _ReportAssignmentPageState();
}

class _ReportAssignmentPageState extends State<ReportAssignmentPage> {
  @override
  void initState() {
    super.initState();
    // 2. التعديل: استدعاء التوجيه التلقائي تلقائياً بمجرد فتح الصفحة إذا كان هناك معرف بلاغ
    if (widget.reportId != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.read<AssignmentViewModel>().loadAssignmentSuggestion(widget.reportId!);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // 3. التعديل: الاستماع للبروفايدر المركزي
    final vm = context.watch<AssignmentViewModel>();

    return Scaffold(
      backgroundColor: const Color(0xfff6f8fb),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          /// --- HEADER ---
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    "توجيه البلاغات",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 6),
                  Text(
                    "تعيين البلاغات للمشرفين حسب المربعات الجغرافية",
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
              OutlinedButton.icon(
                onPressed: () {
                  // Navigator.pushNamed(context, "/mapPage");
                },
                icon: const Icon(Icons.map_outlined, color: Colors.white),
                label: const Text(
                  "عرض الخريطة",
                  style: TextStyle(color: Colors.white),
                ),
                style: OutlinedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // 4. التعديل: إذا لم يتم توفير معرف البلاغ (مثل الضغط من القائمة الجانبية)، نعرض واجهة فارغة توضيحية
          if (widget.reportId == null)
            _buildEmptyState()
          else
            /// --- FORM CARD ---
            Card(
              color: Colors.white,
              shape: RoundedRectangleBorder(
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
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    const Text("المربع الجغرافي المقترح"),
                    const SizedBox(height: 6),

                    // حقل عرض ثابت يعرض اقتراح السيرفر التلقائي بناءً على إحداثيات البلاغ
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: Text(
                        vm.selectedArea.isNotEmpty ? vm.selectedArea : "لم يتم تحديد المنطقة بعد",
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                    ),

                    const SizedBox(height: 16),
                    const Text("نوع العمل"),
                    const SizedBox(height: 6),

                    // الـ Dropdown ليرسل القيم المقبولة في Laravel وعرضها بالعربية للمدير
                    DropdownButtonFormField<String>(
                      value: vm.selectedWorkType,
                      dropdownColor: Colors.white,
                      decoration: _inputDecoration(),
                      items: vm.workTypes
                          .map(
                            (e) => DropdownMenuItem(
                              value: e,
                              child: Text(e == "sweeping" ? "كنس" : "رفع"),
                            ),
                          )
                          .toList(),
                      onChanged: (v) => vm.setWorkType(v!),
                    ),

                    /// كرت المشرف المسؤول
                    if (vm.supervisorName.isNotEmpty)
                      Container(
                        margin: const EdgeInsets.only(top: 20),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xffE8F0FE),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.person, color: Colors.blue),
                            const SizedBox(width: 10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "المشرف المسؤول المقترح للعمل بموقع البلاغ",
                                  style: TextStyle(color: Colors.grey, fontSize: 12),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  vm.supervisorName,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                    /// كرت إحصائيات المربع المقترح
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
                          const Text("إجمالي البلاغات النشطة في هذا المربع جغرافياً:"),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
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
                    const SizedBox(height: 20),

                    /// زر التعيين النهائي والتأكيد على السيرفر
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
                        onPressed: vm.isLoading
                            ? null // تعطيل الزر أثناء المعالجة لحماية السيرفر من تكرار الطلبات
                            : () async {
                                // هنا نمرر الـ reportId المتاح في الـ State
                                bool success = await vm.sendAssignment(widget.reportId!);
                                
                                if (context.mounted && success) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text("تم بنجاح تعيين البلاغ ومشاركته مع المشرف: ${vm.supervisorName}"),
                                      backgroundColor: Colors.green,
                                    ),
                                  );
                                  Navigator.pop(context); // العودة التلقائية لصفحة تفاصيل البلاغات
                                } else if (context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text("عذراً، فشل إرسال التعيين الحقيقي، تأكد من الاتصال"),
                                      backgroundColor: Colors.redAccent,
                                    ),
                                  );
                                }
                              },
                        icon: vm.isLoading 
                            ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                            : const Icon(Icons.check, color: Colors.white),
                        label: Text(
                          vm.isLoading ? "جاري التوجيه بالسيرفر..." : "تأكيد التوجيه النهائي",
                          style: const TextStyle(fontSize: 14, color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  // 5. التعديل: إضافة واجهة تصميمية ممتازة لعدم وجود بلاغ محدد
  Widget _buildEmptyState() {
    return Card(
      color: Colors.white,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.alt_route_rounded,
                size: 64,
                color: Colors.blue.shade700,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              "لم يتم اختيار بلاغ لتوجيهه",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              "ميزة التوجيه التلقائي للمشرفين تتطلب تحديد بلاغ معين أولاً لدراسة موقعه الجغرافي واقتراح المشرف الأنسب.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 32),
            const Text(
              "💡 نصيحة: يرجى الذهاب لقسم الإشعارات أو التقارير، وفتح تفاصيل البلاغ المطلوب، ثم الضغط على زر 'توجيه البلاغ'.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                color: Colors.blueGrey,
                fontStyle: FontStyle.italic,
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
