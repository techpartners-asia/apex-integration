import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:apex_mini_app_sdk/apex_mini_app_sdk.dart';

/// Agreement step shown before questionnaire signature and questions.
class QuestionnaireAgreementScreen extends StatefulWidget {
  /// Creates the questionnaire agreement screen.
  const QuestionnaireAgreementScreen({
    super.key,
    required this.signatureUploadService,
  });

  /// Service passed to the following signature step.
  final SignatureUploadService signatureUploadService;

  @override
  State<QuestionnaireAgreementScreen> createState() =>
      _QuestionnaireAgreementScreenState();
}

/// Tracks agreement consent before opening the signature step.
class _QuestionnaireAgreementScreenState
    extends State<QuestionnaireAgreementScreen> {
  /// Whether the user has accepted the questionnaire agreement.
  bool _accepted = false;

  /// Opens the signature step after agreement consent.
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
          return CustomScaffold(
            appBarTitle: l10n.ipsContractTitle,
            showCloseButton: false,
            showBackButton: true,
            onBack: () => Navigator.of(context, rootNavigator: true).maybePop(),
            backgroundColor: DesignTokens.softSurface,
            appBarBackgroundColor: DesignTokens.softSurface,
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

        return AgreementScreen(
          appBarTitle: l10n.ipsContractTitle,
          title: l10n.secAcntInvestxAgreementTitle,
          body: AgreementHtmlBody(
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
              ? BlockingLoadingOverlay(
                  title: l10n.commonLoading,
                  message: l10n.ipsBootstrapLoading,
                )
              : null,
        );
      },
    );
  }
}
