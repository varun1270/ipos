import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

class _CountryOption {
  final String code;
  final String flag;
  final String label;

  const _CountryOption(this.code, this.flag, this.label);
}

class CountryCodePicker extends StatelessWidget {
  final String value;
  final ValueChanged<String> onChanged;
  final bool embedded;

  const CountryCodePicker({
    super.key,
    required this.value,
    required this.onChanged,
    this.embedded = false,
  });

  static const List<_CountryOption> _options = [
    _CountryOption('+91', '🇮🇳', 'India'),
    _CountryOption('+1', '🇺🇸', 'United States'),
    _CountryOption('+44', '🇬🇧', 'United Kingdom'),
  ];

  _CountryOption get _selected =>
      _options.firstWhere((o) => o.code == value, orElse: () => _options.first);

  Future<void> _openSheet(BuildContext context) async {
    final picked = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: AppColors.background,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 8),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.border,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(16),
                child: Text(
                  'Select country code',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              for (final option in _options)
                ListTile(
                  leading: Text(
                    option.flag,
                    style: const TextStyle(fontSize: 22),
                  ),
                  title: Text(
                    option.label,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  trailing: Text(
                    option.code,
                    style: const TextStyle(
                      fontWeight: FontWeight.w800,
                      color: AppColors.primary,
                    ),
                  ),
                  selected: option.code == value,
                  onTap: () => Navigator.pop(context, option.code),
                ),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );

    if (picked != null) onChanged(picked);
  }

  @override
  Widget build(BuildContext context) {
    if (embedded) {
      return Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _openSheet(context),
          borderRadius: BorderRadius.circular(10),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  _selected.flag,
                  style: const TextStyle(fontSize: 18, height: 1.1),
                ),
                const SizedBox(width: 6),
                Text(
                  _selected.code,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w800,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(width: 2),
                const Icon(
                  Icons.keyboard_arrow_down_rounded,
                  size: 18,
                  color: AppColors.textSecondary,
                ),
              ],
            ),
          ),
        ),
      );
    }

    return DropdownButtonHideUnderline(
      child: DropdownButton<String>(
        value: value,
        icon: const Icon(Icons.keyboard_arrow_down_rounded, size: 18),
        style: const TextStyle(
          color: AppColors.textPrimary,
          fontWeight: FontWeight.w700,
        ),
        items: _options
            .map(
              (o) => DropdownMenuItem(
                value: o.code,
                child: Text('${o.flag}  ${o.code}'),
              ),
            )
            .toList(),
        onChanged: (v) {
          if (v != null) onChanged(v);
        },
      ),
    );
  }
}
