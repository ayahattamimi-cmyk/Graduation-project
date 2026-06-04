import 'package:flutter/material.dart';
import 'package:web2/content/data/models/content_model.dart';
import 'dart:convert';
import 'dart:typed_data';
import 'package:image_picker/image_picker.dart';

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
        color:
            widget.content.isPublished
                ? const Color(0xffeefcf3)
                : Colors.grey.shade100,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color:
              widget.content.isPublished
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
                    color:
                        widget.content.type == ContentType.news
                            ? Colors.purple
                            : Colors.orange,
                  ),
                  const SizedBox(width: 8),

                  /// حالة النشر
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color:
                          widget.content.isPublished
                              ? Colors.green.shade100
                              : Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      widget.content.isPublished ? 'منشور' : 'مسودة',
                      style: TextStyle(
                        fontSize: 12,
                        color:
                            widget.content.isPublished
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
                      backgroundColor:
                          widget.content.isPublished
                              ? Colors.red.shade100
                              : Colors.green.shade100,
                      foregroundColor:
                          widget.content.isPublished
                              ? Colors.red
                              : Colors.green,
                      elevation: 0,
                    ),
                    child: Text(
                      widget.content.isPublished ? 'إلغاء النشر' : 'نشر',
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 16),

          /// المحتوى (نص + صورة) بتصميم حديث
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // النص
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.content.title,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1F2937),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      widget.content.content,
                      maxLines: 4,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.black87,
                        height: 1.6,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),

              // الصورة (إذا وجدت)
              if (widget.content.image != null &&
                  widget.content.image!.isNotEmpty) ...[
                const SizedBox(width: 20),
                Container(
                  width: 140,
                  height: 140,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child:
                        widget.content.image!.startsWith('http')
                            ? Image.network(
                              widget.content.image!,
                              fit: BoxFit.cover,
                              errorBuilder:
                                  (context, error, stackTrace) => Container(
                                    color: Colors.grey.shade200,
                                    child: const Icon(
                                      Icons.image_not_supported,
                                      color: Colors.grey,
                                    ),
                                  ),
                            )
                            : Image.memory(
                              base64Decode(widget.content.image!),
                              fit: BoxFit.cover,
                              errorBuilder:
                                  (context, error, stackTrace) => Container(
                                    color: Colors.grey.shade200,
                                    child: const Icon(
                                      Icons.image_not_supported,
                                      color: Colors.grey,
                                    ),
                                  ),
                            ),
                  ),
                ),
              ],
            ],
          ),

          const SizedBox(height: 20),
          const Divider(height: 1),
          const SizedBox(height: 16),

          /// التذييل (التاريخ + الناشر)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.calendar_today,
                      size: 12,
                      color: Colors.blue.shade600,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    widget.content.publishDate ?? "غير محدد",
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  const SizedBox(width: 20),
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.orange.shade50,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.person_outline,
                      size: 12,
                      color: Colors.orange.shade600,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    "بواسطة: ${widget.content.adminName ?? 'الإدارة'}",
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// ================= تعديل =================
  void _showEditDialog(BuildContext context) {
    final titleController = TextEditingController(text: widget.content.title);
    final contentController = TextEditingController(
      text: widget.content.content,
    );
    Uint8List? newImageBytes;

    showDialog(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('تعديل المحتوى'),
              content: SizedBox(
                width: 500,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        controller: titleController,
                        decoration: const InputDecoration(labelText: 'العنوان'),
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: contentController,
                        maxLines: 3,
                        decoration: const InputDecoration(labelText: 'المحتوى'),
                      ),
                      const SizedBox(height: 20),

                      // زر اختيار صورة جديدة
                      OutlinedButton.icon(
                        onPressed: () async {
                          final picker = ImagePicker();
                          final picked = await picker.pickImage(
                            source: ImageSource.gallery,
                          );
                          if (picked != null) {
                            final bytes = await picked.readAsBytes();
                            setState(() {
                              newImageBytes = bytes;
                            });
                          }
                        },
                        icon: const Icon(Icons.image_outlined),
                        label: Text(
                          newImageBytes == null &&
                                  (widget.content.image == null ||
                                      widget.content.image!.isEmpty)
                              ? "إضافة صورة"
                              : "تغيير الصورة",
                        ),
                      ),

                      if (newImageBytes != null) ...[
                        const SizedBox(height: 10),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.memory(
                            newImageBytes!,
                            height: 100,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ] else if (widget.content.image != null &&
                          widget.content.image!.isNotEmpty) ...[
                        const SizedBox(height: 10),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child:
                              widget.content.image!.startsWith('http')
                                  ? Image.network(
                                    widget.content.image!,
                                    height: 100,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                  )
                                  : Image.memory(
                                    base64Decode(widget.content.image!),
                                    height: 100,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                  ),
                        ),
                      ],
                    ],
                  ),
                ),
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
                      content: contentController.text,
                      image:
                          newImageBytes != null
                              ? base64Encode(newImageBytes!)
                              : widget.content.image,
                    );
                    Navigator.pop(
                      context,
                    ); // نغلق النافذة أولاً لتجنب مشاكل الـ Hit Test
                    widget.onEdit(updated); // ثم نقوم بعملية التحديث
                  },
                  child: const Text('حفظ'),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
