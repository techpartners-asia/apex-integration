import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../../app/investx_api/backend/mini_app_api_repository.dart';
import '../../../../../app/investx_api/dto/user_entity_dto.dart';

import '../../../shared/domain/models/ips_models.dart';
import '../../application/sec_acnt_bank_account_lookup_repository.dart';
import '../../application/sec_acnt_bank_options_repository.dart';
import '../flow/sec_acnt_flow.dart';
import 'sec_acnt_consent_screen.dart';
import 'sec_acnt_payment_screen.dart';

class SecAcntScreen extends StatelessWidget {
  final AcntBootstrapState? initialBootstrapState;
  final SecAcntBankOptionsRepository bankOptionsRepository;
  final SecAcntBankAccountLookupRepository bankAccountLookupRepository;
  final MiniAppApiRepository appApi;
  final UserEntityDto? currentUser;

  const SecAcntScreen({
    super.key,
    this.initialBootstrapState,
    required this.bankOptionsRepository,
    required this.bankAccountLookupRepository,
    required this.appApi,
    required this.currentUser,
  });

  Widget _buildInitialScreen() {
    final SecAcntFlowDraft initialDraft = SecAcntFlowDraft.fromBootstrap(
      initialBootstrapState,
      user: currentUser,
    );

    return switch (resolveInitialSecAcntFlowStep(initialBootstrapState)) {
      SecAcntFlowStep.payment => SecAcntPaymentScreen(
        bootstrapState: initialBootstrapState,
        draft: initialDraft,
        isInitialStep: true,
      ),
      _ => SecAcntConsentScreen(
        bootstrapState: initialBootstrapState,
        bankOptionsRepository: bankOptionsRepository,
        bankAccountLookupRepository: bankAccountLookupRepository,
        appApi: appApi,
        currentUser: currentUser,
        initialDraft: initialDraft,
      ),
    };
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Navigator(
        onGenerateRoute: (_) =>
            MaterialPageRoute<void>(builder: (_) => _buildInitialScreen()),
      ),
    );
  }
}
