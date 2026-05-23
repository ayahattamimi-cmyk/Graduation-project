import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../data/models/content_model.dart';
import '../viewmodel/content_viewmodel.dart';
import 'widgets/content_card.dart';
import 'widgets/add_content_dialog.dart';

class ContentPage extends StatefulWidget {
  const ContentPage({super.key});

  @override
  State<ContentPage> createState() => _ContentPageState();
}

class _ContentPageState extends State<ContentPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (mounted) {
        context.read<NewsTipsViewModel>().loadData();
      }
    });
  }

  // دالة مساعدة لإظهار رسالة
  void _showMessage(String msg) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<NewsTipsViewModel>();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'إدارة الأخبار والنصائح',
            style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            'نشر محتوى توعوي للمواطنين',
            style: TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 24),

          /// زر الإضافة
          ElevatedButton.icon(
            onPressed: () async {
              final result = await showDialog<ContentModel>(
                context: context,
                builder: (_) => const AddContentDialog(),
              );
              if (result != null && mounted) {
                await vm.addContent(result);
                _showMessage("تمت الإضافة بنجاح");
              }
            },
            icon: const Icon(Icons.person_add, color: Colors.white),
            label: const Text(
              "إضافة محتوى جديد",
              style: TextStyle(color: Colors.white),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xff2563EB),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 0,
            ),
          ),

          const SizedBox(height: 30),

          /// بطاقات الإحصائيات
          Row(
            children: [
              _statCard(
                'النصائح',
                vm.tipsCount.toString(),
                Icons.lightbulb_outline,
                Colors.orange,
              ),
              const SizedBox(width: 16),
              _statCard(
                'الأخبار',
                vm.newsCount.toString(),
                Icons.article_outlined,
                Colors.purple,
              ),
              const SizedBox(width: 16),
              _statCard(
                'إجمالي المحتوى',
                vm.totalCount.toString(),
                Icons.library_books_outlined,
                Colors.blue,
              ),
            ],
          ),

          const SizedBox(height: 40),

          const Text(
            'المحتوى المنشور والمسودات',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 20),

          if (vm.isLoading)
            const Center(child: CircularProgressIndicator())
          else if (vm.contents.isEmpty)
            const Center(child: Text("لا يوجد محتوى حالياً"))
          else
            ...vm.contents.map(
              (item) => ContentCard(
                content: item,
                onDelete: () async {
                  await vm.deleteContent(item.id!);
                  _showMessage("تم الحذف بنجاح");
                },
                onEdit: (updated) async {
                  await vm.editContent(updated);
                  _showMessage("تم التعديل بنجاح");
                },
                onTogglePublish: () async {
                  await vm.togglePublish(item.id!);
                  _showMessage("تم تغيير حالة النشر");
                },
              ),
            ),
        ],
      ),
    );
  }

  Widget _statCard(String title, String value, IconData icon, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Row(
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
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
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
