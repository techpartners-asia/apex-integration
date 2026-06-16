/// Normalized status values for IPS orders.
enum IpsOrderStatus {
  /// Order is created but not completed yet.
  pending,

  /// Order confirmed/approved by broker.
  confirmed,

  /// Order completed successfully.
  completed,

  /// Order shares have been allocated.
  allocated,

  /// Order was cancelled.
  cancelled,

  /// Order failed.
  failed,
}
