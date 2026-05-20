import 'package:apex_mini_app_sdk/apex_mini_app_sdk.dart';
import 'package:flutter/material.dart';

/// Entry point for the questionnaire nested flow.
class QuestionnaireScreen extends StatelessWidget {
  /// Creates the questionnaire flow screen.
  const QuestionnaireScreen({super.key, required this.signatureUploadService});

  /// Signature upload service shared by the signature step.
  final SignatureUploadService signatureUploadService;

  @override
  Widget build(BuildContext context) {
    return Navigator(
      onGenerateRoute: (_) => MaterialPageRoute<void>(
        builder: (_) => QuestionnaireAgreementScreen(
          signatureUploadService: signatureUploadService,
        ),
      ),
    );
  }
}
