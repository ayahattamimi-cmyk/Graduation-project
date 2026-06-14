import 'package:flutter/material.dart';
import '../../data/models/report_details_model.dart';
import 'detail_card.dart';

/// بطاقة تعرض معلومات البلاغ الأساسية (الرقم، النوع، الحالة، الوصف).
class ReportInfoCard extends StatelessWidget {
  final ReportDetailsModel report;

  const ReportInfoCard({super.key, required this.report});

  @override
  Widget build(BuildContext context) {
    return DetailCard(
      title: 'معلومات البلاغ',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DetailRowItem(label: 'رقم البلاغ', value: report.reportNumber.toString()),
          DetailRowItem(label: 'نوع العمل', value: report.type),
          DetailRowItem(label: 'الحالة', value: report.status),
          const Divider(),
          const Text('الوصف', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 6),
          Text(
            report.description.isNotEmpty
                ? report.description
                : 'لا يوجد وصف مضاف من قبل المواطن.',
            style: const TextStyle(height: 1.4),
          ),
        ],
      ),
    );
  }
}

/// بطاقة تعرض الموقع الجغرافي (المربع والمنطقة) لبلاغ.
class LocationCard extends StatelessWidget {
  final ReportDetailsModel report;

  const LocationCard({super.key, required this.report});

  @override
  Widget build(BuildContext context) {
    return DetailCard(
      title: 'موقع البلاغ',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DetailRowItem(label: 'المربع الجغرافي', value: report.square),
          DetailRowItem(label: 'المنطقة', value: report.area),
        ],
      ),
    );
  }
}

/// بطاقة تعرض صورة البلاغ الأصلية.
class ReportImageCard extends StatelessWidget {
  final String imageUrl;

  const ReportImageCard({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return DetailCard(
      title: 'صورة البلاغ الأصلية',
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child:
            imageUrl.isNotEmpty
                ? Image.network(
                  imageUrl,
                  height: 250,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder:
                      (context, error, stackTrace) => const Center(
                        child: Padding(
                          padding: EdgeInsets.all(20.0),
                          child: Icon(
                            Icons.broken_image,
                            size: 50,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                )
                : const Center(
                  child: Padding(
                    padding: EdgeInsets.all(40.0),
                    child: Column(
                      children: [
                        Icon(
                          Icons.image_not_supported_outlined,
                          size: 50,
                          color: Colors.grey,
                        ),
                        SizedBox(height: 10),
                        Text(
                          "لا توجد صورة متوفرة لهذا البلاغ",
                          style: TextStyle(color: Color(0xFF616161)),
                        ),
                      ],
                    ),
                  ),
                ),
      ),
    );
  }
}
