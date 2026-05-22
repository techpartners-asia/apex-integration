import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:apex_mini_app_sdk/apex_mini_app_sdk.dart';
import 'package:apex_mini_app_sdk/src/host/apex_mini_app_host_context.dart';

void main() {
  setUp(() {
    MiniAppHostControllerProvider.debugResetActiveControllers();
    ApexMiniAppHostContext.activeController = null;
    ApexMiniAppHostContext.bind(
      nextCallbacks: ApexMiniAppHostCallbacks.empty,
    );
  });

  tearDown(() {
    MiniAppHostControllerProvider.debugResetActiveControllers();
    ApexMiniAppHostContext.activeController = null;
    ApexMiniAppHostContext.bind(
      nextCallbacks: ApexMiniAppHostCallbacks.empty,
    );
  });

  group('ApexMiniAppHostConfig', () {
    test('validates required token', () {
      const ApexMiniAppHostConfig config = ApexMiniAppHostConfig(token: '');

      final ApexMiniAppHostValidationResult validation = config.validate();

      expect(validation.isValid, isFalse);
      expect(validation.isMissingToken, isTrue);
      expect(
        validation.errors.single.code,
        ApexMiniAppHostParameterErrorCode.missingToken,
      );
    });

    test('validates route and URL overrides', () {
      const ApexMiniAppHostConfig config = ApexMiniAppHostConfig(
        token: 'host-token',
        baseUrl: 'ftp://example.test',
        initialRoute: '/unknown',
      );

      final ApexMiniAppHostValidationResult validation = config.validate();

      expect(validation.isValid, isFalse);
      expect(
        validation.errors.map((ApexMiniAppHostParameterError error) {
          return error.code;
        }),
        containsAll(<ApexMiniAppHostParameterErrorCode>[
          ApexMiniAppHostParameterErrorCode.invalidBaseUrl,
          ApexMiniAppHostParameterErrorCode.invalidInitialRoute,
        ]),
      );
    });

    test('uses entryRoute alias before initialRoute', () {
      const ApexMiniAppHostConfig config = ApexMiniAppHostConfig(
        token: 'host-token',
        entryRoute: MiniAppRoutes.overview,
        initialRoute: MiniAppRoutes.splash,
      );

      expect(config.initialRoute, MiniAppRoutes.overview);
    });

    test('compares equivalent host value objects as equal', () {
      final ApexMiniAppHostConfig first = ApexMiniAppHostConfig(
        token: 'host-token',
        initialRoute: MiniAppRoutes.overview,
        initialArguments: <String, Object?>{
          'screen': 'portfolio',
          'filters': <Object?>['active', 1],
        },
        user: const ApexMiniAppHostUser(
          id: 7,
          registerNo: 'AB99112233',
          firstName: 'Apex',
          lastName: 'Host',
          phone: '99112233',
          bank: ApexMiniAppHostBank(
            accountNumber: '123',
            accountName: 'Apex Host',
            bankId: '1',
            bankCode: '040000',
            bankName: 'Bank',
          ),
        ),
        session: const ApexMiniAppHostSession(
          accessToken: 'access-token',
          customerToken: 'customer-token',
          neSession: 'ne-session',
        ),
      );
      final ApexMiniAppHostConfig second = ApexMiniAppHostConfig(
        token: 'host-token',
        initialRoute: MiniAppRoutes.overview,
        initialArguments: <String, Object?>{
          'screen': 'portfolio',
          'filters': <Object?>['active', 1],
        },
        user: const ApexMiniAppHostUser(
          id: 7,
          registerNo: 'AB99112233',
          firstName: 'Apex',
          lastName: 'Host',
          phone: '99112233',
          bank: ApexMiniAppHostBank(
            accountNumber: '123',
            accountName: 'Apex Host',
            bankId: '1',
            bankCode: '040000',
            bankName: 'Bank',
          ),
        ),
        session: const ApexMiniAppHostSession(
          accessToken: 'access-token',
          customerToken: 'customer-token',
          neSession: 'ne-session',
        ),
      );

      expect(first, second);
      expect(first.hashCode, second.hashCode);
    });
  });

  group('MiniAppSdkConfig.fromHostConfig', () {
    test('maps host config into SDK config', () async {
      final MiniAppSdkConfig sdkConfig = MiniAppSdkConfig.fromHostConfig(
        hostConfig: const ApexMiniAppHostConfig(
          token: ' host-token ',
          devMode: true,
          baseUrl: 'https://example.test',
          initialRoute: MiniAppRoutes.overview,
          session: ApexMiniAppHostSession(accessToken: 'session-token'),
        ),
        walletPaymentHandler: (_) async {
          return MiniAppPaymentRes.success(
            req: MiniAppPaymentReq(
              flow: MiniAppPaymentFlow.ipsRecharge,
              invoiceId: '',
              amount: 0,
              note: '',
              paymentRecordId: 0,
              isTransaction: true,
            ),
          );
        },
      );

      expect(sdkConfig.userToken, 'host-token');
      expect(sdkConfig.devMode, isTrue);
      expect(sdkConfig.baseUrl, 'https://example.test');
      expect(sdkConfig.initialRoute, MiniAppRoutes.overview);
      expect(sdkConfig.hostSession?.accessToken, 'session-token');
    });

    test(
      'maps locale to runtime language when language is not provided',
      () async {
        final MiniAppSdkConfig sdkConfig = MiniAppSdkConfig.fromHostConfig(
          hostConfig: const ApexMiniAppHostConfig(
            token: 'host-token',
            locale: Locale('en'),
          ),
          walletPaymentHandler: (_) async {
            return MiniAppPaymentRes.success(
              req: MiniAppPaymentReq(
                flow: MiniAppPaymentFlow.ipsRecharge,
                invoiceId: '',
                amount: 0,
                note: '',
                paymentRecordId: 0,
                isTransaction: true,
              ),
            );
          },
        );

        expect(sdkConfig.language, 'EN');
      },
    );

    test(
      'disposing retired runtime does not clear current active controller',
      () {
        final MiniAppSdk first = MiniAppSdk(config: _sdkConfig('first-token'));
        final MiniAppHostController firstController = first.runtime.controller;
        final MiniAppSdk second = MiniAppSdk(
          config: _sdkConfig('second-token'),
        );
        final MiniAppHostController secondController =
            second.runtime.controller;

        expect(ApexMiniAppHostContext.activeController, same(secondController));

        first.dispose();

        expect(ApexMiniAppHostContext.activeController, same(secondController));
        expect(_isDisposed(firstController), isTrue);
        expect(_isDisposed(secondController), isFalse);

        second.dispose();

        expect(ApexMiniAppHostContext.activeController, isNull);
      },
    );
  });

  group('ApexMiniAppSdk widget', () {
    testWidgets(
      'accepts Zahii-style close callback and reports missing token',
      (
        WidgetTester tester,
      ) async {
        Object? reportedError;
        bool closed = false;

        await tester.pumpWidget(
          ApexMiniAppSdk(
            token: '',
            walletPaymentHandler: (_) async {
              return MiniAppPaymentRes.success(
                req: MiniAppPaymentReq(
                  flow: MiniAppPaymentFlow.ipsRecharge,
                  invoiceId: '',
                  amount: 0,
                  note: '',
                  paymentRecordId: 0,
                  isTransaction: true,
                ),
              );
            },
            onClose: () {
              closed = true;
            },
            onError: (Object error, StackTrace? stackTrace) {
              reportedError = error;
            },
          ),
        );

        expect(reportedError, isA<ApexMiniAppHostParameterException>());
        expect(find.text('Missing token'), findsOneWidget);

        await tester.pumpWidget(const SizedBox.shrink());
        await tester.pump(const Duration(milliseconds: 150));

        expect(closed, isTrue);
      },
    );

    testWidgets('wraps initial page with a usable controller provider', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        ApexMiniAppSdk(
          token: 'host-token',
          initialRoute: MiniAppRoutes.reward,
          walletPaymentHandler: (_) async {
            return MiniAppPaymentRes.success(
              req: MiniAppPaymentReq(
                flow: MiniAppPaymentFlow.ipsRecharge,
                invoiceId: '',
                amount: 0,
                note: '',
                paymentRecordId: 0,
                isTransaction: true,
              ),
            );
          },
        ),
      );
      await tester.pump();

      final MiniAppHostController? activeController =
          ApexMiniAppHostContext.activeController;

      expect(activeController, isNotNull);
      expect(_isDisposed(activeController), isFalse);
      expect(MiniAppHostControllerProvider.debugActiveControllerCount, 1);

      await tester.pumpWidget(const SizedBox.shrink());
      await tester.pump(const Duration(milliseconds: 150));
    });

    testWidgets('safe close shows mini app error dialog before host close', (
      WidgetTester tester,
    ) async {
      var closeCount = 0;

      await tester.pumpWidget(
        ApexMiniAppSdk(
          token: 'host-token',
          locale: const Locale('mn'),
          initialRoute: MiniAppRoutes.reward,
          walletPaymentHandler: _walletPaymentHandler,
          onClose: () {
            closeCount += 1;
          },
        ),
      );
      await tester.pump();

      final BuildContext miniAppContext = tester.element(
        find.byType(MiniAppHostShell),
      );

      final Future<void> closeFuture = ApexMiniAppHostContext.requestClose(
        context: miniAppContext,
      );
      await _pumpDialog(tester);

      expect(find.text('Алдаа гарлаа'), findsOneWidget);
      expect(find.text('Санамсаргүй алдаа гарлаа.'), findsOneWidget);
      expect(closeCount, 0);

      await _tapCloseAndWait(tester, closeFuture);
      expect(closeCount, 1);
      expect(find.text('Алдаа гарлаа'), findsNothing);
      expect(find.text('Санамсаргүй алдаа гарлаа.'), findsNothing);

      await tester.pumpWidget(const SizedBox.shrink());
    });

    testWidgets('safe close dismisses existing overlays after dialog OK', (
      WidgetTester tester,
    ) async {
      var closeCount = 0;

      await tester.pumpWidget(
        ApexMiniAppSdk(
          token: 'host-token',
          locale: const Locale('mn'),
          initialRoute: MiniAppRoutes.reward,
          walletPaymentHandler: _walletPaymentHandler,
          onClose: () {
            closeCount += 1;
          },
        ),
      );
      await tester.pump();

      final BuildContext miniAppContext = tester.element(
        find.byType(MiniAppHostShell),
      );
      unawaited(
        showMiniAppDialog<void>(
          context: miniAppContext,
          barrierDismissible: false,
          title: 'Backend dialog',
          body: const Text('Startup failed'),
        ),
      );
      await _pumpDialog(tester);

      expect(find.text('Backend dialog'), findsOneWidget);
      expect(find.text('Startup failed'), findsOneWidget);

      final Future<void> closeFuture = ApexMiniAppHostContext.requestClose(
        context: miniAppContext,
      );
      await _pumpDialog(tester);

      expect(find.text('Алдаа гарлаа'), findsOneWidget);
      expect(closeCount, 0);

      await _tapCloseAndWait(tester, closeFuture);
      expect(closeCount, 1);
      expect(find.text('Алдаа гарлаа'), findsNothing);
      expect(find.text('Backend dialog'), findsNothing);
      expect(find.text('Startup failed'), findsNothing);

      await tester.pumpWidget(const SizedBox.shrink());
    });

    testWidgets('safe close ignores duplicate close requests', (
      WidgetTester tester,
    ) async {
      var closeCount = 0;

      await tester.pumpWidget(
        ApexMiniAppSdk(
          token: 'host-token',
          locale: const Locale('mn'),
          initialRoute: MiniAppRoutes.reward,
          walletPaymentHandler: _walletPaymentHandler,
          onClose: () {
            closeCount += 1;
          },
        ),
      );
      await tester.pump();

      final BuildContext miniAppContext = tester.element(
        find.byType(MiniAppHostShell),
      );

      final Future<void> closeFuture = Future.wait<void>(<Future<void>>[
        ApexMiniAppHostContext.requestClose(context: miniAppContext),
        ApexMiniAppHostContext.requestClose(context: miniAppContext),
      ]);
      await _pumpDialog(tester);

      expect(find.text('Алдаа гарлаа'), findsOneWidget);
      expect(closeCount, 0);

      await _tapCloseAndWait(tester, closeFuture);
      expect(closeCount, 1);

      await tester.pumpWidget(const SizedBox.shrink());
    });

    testWidgets('request close without context bypasses error dialog', (
      WidgetTester tester,
    ) async {
      var closeCount = 0;

      await tester.pumpWidget(
        ApexMiniAppSdk(
          token: 'host-token',
          locale: const Locale('mn'),
          initialRoute: MiniAppRoutes.reward,
          walletPaymentHandler: _walletPaymentHandler,
          onClose: () {
            closeCount += 1;
          },
        ),
      );
      await tester.pump();

      final Future<void> closeFuture = ApexMiniAppHostContext.requestClose();
      await _finishCloseWithoutDialog(tester, closeFuture);

      expect(find.text('Алдаа гарлаа'), findsNothing);
      expect(closeCount, 1);

      await tester.pumpWidget(const SizedBox.shrink());
    });

    testWidgets('request close with unmounted context bypasses error dialog', (
      WidgetTester tester,
    ) async {
      var closeCount = 0;
      var showProbe = true;
      BuildContext? staleContext;

      Widget buildSdk() {
        return ApexMiniAppSdk(
          token: 'host-token',
          locale: const Locale('mn'),
          initialRoute: MiniAppRoutes.reward,
          walletPaymentHandler: _walletPaymentHandler,
          builder: (BuildContext context, Widget? child) => Stack(
            children: <Widget>[
              child ?? const SizedBox.shrink(),
              if (showProbe)
                Builder(
                  builder: (BuildContext context) {
                    staleContext = context;
                    return const SizedBox.shrink();
                  },
                ),
            ],
          ),
          onClose: () {
            closeCount += 1;
          },
        );
      }

      await tester.pumpWidget(buildSdk());
      await tester.pump();
      expect(staleContext, isNotNull);
      expect(staleContext!.mounted, isTrue);

      showProbe = false;
      await tester.pumpWidget(buildSdk());
      await tester.pump();
      expect(staleContext!.mounted, isFalse);

      final Future<void> closeFuture = ApexMiniAppHostContext.requestClose(
        context: staleContext,
      );
      await _finishCloseWithoutDialog(tester, closeFuture);

      expect(find.text('Алдаа гарлаа'), findsNothing);
      expect(closeCount, 1);

      await tester.pumpWidget(const SizedBox.shrink());
    });

    testWidgets('runtime recreation preserves close handler', (
      WidgetTester tester,
    ) async {
      var firstCloseCount = 0;
      var secondCloseCount = 0;

      await tester.pumpWidget(
        ApexMiniAppSdk(
          token: 'host-token',
          locale: const Locale('mn'),
          initialRoute: MiniAppRoutes.reward,
          walletPaymentHandler: _walletPaymentHandler,
          onClose: () {
            firstCloseCount += 1;
          },
        ),
      );
      await tester.pump();

      await tester.pumpWidget(
        ApexMiniAppSdk(
          token: 'new-host-token',
          locale: const Locale('mn'),
          initialRoute: MiniAppRoutes.reward,
          walletPaymentHandler: _walletPaymentHandler,
          onClose: () {
            secondCloseCount += 1;
          },
        ),
      );
      await tester.pump();

      final BuildContext miniAppContext = tester.element(
        find.byType(MiniAppHostShell),
      );

      final Future<void> closeFuture = ApexMiniAppHostContext.requestClose(
        context: miniAppContext,
      );
      await _pumpDialog(tester);
      await _tapCloseAndWait(tester, closeFuture);

      expect(firstCloseCount, 0);
      expect(secondCloseCount, 1);

      await tester.pumpWidget(const SizedBox.shrink());
    });
  });
}

Future<void> _pumpDialog(WidgetTester tester) async {
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 250));
}

Future<void> _tapCloseAndWait(
  WidgetTester tester,
  Future<void> closeFuture,
) async {
  await tester.tap(find.text('Хаах').last);
  await tester.pump();
  await tester.pump(const Duration(seconds: 2));
  await closeFuture;
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 250));
}

Future<void> _finishCloseWithoutDialog(
  WidgetTester tester,
  Future<void> closeFuture,
) async {
  await tester.pump();
  await tester.pump(const Duration(seconds: 2));
  await closeFuture;
}

Future<MiniAppPaymentRes> _walletPaymentHandler(
  MiniAppPaymentReq request,
) async {
  return MiniAppPaymentRes.success(req: request);
}

MiniAppSdkConfig _sdkConfig(String token) {
  return MiniAppSdkConfig(
    userToken: token,
    walletPaymentHandler: (_) async {
      return MiniAppPaymentRes.success(
        req: MiniAppPaymentReq(
          flow: MiniAppPaymentFlow.ipsRecharge,
          invoiceId: '',
          amount: 0,
          note: '',
          paymentRecordId: 0,
          isTransaction: true,
        ),
      );
    },
  );
}

bool _isDisposed(MiniAppHostController? controller) {
  final Object? candidate = controller;
  return candidate is MiniAppHostControllerLifecycle && candidate.isDisposed;
}
