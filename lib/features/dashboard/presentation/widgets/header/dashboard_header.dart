import 'package:flutter/material.dart';

import '../../../../../core/utils/responsive_utils.dart';
import '../../../../../shared/widgets/ipos_logo_3d.dart';
import '../../utils/dashboard_responsive.dart';
import '../shared/dashboard_3d_styles.dart';
import 'date_range_filter_chip.dart';
import 'notification_bell.dart';
import 'shop_selector_dropdown.dart';
import 'user_avatar.dart';

class DashboardHeader extends StatelessWidget {
  const DashboardHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final inlineFilters = DashboardResponsive.useInlineHeaderFilters(context);

    return Dashboard3DSurface.panel(
      padding: EdgeInsets.all(context.responsiveValue(
        compact: 16,
        medium: 18,
        expanded: 20,
      )),
      expandWidth: true,
      child: inlineFilters ? _buildWideHeader(context) : _buildCompactHeader(context),
    );
  }

  Widget _buildCompactHeader(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _buildLogo(context, compact: true),
            const Spacer(),
            const NotificationBell(),
            const SizedBox(width: 10),
            const UserAvatar(initials: 'NB'),
          ],
        ),
        const SizedBox(height: 12),
        const ShopSelectorDropdown(),
        const SizedBox(height: 12),
        const DateRangeFilterChip(),
      ],
    );
  }

  Widget _buildWideHeader(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _buildLogo(context),
        SizedBox(
          width: context.responsiveValue(
            compact: 12,
            medium: 16,
            expanded: 18,
          ),
        ),
        SizedBox(
          width: context.responsiveValue(
            compact: 180,
            medium: 220,
            expanded: 260,
          ),
          child: const ShopSelectorDropdown(),
        ),
        const Spacer(),
        SizedBox(
          width: context.responsiveValue(
            compact: 260,
            medium: 300,
            expanded: 340,
          ),
          child: const DateRangeFilterChip(),
        ),
        SizedBox(
          width: context.responsiveValue(
            compact: 10,
            medium: 12,
            expanded: 14,
          ),
        ),
        const NotificationBell(),
        const SizedBox(width: 10),
        const UserAvatar(initials: 'NB'),
      ],
    );
  }

  Widget _buildLogo(BuildContext context, {bool compact = false}) {
    final scale = context.responsiveValue(
      compact: compact ? 0.44 : 0.38,
      medium: 0.42,
      expanded: 0.45,
    );

    return IposLogo3D(scale: scale);
  }
}
