import 'package:flutter_test/flutter_test.dart';
import 'package:mini_app_sdk/mini_app_sdk.dart';

void main() {
  group('GetLoginSessionApiReqFactory.build', () {
    test('uses LoginSessionContract values in contract mode', () {
      final req = GetLoginSessionApiReqFactory.build(
        admSession: 'adm-session',
        userDataSourceMode: MiniAppUserDataSourceMode.realUser,
      );

      expect(req.admSession, 'adm-session');
      expect(req.registerNo, LoginSessionContract.registerNo);
      expect(req.firstName, LoginSessionContract.firstName);
      expect(req.lastName, LoginSessionContract.lastName);
      expect(req.mobile, LoginSessionContract.mobile);
      expect(req.familyName, LoginSessionContract.familyName);
      expect(req.email, LoginSessionContract.email);
      expect(req.sexCode, LoginSessionContract.sexCode);
      expect(req.birthDate, LoginSessionContract.birthDate);
    });

    test('uses real user values in realUser mode', () {
      final req = GetLoginSessionApiReqFactory.build(
        admSession: 'adm-session',
        userDataSourceMode: MiniAppUserDataSourceMode.realUser,
        user: UserEntityDto(
          registerNo: 'AB12345678',
          firstName: 'Bold',
          lastName: 'Baatar',
          phone: '88993076',
          email: 'bold@example.com',
          gender: 'M',
        ),
      );

      expect(req.registerNo, 'AB12345678');
      expect(req.firstName, 'Bold');
      expect(req.lastName, 'Baatar');
      expect(req.mobile, '88993076');
      expect(req.familyName, isNull);
      expect(req.email, 'bold@example.com');
      expect(req.sexCode, 'M');
      expect(req.birthDate, isNull);
    });

    test('throws when realUser mode is missing required fields', () {
      expect(
        () => GetLoginSessionApiReqFactory.build(
          admSession: 'adm-session',
          userDataSourceMode: MiniAppUserDataSourceMode.realUser,
          user: UserEntityDto(
            registerNo: 'AB12345678',
            firstName: 'Bold',
            lastName: 'Baatar',
          ),
        ),
        throwsA(isA<ApiIntegrationException>()),
      );
    });
  });
}
