import 'package:flutter/material.dart';

class FeatureTile extends StatelessWidget {
  final String text;
  final Color color;
  final TextStyle? textStyle;
  final double bottomPadding;

  const FeatureTile({
    super.key,
    required this.text,
    required this.color,
    this.textStyle,
    this.bottomPadding = 10,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: bottomPadding),

      child: Row(
        children: [
          Container(
            height: 8,
            width: 8,

            decoration: BoxDecoration(shape: BoxShape.circle, color: color),
          ),

          const SizedBox(width: 14),

          Expanded(
            child: Text(
              text,

              style:
                  textStyle ??
                  const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }
}
