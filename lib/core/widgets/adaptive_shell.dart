import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shopsphere/core/l10n/l10n.dart';
import 'package:shopsphere/core/utils/breakpoints.dart';
import 'package:shopsphere/core/widgets/offline_banner.dart';

/// A top-level destination in the main navigation.
class ShellDestination {
  const ShellDestination({
    required this.label,
    required this.icon,
    required this.selectedIcon,
  });

  /// Looked up per build so it follows the current language.
  final String Function(BuildContext context) label;
  final IconData icon;
  final IconData selectedIcon;
}

/// Shows a bottom [NavigationBar] on compact widths and a [NavigationRail]
/// on medium and expanded widths.
class AdaptiveShell extends StatelessWidget {
  const AdaptiveShell({
    required this.navigationShell,
    required this.destinations,
    this.badges = const {},
    super.key,
  });

  final StatefulNavigationShell navigationShell;
  final List<ShellDestination> destinations;

  /// Count badges keyed by destination index, e.g. `{1: cartItemCount}`.
  final Map<int, int> badges;

  /// Switching tabs also dismisses any snackbar, so a message about one
  /// screen never covers buttons on the next.
  void _onSelect(BuildContext context, int index) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  Widget _icon(int index, {required bool selected}) {
    final destination = destinations[index];
    return _CountBadge(
      count: badges[index] ?? 0,
      child: Icon(selected ? destination.selectedIcon : destination.icon),
    );
  }

  String _label(BuildContext context, int index) {
    final count = badges[index] ?? 0;
    final label = destinations[index].label(context);
    return count > 0 ? context.l10n.navItemsLabel(label, count) : label;
  }

  @override
  Widget build(BuildContext context) {
    final size = context.windowSize;

    if (size.isCompact) {
      return Scaffold(
        body: Column(
          children: [
            Expanded(child: navigationShell),
            const OfflineBanner(),
          ],
        ),
        bottomNavigationBar: NavigationBar(
          selectedIndex: navigationShell.currentIndex,
          onDestinationSelected: (index) => _onSelect(context, index),
          destinations: [
            for (var i = 0; i < destinations.length; i++)
              NavigationDestination(
                icon: _icon(i, selected: false),
                selectedIcon: _icon(i, selected: true),
                label: destinations[i].label(context),
                tooltip: _label(context, i),
              ),
          ],
        ),
      );
    }

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Row(
          children: [
            NavigationRail(
              selectedIndex: navigationShell.currentIndex,
              onDestinationSelected: (index) => _onSelect(context, index),
              extended: size.isExpanded,
              minWidth: 72,
              // Centred vertically so a short landscape screen looks balanced.
              groupAlignment: 0,
              labelType: size.isExpanded
                  ? NavigationRailLabelType.none
                  : NavigationRailLabelType.all,
              destinations: [
                for (var i = 0; i < destinations.length; i++)
                  NavigationRailDestination(
                    icon: _icon(i, selected: false),
                    selectedIcon: _icon(i, selected: true),
                    label: Text(destinations[i].label(context)),
                  ),
              ],
            ),
            const VerticalDivider(width: 1, thickness: 1),
            Expanded(
              child: Column(
                children: [
                  Expanded(child: navigationShell),
                  const OfflineBanner(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Badge that pops briefly whenever [count] changes.
class _CountBadge extends StatelessWidget {
  const _CountBadge({required this.count, required this.child});

  final int count;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final badge = Badge(
      isLabelVisible: count > 0,
      label: Text(count > 99 ? '99+' : '$count'),
      child: child,
    );
    if (MediaQuery.disableAnimationsOf(context)) return badge;

    return TweenAnimationBuilder<double>(
      key: ValueKey(count),
      tween: Tween(begin: count > 0 ? 1.3 : 1, end: 1),
      duration: const Duration(milliseconds: 450),
      curve: Curves.elasticOut,
      child: badge,
      builder: (context, scale, child) =>
          Transform.scale(scale: scale, child: child),
    );
  }
}
