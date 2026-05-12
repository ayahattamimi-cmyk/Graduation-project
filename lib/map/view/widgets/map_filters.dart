import 'package:flutter/material.dart';

class MapFilterWidget extends StatelessWidget {
  const MapFilterWidget({super.key});

  @override
  Widget build(BuildContext context) {

    return Container(
      width: 300,

      padding: const EdgeInsets.all(16),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 5,
          ),
        ],
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          /// العنوان
          Row(
            children: const [

              Icon(
                Icons.filter_alt_outlined,
                color: Colors.blue,
              ),

              SizedBox(width: 8),

              Text(
                "فلترة الخريطة",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          /// البحث
          TextField(
            decoration: InputDecoration(
              hintText: "بحث...",
              prefixIcon: const Icon(Icons.search),

              filled: true,
              fillColor: const Color(0xffF3F4F6),

              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
          ),

          const SizedBox(height: 14),

          /// نوع البلاغ
          DropdownButtonFormField<String>(

            value: "الكل",

            items: const [

              DropdownMenuItem(
                value: "الكل",
                child: Text("كل البلاغات"),
              ),

              DropdownMenuItem(
                value: "عاجل",
                child: Text("عاجل"),
              ),

              DropdownMenuItem(
                value: "تم التنفيذ",
                child: Text("تم التنفيذ"),
              ),
            ],

            onChanged: (v) {},

            decoration: InputDecoration(

              labelText: "حالة البلاغ",

              filled: true,
              fillColor: const Color(0xffF3F4F6),

              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
          ),

          const SizedBox(height: 14),

          /// نوع الحاوية
          DropdownButtonFormField<String>(

            value: "الكل",

            items: const [

              DropdownMenuItem(
                value: "الكل",
                child: Text("كل الحاويات"),
              ),

              DropdownMenuItem(
                value: "ثابت",
                child: Text("ثابت"),
              ),

              DropdownMenuItem(
                value: "مستحدث",
                child: Text("مستحدث"),
              ),
            ],

            onChanged: (v) {},

            decoration: InputDecoration(

              labelText: "نوع الحاوية",

              filled: true,
              fillColor: const Color(0xffF3F4F6),

              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
          ),

          const SizedBox(height: 14),

          /// المنطقة
          DropdownButtonFormField<String>(

            value: "كل المناطق",

            items: const [

              DropdownMenuItem(
                value: "كل المناطق",
                child: Text("كل المناطق"),
              ),

              DropdownMenuItem(
                value: "مربع 1",
                child: Text("مربع 1"),
              ),

              DropdownMenuItem(
                value: "مربع 2",
                child: Text("مربع 2"),
              ),
            ],

            onChanged: (v) {},

            decoration: InputDecoration(

              labelText: "المنطقة",

              filled: true,
              fillColor: const Color(0xffF3F4F6),

              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ],
      ),
    );
  }
}