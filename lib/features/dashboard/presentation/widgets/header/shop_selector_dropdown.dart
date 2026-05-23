import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../providers/dashboard_providers.dart';
import '../../utils/dashboard_load_utils.dart';
import '../shared/hard_3d_surface.dart';

class ShopSelectorDropdown extends ConsumerStatefulWidget {
  const ShopSelectorDropdown({super.key});

  @override
  ConsumerState<ShopSelectorDropdown> createState() =>
      _ShopSelectorDropdownState();
}

class _ShopSelectorDropdownState extends ConsumerState<ShopSelectorDropdown> {
  static const _triggerHeight = 40.0;
  static const _animationDuration = Duration(milliseconds: 220);

  final MenuController _menuController = MenuController();

  Future<void> _selectShop(String shopId, String currentShopId) async {
    if (shopId == currentShopId) {
      _menuController.close();
      return;
    }

    HapticFeedback.selectionClick();
    _menuController.close();

    ref.read(shopSelectorControllerProvider).setShop(shopId);
    await loadDashboard(ref);
  }

  @override
  Widget build(BuildContext context) {
    final controller = ref.watch(shopSelectorControllerProvider);
    final shops = controller.shops;
    final colors = context.appColors;
    final accent = context.adaptivePrimary;
    final selectedShopId = controller.selectedShopId;
    final selectedShopName = controller.selectedShopName;

    return MenuAnchor(
      controller: _menuController,
      alignmentOffset: const Offset(0, 6),
      crossAxisUnconstrained: false,
      style: MenuStyle(
        elevation: const WidgetStatePropertyAll(0),
        backgroundColor: const WidgetStatePropertyAll(Colors.transparent),
        surfaceTintColor: const WidgetStatePropertyAll(Colors.transparent),
        shadowColor: const WidgetStatePropertyAll(Colors.transparent),
        padding: const WidgetStatePropertyAll(EdgeInsets.zero),
        minimumSize: const WidgetStatePropertyAll(Size(220, 0)),
        maximumSize: const WidgetStatePropertyAll(Size(double.infinity, 320)),
      ),
      menuChildren: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 2),
          child: Hard3DSurface.light(
            color: colors.elevatedSurface,
            borderRadius: 16,
            depth: 4,
            padding: const EdgeInsets.all(6),
            expandWidth: true,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 6, 10, 4),
                  child: Row(
                    children: [
                      Icon(
                        Icons.storefront_rounded,
                        size: 14,
                        color: colors.textTertiary,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'Select shop',
                        style: TextStyle(
                          color: colors.textTertiary,
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.6,
                        ),
                      ),
                    ],
                  ),
                ),
                for (var i = 0; i < shops.length; i++) ...[
                  if (i > 0) const SizedBox(height: 2),
                  _ShopMenuItem(
                    name: shops[i]['name'] ?? '',
                    selected: selectedShopId == shops[i]['id'],
                    accent: accent,
                    onTap: () => _selectShop(
                      shops[i]['id']!,
                      selectedShopId,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ],
      builder: (context, menuController, child) {
        final isOpen = menuController.isOpen;

        return Hard3DSurface.light(
          color: colors.elevatedSurface,
          borderRadius: 16,
          depth: 3,
          padding: const EdgeInsets.all(5),
          expandWidth: true,
          onTap: () {
            if (menuController.isOpen) {
              menuController.close();
            } else {
              menuController.open();
            }
          },
          child: SizedBox(
            height: _triggerHeight,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6),
              child: Row(
                children: [
                  Icon(
                    Icons.storefront_rounded,
                    size: 18,
                    color: isOpen ? accent : colors.textSecondary,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      selectedShopName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: colors.textPrimary,
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.1,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  AnimatedRotation(
                    turns: isOpen ? 0.5 : 0,
                    duration: _animationDuration,
                    curve: Curves.easeOutCubic,
                    child: Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: isOpen ? accent : colors.textTertiary,
                      size: 22,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _ShopMenuItem extends StatelessWidget {
  final String name;
  final bool selected;
  final Color accent;
  final VoidCallback onTap;

  const _ShopMenuItem({
    required this.name,
    required this.selected,
    required this.accent,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOutCubic,
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: selected ? accent.withValues(alpha: 0.12) : Colors.transparent,
          ),
          child: Row(
            children: [
              Icon(
                Icons.storefront_rounded,
                size: 16,
                color: selected ? accent : colors.textTertiary,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: selected ? accent : colors.textPrimary,
                    fontWeight: selected ? FontWeight.w800 : FontWeight.w600,
                    fontSize: 13,
                    letterSpacing: 0.1,
                  ),
                ),
              ),
              if (selected)
                Icon(
                  Icons.check_rounded,
                  color: accent,
                  size: 18,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
