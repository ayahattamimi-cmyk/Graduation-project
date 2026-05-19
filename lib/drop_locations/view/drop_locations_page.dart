import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:web2/drop_locations/data/container_model.dart';
import 'package:web2/drop_locations/viewmodel/drop_locations_viewmodel.dart';
import 'widgets/area_card.dart';
import 'widgets/drop_locations_header.dart';

class DropLocationsPage extends StatefulWidget {
  final Function(AppPage) onPageSelected;
  const DropLocationsPage({super.key,required this.onPageSelected,});

  @override
  State<DropLocationsPage> createState() => _DropLocationsPageState();
}

class _DropLocationsPageState extends State<DropLocationsPage> {
  @override
  void initState() {
    super.initState();
    // --- (تعديل) طلب جلب البيانات من السيرفر فور فتح الصفحة ---
    Future.microtask(
      () => context.read<DropLocationsViewModel>().fetchContainersData(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<DropLocationsViewModel>();
    return Scaffold(
      body:
          viewModel.isLoading
              ? const Center(
                child: CircularProgressIndicator(),
              ) // عرض مؤشر تحميل
              : ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  /// زر الإضافة
                  DropLocationsHeader(
                    onAdd: (data) {
                      final newContainer = ContainerModel(
                        nameContainer: data["name"],
                        areaDetails:
                            data["area"], // المربع المختار من القائمة المنسدلة
                        type: data["type"],
                        period: data["period"],
                        classification: data["classification"],
                        // إضافة قيم افتراضية للحقول التي لم يطلبها الدايالوج بعد
                        nameStreet: "شارع عام",
                        collectionFrequency: 1,
                        collectionDay: "daily",
                        startTime: "08:00:00",
                      );

                      // استدعاء دالة الإضافة في الـ ViewModel
                      context.read<DropLocationsViewModel>().addContainer(
                        newContainer,
                      );
                    },
                  ),

                  const SizedBox(height: 20),

                  if (viewModel.areas.isEmpty)
                    const Center(child: Text("لا توجد مواقع رفع مضافة حالياً"))
                  else
                    ...viewModel.areas.map((area) => AreaCard(area: area)),
                ],
              ),
    );
  }
}
