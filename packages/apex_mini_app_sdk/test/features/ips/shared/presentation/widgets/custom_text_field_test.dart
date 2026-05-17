import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mini_app_sdk/mini_app_sdk.dart';

import '../../../../../test_helpers/widget_test_app.dart';

void main() {
  testWidgets('CustomTextField keeps label visible when hint is provided', (
    WidgetTester tester,
  ) async {
    final TextEditingController controller = TextEditingController();
    addTearDown(controller.dispose);

    await tester.pumpWidget(
      buildSdkTestApp(
        Material(
          child: CustomTextField(
            label: 'Утас',
            hintText: 'Утасны дугаар оруулна уу',
            controller: controller,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Утас'), findsOneWidget);
    expect(find.text('Утасны дугаар оруулна уу'), findsOneWidget);

    final Text label = tester.widget<Text>(find.text('Утас'));
    expect(label.style?.color, isNull);
    expect(
      DefaultTextStyle.of(tester.element(find.text('Утас'))).style.color,
      DesignTokens.ink,
    );
  });

  testWidgets('CustomTextField disabled label remains readable', (
    WidgetTester tester,
  ) async {
    final TextEditingController controller = TextEditingController();
    addTearDown(controller.dispose);

    await tester.pumpWidget(
      buildSdkTestApp(
        Material(
          child: CustomTextField(
            label: 'Имэйл',
            hintText: 'example@mail.com',
            controller: controller,
            enabled: false,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Имэйл'), findsOneWidget);
    expect(
      DefaultTextStyle.of(tester.element(find.text('Имэйл'))).style.color,
      const Color(0xFF9AA0AA),
    );
  });

  testWidgets('CustomTextField opts out of host input decoration styling', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      buildSdkTestApp(
        Theme(
          data: ThemeData(
            useMaterial3: true,
            inputDecorationTheme: const InputDecorationTheme(
              filled: true,
              fillColor: Colors.white,
              contentPadding: EdgeInsets.fromLTRB(36, 28, 36, 28),
              hintStyle: TextStyle(color: Colors.white),
              prefixStyle: TextStyle(color: Colors.white),
            ),
            textTheme: const TextTheme(
              bodyMedium: TextStyle(
                color: Colors.white,
                fontSize: 36,
                height: 3,
              ),
            ),
          ),
          child: const DefaultTextStyle(
            style: TextStyle(color: Colors.white, fontSize: 36, height: 3),
            child: Material(
              child: _HostileThemeTextFieldHarness(),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Утасны дугаар'), findsOneWidget);
    expect(find.text('9911 2725'), findsOneWidget);
    expect(
      DefaultTextStyle.of(
        tester.element(find.text('Утасны дугаар')),
      ).style.color,
      DesignTokens.ink,
    );

    final TextField textField = tester.widget<TextField>(
      find.byType(TextField),
    );
    expect(textField.controller?.text, '9911 2725');
    expect(textField.style?.color, DesignTokens.ink);
    expect(textField.decoration?.filled, isFalse);
    expect(textField.decoration?.fillColor, Colors.transparent);
    expect(textField.decoration?.contentPadding, EdgeInsets.zero);
    expect(textField.decoration?.prefixStyle?.color, DesignTokens.ink);
    expect(textField.textAlignVertical, TextAlignVertical.center);
  });

  testWidgets('BankSelectorField shows both bank label and placeholder', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      buildSdkTestApp(
        Material(
          child: BankSelectorField(
            label: 'Банк',
            value: 'Сонгох',
            hasValue: false,
            onTap: () {},
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Банк'), findsOneWidget);
    expect(find.text('Сонгох'), findsOneWidget);
    expect(
      DefaultTextStyle.of(tester.element(find.text('Банк'))).style.color,
      DesignTokens.ink,
    );
  });

  testWidgets('BankSelectorField error state keeps label and error readable', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      buildSdkTestApp(
        Material(
          child: BankSelectorField(
            label: 'Банк',
            value: 'Сонгох',
            hasValue: false,
            errorText: 'Банк сонгоно уу',
            onTap: () {},
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Банк'), findsOneWidget);
    expect(find.text('Сонгох'), findsOneWidget);
    expect(find.text('Банк сонгоно уу'), findsOneWidget);
    expect(
      DefaultTextStyle.of(tester.element(find.text('Банк'))).style.color,
      DesignTokens.danger,
    );
  });
}

class _HostileThemeTextFieldHarness extends StatefulWidget {
  const _HostileThemeTextFieldHarness();

  @override
  State<_HostileThemeTextFieldHarness> createState() =>
      _HostileThemeTextFieldHarnessState();
}

class _HostileThemeTextFieldHarnessState
    extends State<_HostileThemeTextFieldHarness> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: '9911 2725');
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomTextField(
      label: 'Утасны дугаар',
      controller: _controller,
    );
  }
}
