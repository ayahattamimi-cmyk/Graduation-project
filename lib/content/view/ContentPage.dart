import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../data/models/content_model.dart';
import '../viewmodel/content_viewmodel.dart';
import 'widgets/content_card.dart';
import 'widgets/add_content_dialog.dart';
import 'package:web2/dashboard/view/widgets/stat_card.dart';

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
            'نشر محتوى توعوي للمواطنين عبر تجميع المحتوى في أقسام واضحة',
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
            icon: const Icon(Icons.add_to_photos, color: Colors.white),
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
              Expanded(
                child: StatCard(
                  title: 'النصائح',
                  value: vm.tipsCount.toString(),
                  subtitle: "نصائح توعوية للمواطنين",
                  icon: Icons.lightbulb_outline,
                  color: Colors.orange,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: StatCard(
                  title: 'الأخبار',
                  value: vm.newsCount.toString(),
                  subtitle: "آخر الأخبار والمستجدات",
                  icon: Icons.article_outlined,
                  color: Colors.purple,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: StatCard(
                  title: 'إجمالي المحتوى',
                  value: vm.totalCount.toString(),
                  subtitle: "جميع المنشورات",
                  icon: Icons.library_books_outlined,
                  color: Colors.blue,
                ),
              ),
            ],
          ),

          const SizedBox(height: 40),

          if (vm.isLoading)
            const Center(child: CircularProgressIndicator())
          else if (vm.contents.isEmpty)
            const Center(child: Text("لا يوجد محتوى حالياً"))
          else ...[
            // قسم الأخبار
            _buildContentSection(
              title: " الأخبار  ",
              items:
                  vm.contents.where((c) => c.type == ContentType.news).toList(),
              color: Colors.purple,
              vm: vm,
            ),

            const SizedBox(height: 20),

            // قسم النصائح
            _buildContentSection(
              title: " النصائح والإرشادات التوعوية",
              items:
                  vm.contents.where((c) => c.type == ContentType.tips).toList(),
              color: Colors.orange,
              vm: vm,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildContentSection({
    required String title,
    required List<ContentModel> items,
    required Color color,
    required NewsTipsViewModel vm,
  }) {
    if (items.isEmpty) return const SizedBox();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Row(
            children: [
              Container(width: 4, height: 24, color: color),
              const SizedBox(width: 12),
              Text(
                "$title (${items.length})",
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        ...items.map(
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
              await vm.togglePublish(item.id!, item.isPublished);
              _showMessage("تم تغيير حالة النشر");
            },
          ),
        ),
      ],
    );
  }
}
