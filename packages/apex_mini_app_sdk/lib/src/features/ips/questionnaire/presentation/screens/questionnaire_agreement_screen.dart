import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mini_app_ui/mini_app_ui.dart';

import '../../../../../shared/l10n/sdk_localizations_x.dart';
import '../../../shared/application/investx_signature_upload_service.dart';
import '../../../shared/presentation/screens/investx_agreement_screen.dart';
import '../../../shared/presentation/widgets/widgets.dart';
import '../../application/ips_questionnaire_cubit.dart';
import '../../application/ips_questionnaire_state.dart';
import 'questionnaire_signature_screen.dart';

class QuestionnaireAgreementScreen extends StatefulWidget {
  const QuestionnaireAgreementScreen({
    super.key,
    required this.signatureUploadService,
  });

  final InvestXSignatureUploadService signatureUploadService;

  @override
  State<QuestionnaireAgreementScreen> createState() =>
      _QuestionnaireAgreementScreenState();
}

class _QuestionnaireAgreementScreenState
    extends State<QuestionnaireAgreementScreen> {
  bool _accepted = false;

  void _openNextStep() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => QuestionnaireSignatureScreen(
          signatureUploadService: widget.signatureUploadService,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return BlocBuilder<IpsQuestionnaireCubit, IpsQuestionnaireState>(
      builder: (BuildContext context, IpsQuestionnaireState state) {
        if (state.bootstrapState == null && state.errorMessage != null) {
          return InvestXPageScaffold(
            appBarTitle: l10n.ipsContractTitle,
            showCloseButton: false,
            showBackButton: true,
            onBack: () => Navigator.of(context, rootNavigator: true).maybePop(),
            backgroundColor: InvestXDesignTokens.softSurface,
            appBarBackgroundColor: InvestXDesignTokens.softSurface,
            appBarShowBottomBorder: false,
            body: Center(
              child: Padding(
                padding: EdgeInsets.all(AppSpacing.xl),
                child: MiniAppErrorState(
                  title: l10n.errorsActionFailed,
                  message: state.errorMessage!,
                  retryLabel: l10n.commonRetry,
                  onRetry: context.read<IpsQuestionnaireCubit>().load,
                ),
              ),
            ),
          );
        }

        return InvestXAgreementScreen(
          appBarTitle: l10n.ipsContractTitle,
          title: l10n.secAcntInvestxAgreementTitle,
          body: InvestXAgreementHtmlBody(
            agreementText:
                state.bootstrapState?.introIps ??
                l10n.secAcntInvestxAgreementText,
          ),
          consentLabel: l10n.secAcntAgreementConsent,
          accepted: _accepted,
          onAcceptedChanged: (bool value) => setState(() => _accepted = value),
          continueLabel: l10n.commonContinue,
          onContinue: _openNextStep,
          onBack: () => Navigator.of(context, rootNavigator: true).maybePop(),
          overlay: state.isLoading
              ? InvestXBlockingLoadingOverlay(
                  title: l10n.commonLoading,
                  message: l10n.ipsBootstrapLoading,
                )
              : null,
        );
      },
    );
  }
}
