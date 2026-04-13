import 'package:flutter/material.dart';

import '../../../shared/application/investx_signature_upload_service.dart';
import 'questionnaire_agreement_screen.dart';

class QuestionnaireScreen extends StatelessWidget {
  const QuestionnaireScreen({super.key, required this.signatureUploadService});

  final InvestXSignatureUploadService signatureUploadService;

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
