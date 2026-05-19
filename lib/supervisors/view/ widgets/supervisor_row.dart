import 'package:flutter/material.dart';
import '../../model/supervisor_model.dart';
import '../dialogs/edit_supervisor_dialog.dart';

class SupervisorRow extends StatelessWidget {

  final SupervisorModel supervisor;
  final int index;

  const SupervisorRow({
    super.key,
    required this.supervisor,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {

    final bool isSweeping = supervisor.type == "sweeping";

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 18,
      ),

      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Color(0xffE5E7EB),
          ),
        ),
      ),

      child: Row(
        children: [

          /// الاسم
          Expanded(
            flex: 4,
            child: Row(
              children: [

                const Icon(
                  Icons.person_outline,
                  size: 18,
                  color: Colors.grey,
                ),

                const SizedBox(width: 8),

                Text(
                  supervisor.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),

          /// نوع العمل
          Expanded(
            flex: 2,
            child: Align(
              alignment: Alignment.centerRight,

              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 4,
                ),

                decoration: BoxDecoration(
                  color: isSweeping
                      ? const Color(0xffDBEAFE)
                      : const Color(0xffDCFCE7),

                  borderRadius: BorderRadius.circular(20),
                ),

                child: Text(
                  isSweeping ? "كنس" : "رفع",

                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: isSweeping
                        ? const Color(0xff2563EB)
                        : const Color(0xff16A34A),
                  ),
                ),
              ),
            ),
          ),

          /// المربع
          Expanded(
            flex: 4,
            child: Row(
              children: [

                const Icon(
                  Icons.location_on_outlined,
                  size: 18,
                  color: Colors.grey,
                ),

                const SizedBox(width: 6),

                Text(
                  supervisor.squareName,
                  style: const TextStyle(
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),

          /// جدول العمل
          Expanded(
            flex: 3,
            child: Row(
              children: [

                const Icon(
                  Icons.access_time,
                  size: 18,
                  color: Colors.grey,
                ),

                const SizedBox(width: 6),

                Text(
                  supervisor.schedule == null || supervisor.schedule!.isEmpty
                      ? "-"
                      : supervisor.schedule!,
                  style: const TextStyle(
                    color: Colors.grey,
                  ),
                )
              ],
            ),
          ),

          /// زر التعديل
          SizedBox(
            width: 70,

            child: InkWell(

              onTap: () {

                showDialog(
                  context: context,
                  builder: (_) => EditSupervisorDialog(
                    supervisor: supervisor,
                    index: index,
                  ),
                );

              },

              child: const Row(
                children: [

                  Icon(
                    Icons.edit_outlined,
                    size: 18,
                  ),

                  SizedBox(width: 6),

                  Text(
                    "تعديل",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}