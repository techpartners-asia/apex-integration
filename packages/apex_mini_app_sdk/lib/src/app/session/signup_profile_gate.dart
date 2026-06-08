import 'package:apex_mini_app_sdk/apex_mini_app_sdk.dart';

/// Returns whether signup returned the minimum identity fields required to enter IPS.
bool hasCompleteSignupProfile(UserEntityDto user) {
  return _hasValue(user.registerNo) &&
      _hasValue(user.firstName) &&
      _hasValue(user.lastName) &&
      _hasValue(user.phone);
}

bool _hasValue(String? value) {
  return value?.trim().isNotEmpty ?? false;
}
