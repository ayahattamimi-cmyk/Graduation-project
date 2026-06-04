import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodel/assignment_viewmodel.dart';
import 'widgets/assignment_form_card.dart';
import 'widgets/assignment_empty_state.dart';
import '../../map/view/map_screen.dart';

class ReportAssignmentPage extends StatefulWidget {
  final int? reportId;

  const ReportAssignmentPage({super.key, this.reportId});

  @override
  State<ReportAssignmentPage> createState() => _ReportAssignmentPageState();
}

class _ReportAssignmentPageState extends State<ReportAssignmentPage> {
  @override
  void initState() {
    super.initState();
    if (widget.reportId != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.read<AssignmentViewModel>().loadAssignmentSuggestion(
          widget.reportId!,
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<AssignmentViewModel>();

    return Scaffold(
      backgroundColor: const Color(0xfff6f8fb),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
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
              ),
              OutlinedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) =>
                              WebMapScreen(focusReportId: widget.reportId),
                    ),
                  );
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

          if (widget.reportId == null)
            const AssignmentEmptyState()
          else if (vm.isLoading && vm.supervisors.isEmpty)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(40.0),
                child: CircularProgressIndicator(),
              ),
            )
          else
            AssignmentFormCard(vm: vm, reportId: widget.reportId!),
        ],
      ),
    );
  }
}
