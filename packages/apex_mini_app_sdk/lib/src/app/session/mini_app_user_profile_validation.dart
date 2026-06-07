import 'package:apex_mini_app_sdk/apex_mini_app_sdk.dart';

/// Whether [user] has the minimum identity fields required to enter InvestX.
bool hasRequiredUserProfileFields(UserEntityDto? user) {
  return _hasText(user?.registerNo) &&
      _hasText(user?.firstName) &&
      _hasText(user?.lastName) &&
      _hasText(user?.phone) &&
      _hasText(user?.email);
}

bool _hasText(String? value) {
  final String? normalized = value?.trim();
  return normalized != null && normalized.isNotEmpty;
}
