import 'package:apex_mini_app_sdk/apex_mini_app_sdk.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  tearDown(StaticApiConfig.resetForTesting);

  test('defaults to legacy development fallback before SDK setup', () {
    StaticApiConfig.resetForTesting();

    expect(StaticApiConfig.devMode, isTrue);
    expect(StaticApiConfig.defaultSrcFiCode, '181');
    expect(StaticApiConfig.defaultFiCode, '181');
  });

  test('uses production values when devMode is false', () {
    StaticApiConfig.configure(devMode: false);

    expect(StaticApiConfig.techInvestXUrl, 'https://api.admin.investx.mn');
    expect(
      StaticApiConfig.loginSessionBaseUrl,
      'https://customer.mostmoney.mn:9094',
    );
    expect(StaticApiConfig.ipsApiBaseUrl, 'https://customer.mostmoney.mn:9094');
    expect(StaticApiConfig.appId, '114');
    expect(StaticApiConfig.appSecret, 'APEXTINO');
    expect(StaticApiConfig.neSession, 'P0JmbkwsVmQX1nbZ63d0lJnY3YJSp0');
    expect(StaticApiConfig.defaultSrcFiCode, '78');
    expect(StaticApiConfig.defaultFiCode, '78');
    expect(
      StaticApiConfig.techInvestXStorageUrl,
      'https://storage.admin.investx.mn/',
    );
  });

  test('uses legacy development values when devMode is true', () {
    StaticApiConfig.configure(devMode: true);

    expect(StaticApiConfig.techInvestXUrl, 'http://192.168.88.120:7001');
    expect(StaticApiConfig.loginSessionBaseUrl, 'http://202.21.105.150:40654');
    expect(StaticApiConfig.ipsApiBaseUrl, 'http://202.21.105.150:40651');
    expect(StaticApiConfig.appId, '156');
    expect(StaticApiConfig.appSecret, 'APEXTINO');
    expect(StaticApiConfig.neSession, 'v4omE7WQDotmIpzZvtN2OXgR302rxS');
    expect(StaticApiConfig.defaultSrcFiCode, '181');
    expect(StaticApiConfig.defaultFiCode, '181');
    expect(
      StaticApiConfig.techInvestXStorageUrl,
      'http://192.168.88.120:9002/',
    );
  });

  test('runtime config resolves environment defaults from devMode', () {
    final SdkRuntimeConfig production = SdkRuntimeConfig.fromConfig(
      devMode: false,
    );
    final SdkRuntimeConfig development = SdkRuntimeConfig.fromConfig(
      devMode: true,
    );

    expect(production.techInvestXUrl, StaticApiConfig.productionTechInvestXUrl);
    expect(
      production.loginSessionBaseUrl,
      StaticApiConfig.productionLoginSessionBaseUrl,
    );
    expect(production.ipsApiBaseUrl, StaticApiConfig.productionIpsApiBaseUrl);
    expect(production.credentials.appId, StaticApiConfig.productionAppId);
    expect(production.neSession, StaticApiConfig.productionNeSession);
    expect(
      production.defaultSrcFiCode,
      StaticApiConfig.productionDefaultSrcFiCode,
    );
    expect(production.defaultFiCode, StaticApiConfig.productionDefaultFiCode);

    expect(development.techInvestXUrl, StaticApiConfig.devTechInvestXUrl);
    expect(
      development.loginSessionBaseUrl,
      StaticApiConfig.devLoginSessionBaseUrl,
    );
    expect(development.ipsApiBaseUrl, StaticApiConfig.devIpsApiBaseUrl);
    expect(development.credentials.appId, StaticApiConfig.devAppId);
    expect(development.neSession, StaticApiConfig.devNeSession);
    expect(development.defaultSrcFiCode, StaticApiConfig.devDefaultSrcFiCode);
    expect(development.defaultFiCode, StaticApiConfig.devDefaultFiCode);
  });

  test('runtime config keeps explicit host overrides', () {
    final SdkRuntimeConfig runtime = SdkRuntimeConfig.fromConfig(
      devMode: false,
      techInvestXUrl: 'https://override.example.com',
      loginSessionBaseUrl: 'https://login.example.com',
      ipsApiBaseUrl: 'https://ips.example.com',
      appId: 'app',
      appSecret: 'secret',
      neSession: 'ne',
      defaultSrcFiCode: '123',
      defaultFiCode: '456',
    );

    expect(runtime.techInvestXUrl, 'https://override.example.com');
    expect(runtime.loginSessionBaseUrl, 'https://login.example.com');
    expect(runtime.ipsApiBaseUrl, 'https://ips.example.com');
    expect(runtime.credentials.appId, 'app');
    expect(runtime.credentials.appSecret, 'secret');
    expect(runtime.neSession, 'ne');
    expect(runtime.defaultSrcFiCode, '123');
    expect(runtime.defaultFiCode, '456');
  });
}
