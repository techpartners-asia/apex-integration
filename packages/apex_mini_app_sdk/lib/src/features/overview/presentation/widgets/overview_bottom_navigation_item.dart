/// Configuration for a single tab in [OverviewBottomNavigationBar].
final class OverviewBottomNavigationItem {
  /// Tab label shown below the icon.
  final String label;

  /// Tab icon. Supports [IconData] or an asset path [String] (`.svg` or `.png`).
  final Object icon;

  /// Creates an overview bottom-navigation tab item.
  const OverviewBottomNavigationItem({
    required this.label,
    required this.icon,
  });
}
