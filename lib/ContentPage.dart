import 'package:flutter/material.dart';
import '../models/content_model.dart';
import '../widgets/content_card.dart';
import '../add_content_dialog.dart';
import '../content_service.dart';

class ContentPage extends StatefulWidget {
  const ContentPage({super.key});

  @override
  State<ContentPage> createState() => _ContentPageState();
}

class _ContentPageState extends State<ContentPage> {
  final ContentService _service = ContentService();
  List<ContentModel> contents = [];

  @override
  void initState() {
    super.initState();
    _loadContents();
  }

  Future<void> _loadContents() async {
    final data = await _service.fetchContents();
    setState(() {
      contents = data;
    });
  }

  Future<void> _addContent(ContentModel newContent) async {
    await _service.addContent(newContent);
    _loadContents();
  }

  Future<void> _deleteContent(String id) async {
    await _service.deleteContent(id);
    _loadContents();
  }

  Future<void> _editContent(ContentModel updated) async {
    await _service.updateContent(updated);
    _loadContents();
  }

  Future<void> _togglePublish(ContentModel content) async {
    await _service.togglePublish(content);
    _loadContents();
  }

  @override
  Widget build(BuildContext context) {
    final tipsCount =
        contents.where((e) => e.type == ContentType.tip).length;
    final newsCount =
        contents.where((e) => e.type == ContentType.news).length;
    final publishedCount =
        contents.where((e) => e.isPublished).length;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          /// العنوان
          const Text(
            'إدارة الأخبار والنصائح',
            style:
            TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 8),

          const Text(
            'نشر محتوى توعوي للمواطنين',
            style: TextStyle(color: Colors.grey),
          ),

          const SizedBox(height: 24),

          /// زر الإضافة
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(
                  horizontal: 20, vertical: 14),
            ),
            onPressed: () async {
              final result = await showDialog<ContentModel>(
                context: context,
                builder: (_) => const AddContentDialog(),
              );

              if (result != null) {
                _addContent(result);
              }
            },
            icon: const Icon(Icons.add),
            label: const Text('إضافة محتوى جديد'),
          ),

          const SizedBox(height: 30),

          /// بطاقات الإحصائيات
          Row(
            children: [
              _statCard(
                'النصائح',
                tipsCount.toString(),
                Icons.lightbulb_outline,
                Colors.orange,
              ),
              const SizedBox(width: 16),
              _statCard(
                'الأخبار',
                newsCount.toString(),
                Icons.article_outlined,
                Colors.purple,
              ),
              const SizedBox(width: 16),
              _statCard(
                'منشور',
                publishedCount.toString(),
                Icons.remove_red_eye_outlined,
                Colors.green,
              ),
              const SizedBox(width: 16),
              _statCard(
                'إجمالي المحتوى',
                contents.length.toString(),
                Icons.library_books_outlined,
                Colors.blue,
              ),
            ],
          ),

          const SizedBox(height: 40),

          const Text(
            'المحتوى المنشور والمسودات',
            style:
            TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 20),

          ...contents.map(
                (item) => ContentCard(
              content: item,
              onDelete: () => _deleteContent(item.id),
              onEdit: (updated) => _editContent(updated),
              onTogglePublish: () => _togglePublish(item),
            ),
          ),
        ],
      ),
    );
  }

  Widget _statCard(
      String title, String value, IconData icon, Color color) {
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
              crossAxisAlignment:
              CrossAxisAlignment.start,
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
