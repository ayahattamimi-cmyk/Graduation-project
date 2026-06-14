import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:web2/content/data/models/content_model.dart';

class AddContentDialog extends StatefulWidget {
  const AddContentDialog({super.key});

  @override
  State<AddContentDialog> createState() => _AddContentDialogState();
}

class _AddContentDialogState extends State<AddContentDialog> {
  ContentType selectedType = ContentType.news;
  bool publishNow = true;
  Uint8List? imageBytes;

  final TextEditingController titleController = TextEditingController();
  final TextEditingController contentController = TextEditingController();

  /// يختار صورة من معرض الجهاز.
  Future<void> pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);

    if (picked != null) {
      final bytes = await picked.readAsBytes();
      setState(() {
        imageBytes = bytes;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: const Color(0xffffffff),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        width: 600,
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "إضافة محتوى جديد",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            const Text(
              "نشر محتوى توعوي للمواطنين",
              style: TextStyle(color: Color(0xFF616161)),
            ),
            const SizedBox(height: 25),

            DropdownButtonFormField<ContentType>(
              value: selectedType,
              decoration: InputDecoration(
                labelText: "نوع المحتوى",
                prefixIcon: Icon(
                  selectedType == ContentType.news
                      ? Icons.newspaper
                      : Icons.lightbulb,
                  color:
                      selectedType == ContentType.news
                          ? Colors.blue
                          : Colors.orange,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              items: const [
                DropdownMenuItem(value: ContentType.news, child: Text("خبر")),
                DropdownMenuItem(value: ContentType.tips, child: Text("نصيحة")),
              ],
              onChanged: (value) => setState(() => selectedType = value!),
            ),

            const SizedBox(height: 18),

            TextField(
              controller: titleController,
              decoration: InputDecoration(
                labelText: "العنوان",
                hintText:
                    "أدخل عنوان ${selectedType == ContentType.news ? 'الخبر' : 'النصيحة'}...",
                prefixIcon: const Icon(Icons.title),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),

            const SizedBox(height: 18),

            TextField(
              controller: contentController,
              maxLines: 4,
              onChanged: (_) => setState(() {}),
              decoration: InputDecoration(
                hintText: "اكتب المحتوى هنا...",
                prefixIcon: const Icon(Icons.edit_note),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),

            const SizedBox(height: 18),

            if (selectedType == ContentType.news)
              OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 14,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: pickImage,
                icon: const Icon(Icons.image_outlined),
                label: const Text("إضافة صورة"),
              ),

            if (imageBytes != null) ...[
              const SizedBox(height: 10),
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.memory(
                  imageBytes!,
                  height: 120,
                  fit: BoxFit.cover,
                ),
              ),
            ],

            const SizedBox(height: 18),

            Row(
              children: [
                Checkbox(
                  value: publishNow,
                  onChanged: (v) => setState(() => publishNow = v!),
                ),
                const Text("نشر فوراً", style: TextStyle(fontSize: 15)),
              ],
            ),

            const SizedBox(height: 10),

            SizedBox(
              width: double.infinity,
              height: 45,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xff2563EB),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed:
                    contentController.text.trim().isEmpty ||
                            titleController.text.trim().isEmpty
                        ? null
                        : () {
                          final newContent = ContentModel(
                            id: DateTime.now().millisecondsSinceEpoch,
                            title: titleController.text.trim(),
                            content: contentController.text.trim(),
                            type: selectedType,
                            image:
                                imageBytes != null
                                    ? base64Encode(imageBytes!)
                                    : null,
                            publishDate: DateTime.now().toIso8601String(),
                            isPublished: publishNow,
                            category: null,
                            adminName: 'المشرف',
                          );
                          Navigator.pop(context, newContent);
                        },
                child: const Text(
                  "إضافة المحتوى",
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
