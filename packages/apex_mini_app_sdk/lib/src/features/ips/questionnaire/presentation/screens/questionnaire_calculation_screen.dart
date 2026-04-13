import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mini_app_ui/mini_app_ui.dart';

import '../../../../../routes/mini_app_routes.dart';
import '../../../../../shared/l10n/sdk_localizations_x.dart';
import '../../../shared/domain/models/ips_models.dart';
import '../../../shared/images/images.dart';
import '../../../shared/presentation/helpers/ips_navigation.dart';
import '../../../shared/presentation/widgets/widgets.dart';
import '../../application/ips_questionnaire_cubit.dart';
import '../../application/ips_questionnaire_state.dart';

class QuestionnaireCalculationScreen extends StatefulWidget {
  const QuestionnaireCalculationScreen({super.key});

  @override
  State<QuestionnaireCalculationScreen> createState() =>
      _QuestionnaireCalculationScreenState();
}

class _QuestionnaireCalculationScreenState
    extends State<QuestionnaireCalculationScreen> {
  bool _isRouting = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final IpsQuestionnaireCubit cubit = context.read<IpsQuestionnaireCubit>();
      final IpsQuestionnaireState state = cubit.state;
      if (state.res == null && !state.isSubmitting) {
        unawaited(cubit.submit());
      }
    });
  }

  Future<void> _routeToPacks(QuestionnaireRes res) async {
    if (_isRouting) {
      return;
    }

    _isRouting = true;
    await replaceIpsRoute(context, route: MiniAppRoutes.packs, arguments: res);
  }

  void _returnToQuestions() {
    if (!mounted) {
      return;
    }
    Navigator.of(context).maybePop();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return PopScope(
      canPop: false,
      child: BlocConsumer<IpsQuestionnaireCubit, IpsQuestionnaireState>(
        listenWhen:
            (IpsQuestionnaireState previous, IpsQuestionnaireState current) {
              final bool hasFreshResult =
                  previous.res != current.res && current.res != null;
              final bool submitFailed =
                  previous.isSubmitting &&
                  !current.isSubmitting &&
                  current.res == null &&
                  current.errorMessage != null;
              return hasFreshResult || submitFailed;
            },
        listener: (BuildContext context, IpsQuestionnaireState state) {
          final QuestionnaireRes? res = state.res;
          if (res != null) {
            unawaited(_routeToPacks(res));
            return;
          }

          WidgetsBinding.instance.addPostFrameCallback((_) {
            _returnToQuestions();
          });
        },
        builder: (BuildContext context, IpsQuestionnaireState state) {
          if (state.bootstrapState == null && state.errorMessage != null) {
            return InvestXPageScaffold(
              appBarTitle: l10n.ipsContractTitle,
              showCloseButton: false,
              showBackButton: true,
              onBack: () =>
                  Navigator.of(context, rootNavigator: true).maybePop(),
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

          return InvestXPageScaffold(
            hasAppBar: false,
            showCloseButton: false,
            showBackButton: false,
            backgroundColor: InvestXDesignTokens.softSurface,
            body: _QuestionnaireCalculationView(
              title: l10n.commonLoading,
              message: l10n.ipsQuestionnaireCalculatingMessage,
            ),
          );
        },
      ),
    );
  }
}

class _QuestionnaireCalculationView extends StatelessWidget {
  const _QuestionnaireCalculationView({
    required this.title,
    required this.message,
  });

  final String title;
  final String message;

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;

    return Center(
      child: Padding(
        padding: responsive.insetsSymmetric(horizontal: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            CustomImage(
              path: Img.loadingAnimation,
              width: responsive.dp(270),
              height: responsive.dp(270),
            ),
            SizedBox(height: responsive.dp(28)),
            Text(
              title,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: InvestXDesignTokens.ink,
                fontWeight: MiniAppTypography.bold,
              ),
            ),
            SizedBox(height: responsive.dp(12)),
            Text(
              message,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: InvestXDesignTokens.ink,
                height: 1.55,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
