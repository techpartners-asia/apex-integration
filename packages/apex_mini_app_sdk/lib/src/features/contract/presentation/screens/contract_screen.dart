import 'package:flutter/material.dart';
import 'package:mini_app_sdk/mini_app_sdk.dart';

class ContractScreen extends StatelessWidget {
  const ContractScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Navigator(
      onGenerateRoute: (_) =>
          MaterialPageRoute<void>(builder: (_) => const ContractSetupScreen()),
    );
  }
}
