/// Normalized status values for IPS orders.
enum IpsOrderStatus {
  /// Order is created but not completed yet.
  pending,

  /// Order completed successfully.
  completed,

  /// Order was cancelled.
  cancelled,

  /// Order failed.
  failed,
}
