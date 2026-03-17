import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'content_model.dart';

class AddContentDialog extends StatefulWidget {
  const AddContentDialog({super.key});

  @override
  State<AddContentDialog> createState() => _AddContentDialogState();
}

class _AddContentDialogState extends State<AddContentDialog> {

  ContentType selectedType = ContentType.news;
  String? tipCategory;
  bool publishNow = true;
  Uint8List? imageBytes;

  final TextEditingController controller = TextEditingController();

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
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Container(
        width: 600,
        padding: const EdgeInsets.all(28),

        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [

            /// العنوان
            const Text(
              "إضافة محتوى جديد",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 6),

            const Text(
              "نشر محتوى توعوي للمواطنين",
              style: TextStyle(color: Colors.grey),
            ),

            const SizedBox(height: 25),

            /// نوع المحتوى
            DropdownButtonFormField<ContentType>(

              value: selectedType,

              decoration: InputDecoration(
                labelText: "نوع المحتوى",
                prefixIcon: Icon(
                  selectedType == ContentType.news
                      ? Icons.newspaper
                      : Icons.lightbulb,
                  color: selectedType == ContentType.news
                      ? Colors.blue
                      : Colors.orange,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),

              items: const [
                DropdownMenuItem(
                  value: ContentType.news,
                  child: Text("خبر"),
                ),
                DropdownMenuItem(
                  value: ContentType.tip,
                  child: Text("نصيحة"),
                ),
              ],

              onChanged: (value) {
                setState(() {
                  selectedType = value!;
                });
              },
            ),

            const SizedBox(height: 18),

            /// تصنيف النصيحة
            if (selectedType == ContentType.tip)
              DropdownButtonFormField<String>(

                decoration: InputDecoration(
                  labelText: "تصنيف النصيحة",
                  prefixIcon: const Icon(Icons.category),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),

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

            const SizedBox(height: 18),

            /// المحتوى
            TextField(
              controller: controller,
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

            /// رفع الصورة (للخبر)
            if (selectedType == ContentType.news)
              OutlinedButton.icon(

                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20, vertical: 14),
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
              )
            ],

            const SizedBox(height: 18),

            /// النشر
            Row(
              children: [

                Checkbox(
                  value: publishNow,
                  onChanged: (v) {
                    setState(() {
                      publishNow = v!;
                    });
                  },
                ),

                const Text(
                  "نشر فوراً",
                  style: TextStyle(fontSize: 15),
                ),

              ],
            ),

            const SizedBox(height: 10),

            /// زر الإضافة
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

                onPressed: controller.text.trim().isEmpty
                    ? null
                    : () {

                  final newContent = ContentModel(
                    id: DateTime.now()
                        .millisecondsSinceEpoch
                        .toString(),

                    title: selectedType == ContentType.tip
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

                  Navigator.pop(context, newContent);
                },

                child: const Text(
                  "إضافة المحتوى",
                  style: TextStyle(fontSize: 16,color: Colors.white),
                ),
              ),
            )

          ],
        ),
      ),
    );
  }
}