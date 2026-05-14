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
