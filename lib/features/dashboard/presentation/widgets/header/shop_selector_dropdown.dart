import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../providers/dashboard_providers.dart';
import '../../utils/dashboard_load_utils.dart';

class ShopSelectorDropdown extends ConsumerWidget {
  const ShopSelectorDropdown({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(shopSelectorControllerProvider);
    final shops = controller.shops;

    return DropdownButtonHideUnderline(
      child: DropdownButton<String>(
        value: controller.selectedShopId,
        isExpanded: true,
        icon: const Icon(Icons.keyboard_arrow_down, size: 20),
        style: const TextStyle(
          color: AppColors.textPrimary,
          fontSize: 15,
          fontWeight: FontWeight.w600,
        ),
        items: shops
            .map(
              (shop) => DropdownMenuItem<String>(
                value: shop['id'],
                child: Text(shop['name'] ?? ''),
              ),
            )
            .toList(),
        onChanged: (shopId) async {
          if (shopId == null) return;
          ref.read(shopSelectorControllerProvider).setShop(shopId);
          await loadDashboard(ref);
        },
      ),
    );
  }
}
