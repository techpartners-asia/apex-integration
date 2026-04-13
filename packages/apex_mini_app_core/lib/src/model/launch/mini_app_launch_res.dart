import 'mini_app_launch_error_code.dart';
import 'mini_app_launch_status.dart';

class MiniAppLaunchRes {
  final MiniAppLaunchStatus status;
  final String? route;
  final Object? data;
  final MiniAppLaunchErrorCode? errorCode;
  final String? errorMessage;

  MiniAppLaunchRes({
    required this.status,
    this.route,
    this.data,
    this.errorCode,
    this.errorMessage,
  }) {
    validateStatusAndFields();
  }

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

  void validateStatusAndFields() {
    if (status == MiniAppLaunchStatus.failed && errorCode == null) {
      throw ArgumentError('MiniAppLaunchRes.errorCode is required when status is failed.');
    }
    if (status == MiniAppLaunchStatus.failed && errorMessage == null) {
      throw ArgumentError('MiniAppLaunchRes.errorMessage is required when status is failed.');
    }
  }
}
