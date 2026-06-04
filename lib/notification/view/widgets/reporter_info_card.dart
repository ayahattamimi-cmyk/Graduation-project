import 'package:flutter/material.dart';

import '../../data/models/reporter_model.dart';

import '../../../dashboard/view/widgets/sidebar.dart';
import 'detail_card.dart';

class ReporterInfoCard extends StatelessWidget {
  final ReporterModel reporter;
  final String status;
  final Function(AppPage)? onGoToAssignment;

  const ReporterInfoCard({
    super.key,
    required this.reporter,
    required this.status,
    this.onGoToAssignment,
  });

  @override
  Widget build(BuildContext context) {
    return DetailCard(
      title: 'بيانات المبلّغ',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text('الاسم', style: TextStyle(color: Colors.grey)),
          const SizedBox(height: 4),
          Text(
            reporter.name,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          const Text('رقم الجوال', style: TextStyle(color: Colors.grey)),
          const SizedBox(height: 4),
          Text(
            reporter.phone,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
