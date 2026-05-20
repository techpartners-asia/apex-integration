import 'package:apex_mini_app_sdk/apex_mini_app_sdk.dart';
import 'package:flutter/material.dart';

/// Nested navigator entry for the contract setup/payment flow.
class ContractScreen extends StatelessWidget {
  /// Creates the contract flow shell.
  const ContractScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Navigator(
      onGenerateRoute: (_) =>
          MaterialPageRoute<void>(builder: (_) => const ContractSetupScreen()),
    );
  }
}
