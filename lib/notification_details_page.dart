import 'package:flutter/material.dart';

class NotificationDetailsPage extends StatelessWidget {
  final String id;
  final String category;
  final String priority;
  final String days;
  final String status;
  final String imageUrl;

  const NotificationDetailsPage({
    super.key,
    required this.id,
    required this.category,
    required this.priority,
    required this.days,
    required this.status,
    required this.imageUrl,
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
              // العنوان والزر
              Row(
                textDirection: TextDirection.rtl,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // زر الرجوع
                  OutlinedButton.icon(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back),
                    label: const Text('رجوع'),
                  ),

                  const SizedBox(width: 16),

                  // العنوان
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            'تفاصيل البلاغ $id',
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
                            style: TextStyle(color: Colors.grey),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(width: 16),


                  ElevatedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.swap_horiz),
                    label: const Text('توجيه البلاغ'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ],
              ),


              const SizedBox(height: 24),


              Row( ///هنا قسمت الصفحة يمين ويسار
              crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
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


                  SizedBox(
                    width: 320,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _quickSummaryCard(),
                        const SizedBox(height: 16),
                        _reporterInfoCard(),
                        if (status == 'قيد المعالجة') ...[
                          const SizedBox(height: 16),
                          _assignedSupervisorCard(context),
                        ],
                        const SizedBox(height: 16),
                        _timeCard(),
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

 //الكروت الي ع جنب

  Widget _quickSummaryCard() {
    return _card(
      title: 'ملخص سريع',
      child: Column(
        children: [
          _rowItem('النوع', category),
          _rowItem('الأولوية', priority),
          _rowItem('الحالة', status),
        ],
      ),
    );
  }

  Widget _reporterInfoCard() {
    return _card(
      title: 'بيانات المبلّغ',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: const [
          Text('الاسم', style: TextStyle(color: Colors.grey)),
          SizedBox(height: 4),
          Text(
            'فهد سليمان المطيري',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 12),
          Text('رقم الجوال', style: TextStyle(color: Colors.grey)),
          SizedBox(height: 4),
          Text(
            '0551234567',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _assignedSupervisorCard(BuildContext context) {
    return _card(
      title: 'المشرف المعيَّن',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _rowItem('اسم المشرف', 'محمد عبدالله'),
          _rowItem('المنطقة', 'مربع 2 – المنطقة الصناعية'),
          const SizedBox(height: 12),
          ElevatedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.swap_horiz),
            label: const Text('إعادة توجيه لمشرف آخر'),
          ),
        ],
      ),
    );
  }

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

  Widget _reportInfoCard() {
    return _card(
      title: 'معلومات البلاغ',
      child: Column(
        children: [
          _rowItem('رقم البلاغ', id),
          _rowItem('نوع العمل', 'كنس'),
          _rowItem('الحالة', status),
          const Divider(),
          const Align(
            alignment: Alignment.centerRight,
            child: Text('الوصف', style: TextStyle(fontWeight: FontWeight.bold)),
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

  Widget _locationCard() {
    return _card(
      title: 'موقع البلاغ',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text('المربع الجغرافي', style: TextStyle(color: Colors.grey)),
          SizedBox(height: 4),
          Text('مربع 1 – السوق العام', style: TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(height: 12),
          Text('العنوان التفصيلي', style: TextStyle(color: Colors.grey)),
          SizedBox(height: 6),
          Text(
            'جولة البخاري بالقرب من محطة السوق العام',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _imageCard() {
    return _card(
      title: 'صورة البلاغ من المواطن',
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.network(
          imageUrl,
          height: 260,
          width: double.infinity,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  //   أدوات جاهزة تختصر علينا عشان م يكون ف تكرار

  Widget _card({required String title, required Widget child}) {// استخدمنا required Widget child عشان نقدر نحط داخل الكرت اي وديجت نبغاه رو والا كولم
    return Container(//ف الفلاتر يسمى Composition
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(//محنوى الكرت
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }

  Widget _rowItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
