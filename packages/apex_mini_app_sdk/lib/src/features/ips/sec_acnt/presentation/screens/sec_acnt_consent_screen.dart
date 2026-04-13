import 'package:flutter/material.dart';
import '../../../../../app/investx_api/backend/mini_app_api_repository.dart';
import '../../../../../app/investx_api/dto/user_entity_dto.dart';
import '../../../shared/images/images.dart';
import '../../../../../shared/l10n/sdk_localizations_x.dart';
import 'package:mini_app_ui/mini_app_ui.dart';

import '../../../shared/domain/models/ips_models.dart';
import '../../../shared/presentation/widgets/widgets.dart';
import '../../application/sec_acnt_bank_account_lookup_repository.dart';
import '../../application/sec_acnt_bank_options_repository.dart';
import '../flow/sec_acnt_flow.dart';
import '../flow/sec_acnt_wizard_config.dart';
import '../widgets/sec_acnt_step_indicator.dart';
import '../widgets/sec_acnt_wizard_widgets.dart';
import '../flow/sec_acnt_flow_navigation.dart';
import 'sec_acnt_personal_info_screen.dart';

class SecAcntConsentScreen extends StatelessWidget {
  final AcntBootstrapState? bootstrapState;
  final SecAcntBankOptionsRepository bankOptionsRepository;
  final SecAcntBankAccountLookupRepository bankAccountLookupRepository;
  final MiniAppApiRepository appApi;
  final UserEntityDto? currentUser;
  final SecAcntFlowDraft initialDraft;

  const SecAcntConsentScreen({
    super.key,
    required this.bootstrapState,
    required this.bankOptionsRepository,
    required this.bankAccountLookupRepository,
    required this.appApi,
    required this.currentUser,
    required this.initialDraft,
  });

  void _openPersonalInfo(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => SecAcntPersonalInfoScreen(
          bootstrapState: bootstrapState,
          bankOptionsRepository: bankOptionsRepository,
          bankAccountLookupRepository: bankAccountLookupRepository,
          appApi: appApi,
          currentUser: currentUser,
          initialDraft: initialDraft,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final responsive = context.responsive;

    final SecAcntWizardHeaderData header = buildSecAcntHeader(
      context,
      SecAcntFlowStep.consent,
    );

    return InvestXPageScaffold(
      appBarTitle: header.title,
      appBarCenterTitle: header.centerTitle,
      appBarReserveLeadingSpace: header.reserveLeadingSpace,
      appBarTitleSpacing: header.centerTitle ? null : context.responsive.dp(20),
      showBackButton: header.showBack,
      showCloseButton: header.showClose,
      onBack: () => Navigator.of(context).maybePop(),
      onClose: () => closeSecAcntFlow(context),
      hasSafeArea: false,
      backgroundColor: InvestXDesignTokens.softSurface,
      appBarBackgroundColor: InvestXDesignTokens.softSurface,
      appBarShowBottomBorder: false,
      appBarTitleStyle: buildSecAcntHeaderTitleStyle(context, header),
      body: Padding(
        padding: EdgeInsets.all(responsive.dp(AppSpacing.xl)),
        child: Column(
          children: <Widget>[
            // SecAcntStepIndicator(
            //   currentStep: SecAcntFlowStep.consent,
            //   bootstrapState: bootstrapState,
            // ),
            Expanded(
              child: Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: responsive.dp(290)),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      CustomImage(
                        path: Img.insurance,
                        width: responsive.dp(120),
                        height: responsive.dp(120),
                      ),
                      SizedBox(height: responsive.dp(20)),
                      Text(
                        l10n.tinoConsent,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(
                              color: InvestXDesignTokens.ink,
                              fontWeight: MiniAppTypography.bold,
                              height: 1.3,
                            ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Row(
              children: <Widget>[
                Expanded(
                  child: InvestXSecondaryButton(
                    label: l10n.reject,
                    onPressed: () => closeSecAcntFlow(context),
                    backgroundColor: Colors.white.withValues(alpha: 0.72),
                    boxShadow: InvestXDesignTokens.cardShadow,
                  ),
                ),
                SizedBox(width: responsive.dp(16)),
                Expanded(
                  child: InvestXPrimaryButton(
                    label: l10n.accept,
                    onPressed: () => _openPersonalInfo(context),
                  ),
                ),
              ],
            ),

            SizedBox(height: responsive.dp(20)),
          ],
        ),
      ),
    );
  }
}
