/// Generic action response used by order/recharge API calls.
class ActionRes {
  /// Optional backend message to surface in UI or logs.
  final String? message;

  /// Creates a normalized action response.
  const ActionRes({this.message});
}
