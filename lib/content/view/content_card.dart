import 'package:flutter/material.dart';
import 'content_model.dart';

class ContentCard extends StatefulWidget {
  final ContentModel content;
  final VoidCallback onDelete;
  final Function(ContentModel) onEdit;
  final VoidCallback onTogglePublish;


  const ContentCard({
    super.key,
    required this.content,
    required this.onDelete,
    required this.onEdit,
    required this.onTogglePublish,
  });

  @override
  State<ContentCard> createState() => _ContentCardState();
}

class _ContentCardState extends State<ContentCard> {

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: widget.content.isPublished
            ? const Color(0xffeefcf3)
            : Colors.grey.shade100,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: widget.content.isPublished
              ? Colors.green.shade300
              : Colors.grey.shade300,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          /// الصف العلوي
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [

              Row(
                children: [

                  /// أيقونة حسب النوع
                  Icon(
                    widget.content.type == ContentType.news
                        ? Icons.article_outlined
                        : Icons.lightbulb_outline,
                    color: widget.content.type == ContentType.news
                        ? Colors.purple
                        : Colors.orange,
                  ),

                  const SizedBox(width: 8),


                  /// حالة النشر
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: widget.content.isPublished
                          ? Colors.green.shade100
                          : Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      widget.content.isPublished ? 'منشور' : 'مسودة',
                      style: TextStyle(
                        fontSize: 12,
                        color: widget.content.isPublished
                            ? Colors.green
                            : Colors.black54,
                      ),
                    ),
                  ),
                ],
              ),

              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () => _showEditDialog(context),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: widget.onDelete,
                  ),
                  ElevatedButton(
                    onPressed: widget.onTogglePublish,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: widget.content.isPublished
                          ? Colors.red.shade100
                          : Colors.green.shade100,
                      foregroundColor: widget.content.isPublished
                          ? Colors.red
                          : Colors.green,
                      elevation: 0,
                    ),
                    child: Text(
                      widget.content.isPublished
                          ? 'إلغاء النشر'
                          : 'نشر',
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 16),

          /// العنوان
          Text(
            widget.content.title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 8),

          /// النص
          Text(
            widget.content.description,
            style: const TextStyle(
              color: Colors.black87,
              height: 1.6,
            ),
          ),

          const SizedBox(height: 12),

          /// التاريخ
          Row(
            children: [
              const Icon(Icons.calendar_today,
                  size: 14, color: Colors.grey),
              const SizedBox(width: 6),
              Text(
                "${widget.content.date.year}-${widget.content.date.month}-${widget.content.date.day}",
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),



          /// اسم الناشر
          Row(
            children: [
              const Icon(Icons.person_outline,
                  size: 16, color: Colors.grey),
              const SizedBox(width: 6),
              Text(
                "كتب بواسطة: ${widget.content.authorName}",
                style: const TextStyle(
                  fontSize: 13,
                  color: Colors.grey,
                ),
              ),
            ],
          ),

        ],
      ),
    );
  }

  /// ================= تعديل =================

  void _showEditDialog(BuildContext context) {
    final titleController =
    TextEditingController(text: widget.content.title);
    final descController =
    TextEditingController(text: widget.content.description);

    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: const Text('تعديل المحتوى'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration:
                const InputDecoration(labelText: 'العنوان'),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: descController,
                decoration:
                const InputDecoration(labelText: 'الوصف'),
              ),
            ],
          ),

          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('إلغاء'),
            ),
            ElevatedButton(
              onPressed: () {
                final updated = widget.content.copyWith(
                  title: titleController.text,
                  description: descController.text,
                );

                widget.onEdit(updated);
                Navigator.pop(context);
              },
              child: const Text('حفظ'),
            ),
          ],
        );
      },
    );
  }
}
