import 'package:flutter/material.dart';
import 'package:mini_app_sdk/mini_app_sdk.dart';

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
