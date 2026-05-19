import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../dashboard/view/sidebar.dart';
import '../../dashboard/viewmodel/dashboard_viewmodel.dart';
import '../viewmodel/assignment_viewmodel.dart';


class ReportAssignmentPage extends StatelessWidget {
  final Function(AppPage) onPageSelected;

  const ReportAssignmentPage({super.key,required this.onPageSelected,});


  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AssignmentViewModel(),
      child: Consumer<AssignmentViewModel>(
        builder: (context, vm, _) {

          return ListView(
            padding: const EdgeInsets.all(20),
            children: [

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
                      onPageSelected(AppPage.map);
                    },

                    icon: const Icon(
                      Icons.map_outlined,
                      color: Colors.white,
                    ),

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
                          "نموذج توجيه البلاغ",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      /// المربع
                      const Text("المربع الجغرافي"),
                      const SizedBox(height: 6),

                      DropdownButtonFormField(
                        value: vm.selectedArea,
                        dropdownColor: Colors.white,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.grey.shade200,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 14,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        items: vm.areas
                            .map((e)=>DropdownMenuItem(
                          value: e,
                          child: Text(e),
                        )).toList(),
                        onChanged: (v)=>vm.setArea(v!),
                      ),

                      const SizedBox(height: 16),

                      /// نوع العمل
                      const Text("نوع العمل"),
                      const SizedBox(height: 6),

                      DropdownButtonFormField(
                        value: vm.selectedWorkType,
                        dropdownColor: Colors.white,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.grey.shade200,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 14,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        items: vm.workTypes
                            .map((e)=>DropdownMenuItem(
                          value: e,
                          child: Text(e),
                        )).toList(),
                        onChanged: (v)=>vm.setWorkType(v!),
                      ),

                      /// كرت المشرف
                      if(vm.supervisorName.isNotEmpty)
                        Container(
                          margin: const EdgeInsets.only(top: 20),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: const Color(0xffE8F0FE),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.person,color: Colors.blue),
                              const SizedBox(width: 10),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text("المشرف المسؤول",
                                      style: TextStyle(color: Colors.grey)),
                                  Text(vm.supervisorName,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold))
                                ],
                              )
                            ],
                          ),
                        ),

                      /// كرت تفاصيل المربع
                      Container(
                        margin: const EdgeInsets.only(top: 16),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [

                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text("المربع:"),
                                Text(vm.selectedArea.split("-")[0].trim()),
                              ],
                            ),

                            const SizedBox(height: 8),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text("المنطقة:"),
                                Text(vm.selectedArea.split("-")[1].trim()),
                              ],
                            ),

                            const SizedBox(height: 8),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text("عدد البلاغات:"),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10,vertical: 4),
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
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),

                      /// زر تعيين
                      SizedBox(

                        width: double.infinity,
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue

          ),
                          onPressed: (){
                            final result = vm.assignReport();

                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  "تم تعيين البلاغ إلى ${result.supervisorName}",
                                ),
                              ),
                            );
                          },
                          icon: const Icon(Icons.check,color: Colors.white,),
                          label: const Text("تعيين البلاغ",style: TextStyle(fontSize: 14,color: Colors.white),),
                        ),
                      ),

                      const SizedBox(height: 12),




                    ],
                  ),
                ),
              )
            ],
          );
        },
      ),
    );
  }
}