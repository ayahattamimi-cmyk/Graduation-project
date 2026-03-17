import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import ' widgets/supervisor_row.dart';
import '../viewmodel/supervisor_viewmodel.dart';
import 'dialogs/add_supervisor_dialog.dart';

class SupervisorPage extends StatefulWidget {
 const SupervisorPage({super.key});

 @override
 State<SupervisorPage> createState() => _SupervisorPageState();
}

class _SupervisorPageState extends State<SupervisorPage> {

 @override
 void initState() {
  super.initState();
  Future.microtask(() =>
      context.read<SupervisorViewModel>().loadSupervisors());
 }

 @override
 Widget build(BuildContext context) {

  final vm = context.watch<SupervisorViewModel>();

  return Padding(
   padding: const EdgeInsets.all(24),

   child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [

     /// العنوان + زر الإضافة
     Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [

       const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

         Text(
          "إدارة المشرفين",
          style: TextStyle(
           fontSize: 26,
           fontWeight: FontWeight.bold,
          ),
         ),

         SizedBox(height: 4),

         Text(
          "عرض وإدارة بيانات جميع المشرفين",
          style: TextStyle(color: Colors.grey),
         ),
        ],
       ),

       ElevatedButton.icon(
        onPressed: () {
         showDialog(
          context: context,
          builder: (_) => const AddSupervisorDialog(),
         );
        },

        icon: const Icon(
         Icons.person_add,
         color: Colors.white,
        ),

        label: const Text(
         "إضافة مشرف جديد",
         style: TextStyle(color: Colors.white),
        ),

        style: ElevatedButton.styleFrom(
         backgroundColor: const Color(0xff2563EB),
         padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 14,
         ),
         shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
         ),
         elevation: 0,
        ),
       )
      ],
     ),

     const SizedBox(height: 25),

     /// الإحصائيات
     Row(
      children: [

       stat(
        "مشرفي الرفع",
        vm.liftingCount.toString(),
        Colors.orange,
       ),

       const SizedBox(width: 15),

       stat(
        "مشرفي الكنس",
        vm.sweepingCount.toString(),
        Colors.green,
       ),

       const SizedBox(width: 15),

       stat(
        "إجمالي المشرفين",
        vm.supervisors.length.toString(),
        Colors.blue,
       ),
      ],
     ),

     const SizedBox(height: 30),

     /// الفلتر
     Container(
      height: 36,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
       color: Colors.white,
       borderRadius: BorderRadius.circular(8),
       border: Border.all(color: Colors.grey.shade300),
      ),

      child: DropdownButton<String>(
       value: vm.filter,
       underline: const SizedBox(),
       icon: const Icon(Icons.keyboard_arrow_down, size: 18),

       style: const TextStyle(
        fontSize: 13,
        color: Colors.black,
       ),

       items: const [

        DropdownMenuItem(
         value: "all",
         child: Text("جميع المشرفين"),
        ),

        DropdownMenuItem(
         value: "sweeping",
         child: Text("مشرفي الكنس فقط"),
        ),

        DropdownMenuItem(
         value: "lifting",
         child: Text("مشرفي الرفع فقط"),
        ),
       ],

       onChanged: (value) {
        vm.changeFilter(value!);
       },
      ),
     ),

     const SizedBox(height: 20),

     /// الجدول
     Expanded(
      child: Container(
       decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xffE5E7EB)),
       ),

       child: Column(
        children: [

         /// Header
         Container(
          padding: const EdgeInsets.symmetric(
           horizontal: 20,
           vertical: 14,
          ),

          decoration: const BoxDecoration(
           border: Border(
            bottom: BorderSide(
             color: Color(0xffE5E7EB),
            ),
           ),
          ),

          child: const Row(
           children: [

            Expanded(
             flex: 4,
             child: Text(
              "الاسم",
              style: TextStyle(
               fontWeight: FontWeight.bold,
               color: Colors.grey,
              ),
             ),
            ),

            Expanded(
             flex: 2,
             child: Text(
              "نوع العمل",
              style: TextStyle(
               fontWeight: FontWeight.bold,
               color: Colors.grey,
              ),
             ),
            ),

            Expanded(
             flex: 4,
             child: Text(
              "المربع",
              style: TextStyle(
               fontWeight: FontWeight.bold,
               color: Colors.grey,
              ),
             ),
            ),

            Expanded(
             flex: 3,
             child: Text(
              "جدولة العمل",
              style: TextStyle(
               fontWeight: FontWeight.bold,
               color: Colors.grey,
              ),
             ),
            ),

            SizedBox(width: 70),

           ],
          ),
         ),

         /// rows
         Expanded(
          child: ListView.builder(
           itemCount: vm.filtered.length,
           itemBuilder: (_, i) {

            return SupervisorRow(
             supervisor: vm.filtered[i],
             index: i,
            );

           },
          ),
         ),
        ],
       ),
      ),
     )
    ],
   ),
  );
 }

 Widget stat(String title,String value,Color color){

  return Expanded(
   child: Container(

    padding: const EdgeInsets.all(20),

    decoration: BoxDecoration(
     borderRadius: BorderRadius.circular(15),
     border: Border.all(color: Colors.grey.shade200),
    ),

    child: Column(
     children: [

      Text(title),

      const SizedBox(height: 6),

      Text(
       value,
       style: TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.bold,
        color: color,
       ),
      )
     ],
    ),
   ),
  );
 }
}