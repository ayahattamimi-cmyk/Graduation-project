import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../models/content_model.dart';

class AddContentDialog extends StatefulWidget {
  const AddContentDialog({super.key});

  @override
  State<AddContentDialog> createState() =>
      _AddContentDialogState();
}

class _AddContentDialogState
    extends State<AddContentDialog> {

  ContentType selectedType = ContentType.news;
  String? tipCategory;
  bool publishNow = true;
  Uint8List? imageBytes;

  final TextEditingController controller =
  TextEditingController();

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final picked =
    await picker.pickImage(source: ImageSource.gallery);

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
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [

            DropdownButtonFormField<ContentType>(
              value: selectedType,
              items: const [
                DropdownMenuItem(
                    value: ContentType.news,
                    child: Text('خبر')),
                DropdownMenuItem(
                    value: ContentType.tip,
                    child: Text('نصيحة')),
              ],
              onChanged: (value) {
                setState(() {
                  selectedType = value!;
                });
              },
            ),

            if (selectedType == ContentType.tip)
              DropdownButtonFormField<String>(
                items: const [
                  DropdownMenuItem(
                      value: 'النفايات',
                      child: Text('النفايات')),
                  DropdownMenuItem(
                      value: 'إعادة التدوير',
                      child: Text('إعادة التدوير')),
                  DropdownMenuItem(
                      value: 'البيئة',
                      child: Text('البيئة')),
                ],
                onChanged: (value) {
                  tipCategory = value;
                },
              ),

            const SizedBox(height: 16),

            TextField(
              controller: controller,
              maxLines: 3,
              onChanged: (_) => setState(() {}),
              decoration:
              const InputDecoration(hintText: 'اكتب المحتوى'),
            ),

            const SizedBox(height: 16),

            if (selectedType == ContentType.news)
              OutlinedButton.icon(
                onPressed: pickImage,
                icon: const Icon(Icons.image),
                label: const Text('إضافة صورة'),
              ),

            if (imageBytes != null)
              Image.memory(imageBytes!, height: 120),

            const SizedBox(height: 16),

            Row(
              children: [
                Checkbox(
                    value: publishNow,
                    onChanged: (v) {
                      setState(() {
                        publishNow = v!;
                      });
                    }),
                const Text('نشر فوراً')
              ],
            ),

            const SizedBox(height: 16),

            ElevatedButton(
              onPressed: controller.text.trim().isEmpty
                  ? null
                  : () {
                final newContent = ContentModel(
                  id: DateTime.now()
                      .millisecondsSinceEpoch
                      .toString(),
                  title: selectedType ==
                      ContentType.tip
                      ? tipCategory ?? 'نصيحة'
                      : 'خبر',
                  description: controller.text,
                  type: selectedType,
                  imageBase64: imageBytes != null
                      ? base64Encode(imageBytes!)
                      : null,
                  date: DateTime.now(),
                  isPublished: publishNow,
                  tipCategory: tipCategory,
                  authorName: 'المشرف',
                );

                Navigator.pop(
                    context, newContent);
              },
              child: const Text('إضافة'),
            )
          ],
        ),
      ),
    );
  }
}
