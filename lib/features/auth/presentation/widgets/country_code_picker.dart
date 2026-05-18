import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

class CountryCodePicker extends StatelessWidget {
  final String value;
  final ValueChanged<String> onChanged;

  const CountryCodePicker({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: DropdownButton<String>(
        value: value,
        icon: const Icon(Icons.keyboard_arrow_down_rounded, size: 18),
        style: const TextStyle(
          color: AppColors.textPrimary,
          fontWeight: FontWeight.w700,
        ),
        items: const [
          DropdownMenuItem(value: '+91', child: Text('+91')),
          DropdownMenuItem(value: '+1', child: Text('+1')),
          DropdownMenuItem(value: '+44', child: Text('+44')),
        ],
        onChanged: (value) {
          if (value != null) onChanged(value);
        },
      ),
    );
  }
}
