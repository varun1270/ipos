import 'package:flutter/material.dart';

class FeatureTile extends StatelessWidget {

  final String text;
  final Color color;

  const FeatureTile({
    super.key,
    required this.text,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),

      child: Row(
        children: [

          Container(
            height: 8,
            width: 8,

            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color,
            ),
          ),

          const SizedBox(width: 14),

          Expanded(
            child: Text(
              text,

              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}