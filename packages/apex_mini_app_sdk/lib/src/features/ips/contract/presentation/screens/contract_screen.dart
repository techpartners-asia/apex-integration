import 'package:flutter/material.dart';

import 'contract_setup_screen.dart';

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
