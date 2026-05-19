import 'package:flutter/material.dart';
import 'package:apex_mini_app_sdk/apex_mini_app_sdk_internal.dart';

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
