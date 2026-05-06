import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mini_app_ui/mini_app_ui.dart';
import 'package:mini_app_sdk/mini_app_sdk.dart';

class QuestionnaireAgreementScreen extends StatefulWidget {
  const QuestionnaireAgreementScreen({
    super.key,
    required this.signatureUploadService,
  });

  final SignatureUploadService signatureUploadService;

  @override
  State<QuestionnaireAgreementScreen> createState() => _QuestionnaireAgreementScreenState();
}

class _QuestionnaireAgreementScreenState extends State<QuestionnaireAgreementScreen> {
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
            agreementText: state.bootstrapState?.introIps ?? l10n.secAcntInvestxAgreementText,
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
