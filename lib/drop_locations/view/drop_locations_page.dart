import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:web2/dashboard/view/widgets/sidebar.dart';

import 'package:web2/drop_locations/data/container_model.dart';
import 'package:web2/drop_locations/viewmodel/drop_locations_viewmodel.dart';
import 'widgets/area_card.dart';
import 'widgets/drop_locations_header.dart';

class DropLocationsPage extends StatefulWidget {
  final Function(AppPage) onPageSelected;
  const DropLocationsPage({super.key, required this.onPageSelected});

  @override
  State<DropLocationsPage> createState() => _DropLocationsPageState();
}

class _DropLocationsPageState extends State<DropLocationsPage> {
  @override
  void initState() {
    super.initState();
    // طلب جلب البيانات من السيرفر فور فتح الصفحة
    Future.microtask(
      () => context.read<DropLocationsViewModel>().fetchContainersData(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<DropLocationsViewModel>();

    // استماع للأخطاء وعرضها
    if (viewModel.errorMessage != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(viewModel.errorMessage!),
            backgroundColor: Colors.red,
          ),
        );
      });
    }

    return Scaffold(
      backgroundColor: const Color(0xfff6f8fb), // متناسق مع لوحة التحكم
      body:
          viewModel.isLoading
              ? const Center(
                child: CircularProgressIndicator(),
              ) // عرض مؤشر تحميل
              : ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  /// زر الإضافة والقائمة العلوية
                  DropLocationsHeader(
                    onPageSelected: widget.onPageSelected,
                    onAdd: (data) {
                      final newContainer = ContainerModel(
                        locationName: data["location_name"],
                        nameStreet: data["name_street"],
                        type: data["type"],
                        period: data["period"],
                        classification: data["classification"],
                        areaId: data["area_id"],
                        areaDetails: data["area_details"],
                        lat: data["lat"],
                        lng: data["lng"],
                        collectionFrequency: data["collection_frequency"],
                        collectionDay: data["collection_day"],
                        startTime: data["start_time"],
                      );

                      // استدعاء دالة الإضافة في الـ ViewModel
                      context.read<DropLocationsViewModel>().addContainer(
                        newContainer,
                      );
                    },
                  ),

                  const SizedBox(height: 20),

                  /// عرض المربعات الجغرافية/المناطق
                  if (viewModel.areas.isEmpty)
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.only(top: 40),
                        child: Text("لا توجد مواقع رفع مضافة حالياً"),
                      ),
                    )
                  else
                    ...viewModel.areas.map(
                      (area) => AreaCard(
                        area: area,
                        onPageSelected:
                            widget
                                .onPageSelected, // تم تمريرها هنا بأمان داخل الليست
                      ),
                    ),
                ],
              ),
    );
  }
}
