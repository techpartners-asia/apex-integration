import 'package:flutter/material.dart';
import 'package:apex_mini_app_sdk/apex_mini_app_sdk_internal.dart';

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
