import 'package:flutter/material.dart';

class MapInfoBottomSheet extends StatelessWidget {

  final String title;
  final String description;

  const MapInfoBottomSheet({
    super.key,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {

    return Container(

      padding: const EdgeInsets.all(20),

      decoration: const BoxDecoration(
        color: Colors.white,

        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),

      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [

          Center(
            child: Container(
              width: 50,
              height: 5,

              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),

          const SizedBox(height: 20),

          Text(
            title,

            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 10),

          Text(
            description,

            style: const TextStyle(
              color: Colors.grey,
              height: 1.5,
            ),
          ),

          const SizedBox(height: 20),

          SizedBox(
            width: double.infinity,

            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },

              child: const Text("إغلاق"),
            ),
          ),
        ],
      ),
    );
  }

  static void show(
      BuildContext context,
      String title,
      String description,
      ) {

    showModalBottomSheet(

      context: context,

      backgroundColor: Colors.transparent,

      isScrollControlled: true,

      builder: (_) {

        return MapInfoBottomSheet(
          title: title,
          description: description,
        );
      },
    );
  }
}