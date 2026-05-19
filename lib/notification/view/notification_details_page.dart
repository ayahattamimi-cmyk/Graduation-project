import 'package:flutter/material.dart';

import '../../dashboard/view/sidebar.dart';

class NotificationDetailsPage extends StatefulWidget {
  final String id;
  final String category;
  final String priority;
  final String days;
  final String status;
  final String imageUrl;
  final Function(AppPage)? onGoToAssignment;

  const NotificationDetailsPage({
    super.key,
    required this.id,
    required this.category,
    required this.priority,
    required this.days,
    required this.status,
    required this.imageUrl,
    required this.onGoToAssignment,
  });

  @override
  Widget build(BuildContext context) {

    return Directionality(
      textDirection: TextDirection.rtl,

      child: Scaffold(
        backgroundColor: const Color(0xfff6f8fb),

        body: SingleChildScrollView(
          padding: const EdgeInsets.all(24),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [

              /// العنوان
              Row(
                textDirection: TextDirection.ltr,
                crossAxisAlignment: CrossAxisAlignment.center,

                children: [

                  /// زر الرجوع
                  OutlinedButton(
                    onPressed: () => Navigator.pop(context),

                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xff2563EB),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 18,
                        vertical: 14,
                      ),
                    ),

                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [

                        Text(
                          'رجوع',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        SizedBox(width: 8),

                        Icon(Icons.arrow_forward,color: Colors.white,),
                      ],
                    ),
                  ),

                  const SizedBox(width: 16),

                  /// العنوان
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,

                      children: [

                        Align(
                          alignment: Alignment.centerRight,

                          child: Text(
                            'تفاصيل البلاغ ${widget.id}',
                            textAlign: TextAlign.right,

                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),

                        const SizedBox(height: 4),

                        const Align(
                          alignment: Alignment.centerRight,

                          child: Text(
                            'تجمع نفايات في جولة البخاري',
                            textAlign: TextAlign.right,

                            style: TextStyle(
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              /// تقسيم الصفحة
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [

                  /// اليسار
                  Expanded(
                    child: Column(
                      crossAxisAlignment:
                      CrossAxisAlignment.stretch,

                      children: [

                        _reportInfoCard(),

                        const SizedBox(height: 16),

                        _locationCard(),

                        const SizedBox(height: 16),

                        _imageCard(),
                      ],
                    ),
                  ),

                  const SizedBox(width: 24),

                  /// اليمين
                  SizedBox(
                    width: 320,

                    child: Column(
                      crossAxisAlignment:
                      CrossAxisAlignment.stretch,

                      children: [

                        _quickSummaryCard(),

                        const SizedBox(height: 16),

                        _reporterInfoCard(),

                        if (status == 'قيد المعالجة' ||
                            status == 'مكتمل') ...[
                          const SizedBox(height: 16),

                          _assignedSupervisorCard(context),
                        ],

                        const SizedBox(height: 16),

                        _timeCard(),

                        /// زر توجيه البلاغ
                        if (status == 'جديد' || status == 'ملغي') ...[

                          const SizedBox(height: 16),

                          ElevatedButton.icon(

                            onPressed: () {
                              widget.onGoToAssignment
                                  ?.call(AppPage.assignReports);
                            },

                            icon: const Icon(
                              Icons.swap_horiz,
                              color: Colors.white,
                            ),

                            label: const Text(
                              'توجيه البلاغ',

                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                              const Color(0xff2563EB),

                              foregroundColor: Colors.white,

                              padding:
                              const EdgeInsets.symmetric(
                                vertical: 18,
                              ),

                              shape: RoundedRectangleBorder(
                                borderRadius:
                                BorderRadius.circular(14),
                              ),
                            ),
                          ),

                          /// زر الإلغاء
                          const SizedBox(height: 12),

                          SizedBox(
                            width: double.infinity,

                            child: ElevatedButton.icon(

                              onPressed: status == 'ملغي'
                                  ? null
                                  : () {

                                final reasonController = TextEditingController();

                                showDialog(
                                  context: context,

                                  builder: (_) {

                                    return Dialog(

                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      ),

                                      child: Container(
                                        width: 450,
                                        padding: const EdgeInsets.all(24),

                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment: CrossAxisAlignment.start,

                                          children: [

                                            const Row(
                                              children: [

                                                Icon(
                                                  Icons.cancel_outlined,
                                                  color: Colors.red,
                                                ),

                                                SizedBox(width: 10),

                                                Text(
                                                  'إلغاء البلاغ',
                                                  style: TextStyle(
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ],
                                            ),

                                            const SizedBox(height: 10),

                                            const Text(
                                              'قم بكتابة سبب إلغاء البلاغ ليتم إرساله للمواطن',
                                              style: TextStyle(
                                                color: Colors.grey,
                                              ),
                                            ),

                                            const SizedBox(height: 20),

                                            TextField(
                                              controller: reasonController,
                                              maxLines: 4,

                                              decoration: InputDecoration(
                                                hintText: 'اكتب سبب الإلغاء هنا...',

                                                filled: true,
                                                fillColor: const Color(0xfff5f7fb),

                                                border: OutlineInputBorder(
                                                  borderRadius: BorderRadius.circular(14),
                                                  borderSide: BorderSide.none,
                                                ),
                                              ),
                                            ),

                                            const SizedBox(height: 24),

                                            SizedBox(
                                              width: double.infinity,

                                              child: ElevatedButton(

                                                onPressed: () {

                                                  if (reasonController.text.trim().isEmpty) {
                                                    return;
                                                  }

                                                  Navigator.pop(context);

                                                  setState(() {
                                                    status = 'ملغي';
                                                  });

                                                  ScaffoldMessenger.of(context).showSnackBar(
                                                    const SnackBar(
                                                      content: Text(
                                                        'تم إلغاء البلاغ وإرسال السبب',
                                                      ),
                                                    ),
                                                  );
                                                },

                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor: Colors.red,
                                                  foregroundColor: Colors.white,
                                                  padding: const EdgeInsets.symmetric(
                                                    vertical: 15,
                                                  ),
                                                ),

                                                child: const Text('إرسال السبب'),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                );
                              },

                              icon: Icon(
                                status == 'ملغي'
                                    ? Icons.block
                                    : Icons.cancel_outlined,
                              ),

                              label: Text(
                                status == 'ملغي'
                                    ? 'تم الغاء البلاغ'
                                    : 'إلغاء البلاغ',

                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),

                              style: ElevatedButton.styleFrom(

                                backgroundColor:
                                status == 'ملغي'
                                    ? Colors.red.shade700
                                    : const Color(0xffFEE2E2),

                                foregroundColor:
                                status == 'ملغي'
                                    ? Colors.white
                                    : Colors.red,

                                padding: const EdgeInsets.symmetric(
                                  vertical: 17,
                                ),

                                elevation: 0,

                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                              ),
                            ),
                          )
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// ملخص سريع
  Widget _quickSummaryCard() {

    return _card(
      title: 'ملخص سريع',

      child: Column(
        children: [

          _rowItem('النوع', widget.category),

          _rowItem('الأولوية', widget.priority),

          _rowItem('الحالة', status),
        ],
      ),
    );
  }

  /// بيانات المبلغ
  Widget _reporterInfoCard() {
    final currentStatus = widget.status ?? report?.status;

    return _card(
      title: 'بيانات المبلّغ',

      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.stretch,

        children: const [

          Text(
            'الاسم',
            style: TextStyle(color: Colors.grey),
          ),

          SizedBox(height: 4),

          Text(
            'فهد سليمان المطيري',

            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),

          SizedBox(height: 12),

          Text(
            'رقم الجوال',
            style: TextStyle(color: Colors.grey),
          ),

          SizedBox(height: 4),

          Text(
            '0551234567',

            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  /// المشرف
  Widget _assignedSupervisorCard(BuildContext context) {

    return _card(
      title: status == 'مكتمل'
          ? 'المشرف الذي عالج البلاغ'
          : 'المشرف المعيَّن',

      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,

        children: [

          _rowItem(
            'اسم المشرف',
            'محمد عبدالله',
          ),

          _rowItem(
            'المنطقة',
            'مربع 2 – المنطقة الصناعية',
          ),

          if (currentStatus == 'قيد المعالجة') ...[

            const SizedBox(height: 12),

            SizedBox(
              width: double.infinity,

              child: ElevatedButton.icon(

                onPressed: () {
                  widget.onGoToAssignment
                      ?.call(AppPage.assignReports);
                },

                icon: const Icon(Icons.swap_horiz),

                label: const Text(
                  'إعادة توجيه لمشرف آخر',

                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),

                style: ElevatedButton.styleFrom(
                  backgroundColor:
                  const Color(0xff2563EB),

                  foregroundColor: Colors.white,

                  padding:
                  const EdgeInsets.symmetric(
                    vertical: 14,
                  ),

                  shape: RoundedRectangleBorder(
                    borderRadius:
                    BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  /// الوقت
  Widget _timeCard() {

    return _card(
      title: 'توقيت البلاغ',

      child: Column(
        children: const [

          ListTile(
            leading: Icon(Icons.calendar_today),
            title: Text('التاريخ'),
            trailing: Text('2025-12-01'),
          ),

          ListTile(
            leading: Icon(Icons.access_time),
            title: Text('الوقت'),
            trailing: Text('10:30'),
          ),
        ],
      ),
    );
  }

  /// معلومات البلاغ
  Widget _reportInfoCard() {

    return _card(
      title: 'معلومات البلاغ',

      child: Column(
        children: [

          _rowItem(
            'رقم البلاغ',
            widget.id,
          ),

          _rowItem(
            'نوع العمل',
            'كنس',
          ),

          _rowItem(
            'الحالة',
            status,
          ),

          const Divider(),

          const Align(
            alignment: Alignment.centerRight,

            child: Text(
              'الوصف',

              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          const SizedBox(height: 6),

          const Align(
            alignment: Alignment.centerRight,

            child: Text(
              'تجمع نفايات في جولة البخاري بالقرب من محطة السوق العام، يحتاج إلى تدخل عاجل.',
            ),
          ),
        ],
      ),
    );
  }

  /// الموقع
  Widget _locationCard() {

    return _card(
      title: 'موقع البلاغ',

      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,

        children: const [

          Text(
            'المربع الجغرافي',

            style: TextStyle(
              color: Colors.grey,
            ),
          ),

          SizedBox(height: 4),

          Text(
            'مربع 1 – السوق العام',

            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),

          SizedBox(height: 12),

          Text(
            'العنوان التفصيلي',

            style: TextStyle(
              color: Colors.grey,
            ),
          ),

          SizedBox(height: 6),

          Text(
            'جولة البخاري بالقرب من محطة السوق العام',

            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  /// الصورة
  Widget _imageCard() {

    return _card(
      title: 'صورة البلاغ من المواطن',

      child: ClipRRect(
        borderRadius:
        BorderRadius.circular(12),

        child: Image.network(
          widget.imageUrl,

          height: 260,
          width: double.infinity,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  /// كرت جاهز
  Widget _card({
    required String title,
    required Widget child,
  }) {

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius:
        BorderRadius.circular(14),

        border: Border.all(
          color: Colors.grey.shade200,
        ),
      ),

      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,

        children: [

          Text(
            title,

            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 12),

          child,
        ],
      ),
    );
  }

  /// عنصر صف
  Widget _rowItem(
      String label,
      String value,
      ) {

    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 6,
      ),

      child: Row(
        mainAxisAlignment:
        MainAxisAlignment.spaceBetween,

        children: [

          Text(
            label,

            style: const TextStyle(
              color: Colors.grey,
            ),
          ),

          Text(
            value,

            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}