/// Investment package option shown during pack selection.
class IpsPack {
  /// Backend package code used when creating orders.
  final String packCode;

  /// Primary package name.
  final String name;

  /// Secondary/localized package name.
  final String? name2;

  /// Package description text.
  final String? packDesc;

  /// Backend recommendation flag.
  final int isRecommended;

  /// Bond allocation percentage.
  final double bondPercent;

  /// Stock allocation percentage.
  final double stockPercent;

  /// Asset/cash allocation percentage.
  final double assetPercent;

  /// Creates an investment package domain model.
  const IpsPack({
    required this.packCode,
    required this.name,
    this.name2,
    this.packDesc,
    required this.isRecommended,
    required this.bondPercent,
    required this.stockPercent,
    required this.assetPercent,
  });
}
