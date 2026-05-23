import 'package:flutter/material.dart';

/// Scroll view that insets content below the status bar and above the home indicator.
///
/// Use when [ThemedScreen] has `applySafeArea: false` (e.g. full-bleed backgrounds).
class AppSafeScroll extends StatelessWidget {
  final List<Widget> slivers;
  final ScrollPhysics? physics;

  const AppSafeScroll({
    super.key,
    required this.slivers,
    this.physics,
  });

  /// Single child wrapped in [SliverSafeArea].
  factory AppSafeScroll.child({
    Key? key,
    required Widget child,
    EdgeInsetsGeometry? padding,
    ScrollPhysics? physics,
  }) {
    return AppSafeScroll(
      key: key,
      physics: physics,
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: padding ?? EdgeInsets.zero,
            child: child,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      physics: physics ??
          const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics(),
          ),
      slivers: [
        SliverSafeArea(
          minimum: EdgeInsets.zero,
          sliver: _buildGroupedSlivers(),
        ),
      ],
    );
  }

  Widget _buildGroupedSlivers() {
    if (slivers.length == 1) return slivers.first;
    return SliverMainAxisGroup(slivers: slivers);
  }
}
