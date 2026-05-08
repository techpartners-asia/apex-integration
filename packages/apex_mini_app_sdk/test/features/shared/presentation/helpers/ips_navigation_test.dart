import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mini_app_core/mini_app_core.dart';
import 'package:mini_app_sdk/mini_app_sdk.dart';
import 'package:mini_app_sdk/src/host/apex_mini_app_host_context.dart';
import 'package:mini_app_ui/mini_app_ui.dart';

import '../../../../test_helpers/widget_test_app.dart';

const String _overviewRoute = '/overview';
const String _rechargeRoute = '/recharge';

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

  group('launchIpsRoute', () {
    testWidgets('works when the current BuildContext has a provider', (
      WidgetTester tester,
    ) async {
      final DefaultMiniAppHostController controller =
          DefaultMiniAppHostController();
      final _TestMiniAppModule module = _TestMiniAppModule();
      controller.registerModule(module);

      await tester.pumpWidget(
        MaterialApp(
          home: MiniAppHostControllerProvider(
            controller: controller,
            child: Builder(
              builder: (BuildContext context) {
                return Scaffold(
                  body: TextButton(
                    key: const Key('provider-recharge'),
                    onPressed: () {
                      unawaited(launchIpsRoute(context, route: _rechargeRoute));
                    },
                    child: const Text('Recharge'),
                  ),
                );
              },
            ),
          ),
        ),
      );

      await tester.tap(find.byKey(const Key('provider-recharge')));
      await tester.pumpAndSettle();

      expect(find.text('route:$_rechargeRoute'), findsOneWidget);
      expect(find.text('controller-present:true'), findsOneWidget);
    });

    testWidgets(
      'tapping an overview button while the mini app is open launches the route',
      (WidgetTester tester) async {
        final DefaultMiniAppHostController controller =
            DefaultMiniAppHostController();
        final _TestMiniAppModule module = _TestMiniAppModule();
        controller.registerModule(module);

        await tester.pumpWidget(
          MaterialApp(
            home: MiniAppHostControllerScope(
              controller: controller,
              child: Builder(
                builder: (BuildContext context) {
                  return Scaffold(
                    body: TextButton(
                      key: const Key('overview-recharge'),
                      onPressed: () {
                        unawaited(
                          launchIpsRoute(context, route: _rechargeRoute),
                        );
                      },
                      child: const Text('Recharge'),
                    ),
                  );
                },
              ),
            ),
          ),
        );

        await tester.tap(find.byKey(const Key('overview-recharge')));
        await tester.pumpAndSettle();

        expect(find.text('route:$_rechargeRoute'), findsOneWidget);
        expect(find.text('controller-present:true'), findsOneWidget);
        expect(module.startedRoutes, contains(_rechargeRoute));
      },
    );

    testWidgets(
      'works when the mounted context has no provider but registry is active',
      (WidgetTester tester) async {
        final DefaultMiniAppHostController activeController =
            DefaultMiniAppHostController();
        final _TestMiniAppModule module = _TestMiniAppModule();
        activeController.registerModule(module);

        await tester.pumpWidget(
          MaterialApp(
            home: Column(
              children: <Widget>[
                MiniAppHostControllerScope(
                  controller: activeController,
                  child: const SizedBox(key: Key('active-scope')),
                ),
                Builder(
                  builder: (BuildContext context) {
                    return TextButton(
                      key: const Key('registry-recharge'),
                      onPressed: () {
                        unawaited(
                          launchIpsRoute(context, route: _rechargeRoute),
                        );
                      },
                      child: const Text('Recharge'),
                    );
                  },
                ),
              ],
            ),
          ),
        );

        await tester.tap(find.byKey(const Key('registry-recharge')));
        await tester.pumpAndSettle();

        expect(find.text('route:$_rechargeRoute'), findsOneWidget);
        expect(module.startedRoutes, contains(_rechargeRoute));
      },
    );

    testWidgets('uses SDK host fallback when registry is empty', (
      WidgetTester tester,
    ) async {
      final TestMiniAppHostController hostController =
          TestMiniAppHostController();
      ApexMiniAppHostContext.activeController = hostController;

      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (BuildContext context) {
              return TextButton(
                key: const Key('host-fallback-recharge'),
                onPressed: () {
                  unawaited(launchIpsRoute(context, route: _rechargeRoute));
                },
                child: const Text('Recharge'),
              );
            },
          ),
        ),
      );

      await tester.tap(find.byKey(const Key('host-fallback-recharge')));
      await tester.pump();

      expect(hostController.launchRequests, hasLength(1));
      expect(hostController.launchRequests.single.route, _rechargeRoute);
    });

    testWidgets('launches common IPS routes from a usable provider', (
      WidgetTester tester,
    ) async {
      final TestMiniAppHostController controller = TestMiniAppHostController();
      const List<String> routes = <String>[
        MiniAppRoutes.recharge,
        MiniAppRoutes.statements,
        MiniAppRoutes.portfolio,
        MiniAppRoutes.personalInfo,
        MiniAppRoutes.orders,
        MiniAppRoutes.help,
      ];

      await tester.pumpWidget(
        buildSdkTestApp(
          Builder(
            builder: (BuildContext context) {
              return Column(
                children: <Widget>[
                  for (final String route in routes)
                    TextButton(
                      key: Key('route-$route'),
                      onPressed: () {
                        unawaited(launchIpsRoute(context, route: route));
                      },
                      child: Text(route),
                    ),
                ],
              );
            },
          ),
          hostController: controller,
        ),
      );

      for (final String route in routes) {
        await tester.tap(find.byKey(Key('route-$route')));
        await tester.pump();
      }

      expect(
        controller.launchRequests.map((MiniAppLaunchReq req) => req.route),
        routes,
      );
    });

    testWidgets('uses the active controller instead of a disposed provider', (
      WidgetTester tester,
    ) async {
      final DefaultMiniAppHostController disposedController =
          DefaultMiniAppHostController()..dispose();
      final DefaultMiniAppHostController activeController =
          DefaultMiniAppHostController();
      final _TestMiniAppModule module = _TestMiniAppModule();
      activeController.registerModule(module);

      await tester.pumpWidget(
        MaterialApp(
          home: MiniAppHostControllerScope(
            controller: activeController,
            child: MiniAppHostControllerProvider(
              controller: disposedController,
              child: Builder(
                builder: (BuildContext context) {
                  return Scaffold(
                    body: TextButton(
                      key: const Key('stale-provider-recharge'),
                      onPressed: () {
                        unawaited(
                          launchIpsRoute(context, route: _rechargeRoute),
                        );
                      },
                      child: const Text('Recharge'),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.byKey(const Key('stale-provider-recharge')));
      await tester.pumpAndSettle();

      expect(find.text('route:$_rechargeRoute'), findsOneWidget);
      expect(module.startedRoutes, contains(_rechargeRoute));
    });

    testWidgets('missing provider and registry reports an error', (
      WidgetTester tester,
    ) async {
      Object? reportedError;
      ApexMiniAppHostContext.bind(
        nextCallbacks: ApexMiniAppHostCallbacks(
          onError: (Object error, StackTrace? stackTrace) {
            reportedError = error;
          },
        ),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (BuildContext context) {
              return TextButton(
                key: const Key('missing-provider-recharge'),
                onPressed: () {
                  unawaited(launchIpsRoute(context, route: _rechargeRoute));
                },
                child: const Text('Recharge'),
              );
            },
          ),
        ),
      );

      await tester.tap(find.byKey(const Key('missing-provider-recharge')));
      await tester.pump();

      expect(tester.takeException(), isNull);
      expect(
        reportedError,
        isA<MiniAppNavigationControllerMissingException>(),
      );
      expect(
        reportedError.toString(),
        contains('mini_app_navigation_controller_missing'),
      );
      expect(
        reportedError.toString(),
        contains('localControllerUsable: false'),
      );
      expect(reportedError.toString(), contains(_rechargeRoute));
    });

    testWidgets('disposed SDK fallback controller is not used', (
      WidgetTester tester,
    ) async {
      final DefaultMiniAppHostController disposedController =
          DefaultMiniAppHostController()..dispose();
      ApexMiniAppHostContext.activeController = disposedController;

      Object? reportedError;
      ApexMiniAppHostContext.bind(
        nextCallbacks: ApexMiniAppHostCallbacks(
          onError: (Object error, StackTrace? stackTrace) {
            reportedError = error;
          },
        ),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (BuildContext context) {
              return TextButton(
                key: const Key('disposed-host-recharge'),
                onPressed: () {
                  unawaited(launchIpsRoute(context, route: _rechargeRoute));
                },
                child: const Text('Recharge'),
              );
            },
          ),
        ),
      );

      await tester.tap(find.byKey(const Key('disposed-host-recharge')));
      await tester.pump();

      expect(tester.takeException(), isNull);
      expect(
        reportedError,
        isA<MiniAppNavigationControllerMissingException>(),
      );
      expect(
        reportedError.toString(),
        contains('hostControllerFound: false'),
      );
    });

    testWidgets('delayed callbacks do not use a disposed controller', (
      WidgetTester tester,
    ) async {
      final DefaultMiniAppHostController disposedController =
          DefaultMiniAppHostController()..dispose();
      final DefaultMiniAppHostController activeController =
          DefaultMiniAppHostController();
      final _TestMiniAppModule module = _TestMiniAppModule();
      activeController.registerModule(module);

      bool showStaleButton = true;
      late BuildContext staleContext;

      await tester.pumpWidget(
        MaterialApp(
          home: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return MiniAppHostControllerScope(
                controller: activeController,
                child: Scaffold(
                  body: Column(
                    children: <Widget>[
                      const SizedBox(key: Key('active-host-scope')),
                      if (showStaleButton)
                        MiniAppHostControllerProvider(
                          controller: disposedController,
                          child: Builder(
                            builder: (BuildContext context) {
                              staleContext = context;
                              return TextButton(
                                key: const Key('delayed-recharge'),
                                onPressed: () {
                                  Future<void>.delayed(Duration.zero, () {
                                    return launchIpsRoute(
                                      staleContext,
                                      route: _rechargeRoute,
                                    );
                                  });
                                  setState(() => showStaleButton = false);
                                },
                                child: const Text('Recharge'),
                              );
                            },
                          ),
                        ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      );

      await tester.tap(find.byKey(const Key('delayed-recharge')));
      await tester.pump();
      await tester.pump();
      await tester.pumpAndSettle();

      expect(find.text('route:$_rechargeRoute'), findsOneWidget);
      expect(module.startedRoutes, contains(_rechargeRoute));
    });

    testWidgets('OverviewProfileTab menu buttons launch routes', (
      WidgetTester tester,
    ) async {
      final TestMiniAppHostController controller = TestMiniAppHostController();

      await tester.pumpWidget(
        buildSdkTestApp(
          OverviewProfileTab(
            data: _bootstrapState(hasIpsAcnt: true),
            user: UserEntityDto(firstName: 'Apex', lastName: 'User'),
          ),
          hostController: controller,
        ),
      );
      await tester.pump();

      expect(
        await _tapProfileMenuItem(tester, 'Personal information'),
        isTrue,
      );
      expect(await _tapProfileMenuItem(tester, 'Statements'), isTrue);
      expect(await _tapProfileMenuItem(tester, 'Pack details'), isTrue);
      expect(await _tapProfileMenuItem(tester, 'Order list'), isTrue);
      expect(await _tapProfileMenuItem(tester, 'Support'), isTrue);

      expect(
        controller.launchRequests.map((MiniAppLaunchReq req) => req.route),
        <String>[
          MiniAppRoutes.personalInfo,
          MiniAppRoutes.statements,
          MiniAppRoutes.portfolio,
          MiniAppRoutes.orders,
          MiniAppRoutes.help,
        ],
      );
    });
  });

  group('replaceIpsRoute', () {
    testWidgets('uses the same active controller fallback behavior', (
      WidgetTester tester,
    ) async {
      final DefaultMiniAppHostController activeController =
          DefaultMiniAppHostController();
      final _TestMiniAppModule module = _TestMiniAppModule();
      activeController.registerModule(module);

      await tester.pumpWidget(
        MaterialApp(
          home: Column(
            children: <Widget>[
              MiniAppHostControllerScope(
                controller: activeController,
                child: const SizedBox(key: Key('active-scope')),
              ),
              Builder(
                builder: (BuildContext context) {
                  return TextButton(
                    key: const Key('registry-replace'),
                    onPressed: () {
                      unawaited(
                        replaceIpsRoute(context, route: _rechargeRoute),
                      );
                    },
                    child: const Text('Replace'),
                  );
                },
              ),
            ],
          ),
        ),
      );

      await tester.tap(find.byKey(const Key('registry-replace')));
      await tester.pumpAndSettle();

      expect(find.text('route:$_rechargeRoute'), findsOneWidget);
      expect(module.startedRoutes, contains(_rechargeRoute));
    });
  });

  group('MiniAppHostControllerScope', () {
    testWidgets('keeps active controller registered while mounted', (
      WidgetTester tester,
    ) async {
      final DefaultMiniAppHostController controller =
          DefaultMiniAppHostController();

      await tester.pumpWidget(
        MaterialApp(
          home: MiniAppHostControllerScope(
            controller: controller,
            child: const SizedBox.shrink(),
          ),
        ),
      );

      expect(MiniAppHostControllerProvider.debugActiveControllerCount, 1);

      await tester.pumpWidget(const SizedBox.shrink());
      await tester.pump();

      expect(MiniAppHostControllerProvider.debugActiveControllerCount, 0);
    });

    testWidgets('keeps active controller registered during parent rebuild', (
      WidgetTester tester,
    ) async {
      final DefaultMiniAppHostController controller =
          DefaultMiniAppHostController();
      late StateSetter rebuild;
      int version = 1;

      await tester.pumpWidget(
        MaterialApp(
          home: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              rebuild = setState;
              return MiniAppHostControllerScope(
                controller: controller,
                child: Text('version:$version'),
              );
            },
          ),
        ),
      );

      expect(MiniAppHostControllerProvider.debugActiveControllerCount, 1);
      expect(MiniAppHostControllerProvider.activeController, same(controller));

      rebuild(() {
        version = 2;
      });
      await tester.pump();

      expect(find.text('version:2'), findsOneWidget);
      expect(MiniAppHostControllerProvider.debugActiveControllerCount, 1);
      expect(MiniAppHostControllerProvider.activeController, same(controller));
    });
  });
}

class _TestMiniAppModule extends UiMiniAppModule {
  final List<String?> startedRoutes = <String?>[];

  @override
  String get displayName => 'Test Mini App';

  @override
  String get initialRoute => _overviewRoute;

  @override
  List<MiniAppRouteSpec> get routes => <MiniAppRouteSpec>[
    MiniAppRouteSpec(path: _overviewRoute),
    MiniAppRouteSpec(path: _rechargeRoute),
  ];

  @override
  void onLaunchStarted(MiniAppLaunchReq req) {
    startedRoutes.add(req.route);
  }

  @override
  Widget buildPage(BuildContext context, String route, Object? arguments) {
    final bool hasController =
        MiniAppHostControllerProvider.maybeOf(context) != null;
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text('route:$route'),
            Text('controller-present:$hasController'),
          ],
        ),
      ),
    );
  }
}

AcntBootstrapState _bootstrapState({required bool hasIpsAcnt}) {
  return AcntBootstrapState(
    response: GetSecuritiesAcntListResDto(
      detail: GetSecuritiesAcntListDetailDto(
        hasAcnt: true,
        hasIpsAcnt: hasIpsAcnt,
      ),
      acnts: const <GetSecAcntListAccountDto>[
        GetSecAcntListAccountDto(flag: 3, status: 1),
      ],
      stlAcnts: const <GetSecAcntSettlementAccountDto>[],
      responseCode: 0,
    ),
  );
}

Future<bool> _tapProfileMenuItem(WidgetTester tester, String text) async {
  final Finder finder = find.text(text);
  await tester.ensureVisible(finder);
  await tester.pump();
  await tester.tap(finder);
  await tester.pump();
  return finder.evaluate().isNotEmpty;
}
