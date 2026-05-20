import 'mini_app_launch_error_code.dart';
import 'mini_app_launch_status.dart';

/// Result returned after a mini-app route launch or replacement attempt.
class MiniAppLaunchRes {
  /// Final launch status.
  final MiniAppLaunchStatus status;

  /// Route that was launched or attempted.
  final String? route;

  /// Optional data returned when the pushed route completes.
  final Object? data;

  /// Required when [status] is failed.
  final MiniAppLaunchErrorCode? errorCode;

  /// Required when [status] is failed.
  final String? errorMessage;

  /// Creates a launch result and validates failure metadata.
  MiniAppLaunchRes({
    required this.status,
    this.route,
    this.data,
    this.errorCode,
    this.errorMessage,
  }) {
    validateStatusAndFields();
  }

  /// Creates a failed launch result.
  factory MiniAppLaunchRes.failure({
    required MiniAppLaunchErrorCode errorCode,
    required String errorMessage,
    String? route,
  }) {
    return MiniAppLaunchRes(
      status: MiniAppLaunchStatus.failed,
      route: route,
      errorCode: errorCode,
      errorMessage: errorMessage,
    );
  }

  /// Ensures failure results always carry structured failure information.
  void validateStatusAndFields() {
    if (status == MiniAppLaunchStatus.failed && errorCode == null) {
      throw ArgumentError(
        'MiniAppLaunchRes.errorCode is required when status is failed.',
      );
    }
    if (status == MiniAppLaunchStatus.failed && errorMessage == null) {
      throw ArgumentError(
        'MiniAppLaunchRes.errorMessage is required when status is failed.',
      );
    }
  }
}
