import 'package:apex_mini_app_sdk/apex_mini_app_sdk.dart';
import 'package:flutter/material.dart';

class QuestionnaireScreen extends StatelessWidget {
  const QuestionnaireScreen({super.key, required this.signatureUploadService});

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
