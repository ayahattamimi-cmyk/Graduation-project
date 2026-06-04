import 'dart:io';
import 'package:pdf/widgets.dart' as pw;

void main() async {
  final pdf = pw.Document();
  final fontData = File('assets/fonts/Tajawal-Regular.ttf').readAsBytesSync();
  final ttf = pw.Font.ttf(fontData.buffer.asByteData());

  try {
    pdf.addPage(
      pw.MultiPage(
        theme: pw.ThemeData.withFont(
          base: ttf,
          bold: ttf,
          fontFallback: [pw.Font.helvetica()],
        ),
        textDirection: pw.TextDirection.rtl,
        build:
            (context) => [
              pw.Table.fromTextArray(
                headers: [
                  "المشرف",
                  "النوع",
                  "المستلم",
                  "المنجز",
                  "الإنجاز",
                  "الاستجابة",
                  "المعالجة",
                ],
                data: List.generate(
                  1,
                  (i) => ['أحمد', 'رفع', '0', '0', '0%', '0 دقيقة', '0 دقيقة'],
                ),
              ),
            ],
      ),
    );
    await pdf.save();
    print("Success 7");
  } catch (e) {
    print("Error 7: \$e");
  }
}
