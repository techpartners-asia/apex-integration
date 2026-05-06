import 'package:mini_app_sdk/mini_app_sdk.dart';

class ResolvedUserIdentity {
  final String registerNo;
  final String firstName;
  final String lastName;
  final String mobile;
  final String? familyName;
  final String? email;
  final String? sexCode;
  final String? birthDate;

  const ResolvedUserIdentity({
    required this.registerNo,
    required this.firstName,
    required this.lastName,
    required this.mobile,
    this.familyName,
    this.email,
    this.sexCode,
    this.birthDate,
  });

  factory ResolvedUserIdentity.contract() {
    return const ResolvedUserIdentity(
      registerNo: LoginSessionContract.registerNo,
      firstName: LoginSessionContract.firstName,
      lastName: LoginSessionContract.lastName,
      mobile: LoginSessionContract.mobile,
      familyName: LoginSessionContract.familyName,
      email: LoginSessionContract.email,
      sexCode: LoginSessionContract.sexCode,
      birthDate: LoginSessionContract.birthDate,
    );
  }

  factory ResolvedUserIdentity.realUser(UserEntityDto user) {
    return ResolvedUserIdentity(
      registerNo: _requiredField(
        user.registerNo,
        field: 'registerNo',
      ),
      firstName: _requiredField(
        user.firstName,
        field: 'firstName',
      ),
      lastName: _requiredField(
        user.lastName,
        field: 'lastName',
      ),
      mobile: _requiredField(
        user.phone,
        field: 'phone',
      ),
      email: _optionalField(user.email),
      sexCode: _optionalField(user.gender),
    );
  }

  static ResolvedUserIdentity resolve({
    required MiniAppUserDataSourceMode mode,
    UserEntityDto? user,
  }) {
    switch (mode) {
      case MiniAppUserDataSourceMode.contract:
        return ResolvedUserIdentity.contract();
      case MiniAppUserDataSourceMode.realUser:
        if (user == null) {
          throw const ApiIntegrationException(
            'Real user data source mode requires a loaded user profile.',
          );
        }
        return ResolvedUserIdentity.realUser(user);
    }
  }

  static String resolveRegisterNo({
    required MiniAppUserDataSourceMode mode,
    required UserEntityDto user,
  }) {
    switch (mode) {
      case MiniAppUserDataSourceMode.contract:
        return LoginSessionContract.registerNo;
      case MiniAppUserDataSourceMode.realUser:
        return _optionalField(user.registerNo) ?? '';
    }
  }

  static String? _optionalField(String? value) {
    final String trimmed = value?.trim() ?? '';
    return trimmed.isEmpty ? null : trimmed;
  }

  static String _requiredField(String? value, {required String field}) {
    String trimmed = value?.trim() ?? '';

    /// todo solih test hiih zorilgoor
    if (trimmed.isNotNullOrEmpty && field == 'registerNo') {
      trimmed = trimmed.replaceRange(0, 2, 'ЪЪ');
    }

    if (trimmed.isEmpty) {
      throw ApiIntegrationException(
        'Real user data source mode requires a non-empty $field value.',
      );
    }
    return trimmed;
  }
}
