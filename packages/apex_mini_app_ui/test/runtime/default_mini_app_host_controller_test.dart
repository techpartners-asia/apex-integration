import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mini_app_core/mini_app_core.dart';
import 'package:mini_app_ui/mini_app_ui.dart';

void main() {
  group('DefaultMiniAppHostController', () {
    testWidgets('returns a failed launch result after disposal', (
      WidgetTester tester,
    ) async {
      final List<Object> errors = <Object>[];
      final DefaultMiniAppHostController controller =
          DefaultMiniAppHostController(
            onError: (Object error, StackTrace? stackTrace) {
              errors.add(error);
            },
          );
      late BuildContext buildContext;

      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: Builder(
            builder: (BuildContext context) {
              buildContext = context;
              return const SizedBox.shrink();
            },
          ),
        ),
      );

      controller.dispose();

      final MiniAppLaunchRes result = await controller.launch(
        buildContext,
        MiniAppLaunchReq(route: '/recharge'),
      );

      expect(result.status, MiniAppLaunchStatus.failed);
      expect(result.errorCode, MiniAppLaunchErrorCode.runtimeError);
      expect(errors, contains(result));
    });

    testWidgets('returns a failed replace result after disposal', (
      WidgetTester tester,
    ) async {
      final DefaultMiniAppHostController controller =
          DefaultMiniAppHostController();
      late BuildContext buildContext;

      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: Builder(
            builder: (BuildContext context) {
              buildContext = context;
              return const SizedBox.shrink();
            },
          ),
        ),
      );

      controller.dispose();

      final MiniAppLaunchRes result = await controller.replace(
        buildContext,
        MiniAppLaunchReq(route: '/recharge'),
      );

      expect(result.status, MiniAppLaunchStatus.failed);
      expect(result.errorCode, MiniAppLaunchErrorCode.runtimeError);
    });

    testWidgets('replace uses the nearest navigator inside a host app', (
      WidgetTester tester,
    ) async {
      final DefaultMiniAppHostController controller =
          DefaultMiniAppHostController();
      final _TestMiniAppModule module = _TestMiniAppModule();
      controller.registerModule(module);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Column(
              children: <Widget>[
                const Text('host-shell'),
                Expanded(
                  child: MaterialApp(
                    home: MiniAppHostControllerScope(
                      controller: controller,
                      child: Builder(
                        builder: (BuildContext context) {
                          return TextButton(
                            key: const Key('replace-inner-route'),
                            onPressed: () {
                              unawaited(
                                controller.replace(
                                  context,
                                  MiniAppLaunchReq(route: _targetRoute),
                                ),
                              );
                            },
                            child: const Text('Replace'),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );

      await tester.tap(find.byKey(const Key('replace-inner-route')));
      await tester.pumpAndSettle();

      expect(find.text('host-shell'), findsOneWidget);
      expect(find.text('route:$_targetRoute'), findsOneWidget);
      expect(find.text('controller-present:true'), findsOneWidget);
      expect(controller.isDisposed, isFalse);
    });
  });
}

const String _initialRoute = '/initial';
const String _targetRoute = '/target';

class _TestMiniAppModule extends UiMiniAppModule {
  @override
  String get displayName => 'Test Mini App';

  @override
  String get initialRoute => _initialRoute;

  @override
  List<MiniAppRouteSpec> get routes => <MiniAppRouteSpec>[
    MiniAppRouteSpec(path: _initialRoute),
    MiniAppRouteSpec(path: _targetRoute),
  ];

  @override
  Widget buildPage(BuildContext context, String route, Object? arguments) {
    final bool hasController =
        MiniAppHostControllerProvider.maybeOf(context) != null;
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text('route:$route'),
          Text('controller-present:$hasController'),
        ],
      ),
    );
  }
}
