import 'dart:async';

import 'package:apex_mini_app_sdk/apex_mini_app_sdk.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Entry point for the questionnaire nested flow.
class QuestionnaireScreen extends StatefulWidget {
  /// Creates the questionnaire flow screen.
  const QuestionnaireScreen({super.key, required this.signatureUploadService});

  /// Signature upload service shared by the signature step.
  final SignatureUploadService signatureUploadService;

  @override
  State<QuestionnaireScreen> createState() => _QuestionnaireScreenState();
}

/// Resolves resume/skip routing once grape completion state is loaded.
class _QuestionnaireScreenState extends State<QuestionnaireScreen> {
  bool _skipToPacksHandled = false;
  bool _redirectToPacksInFlight = false;
  bool _prefsLoaded = false;

  @override
  void initState() {
    super.initState();
    _loadPrefs();
  }

  Future<void> _loadPrefs() async {
    await QuestionnaireLocalPrefs.init();
    if (mounted) setState(() => _prefsLoaded = true);
  }

  Future<void> _redirectToPacks(QuestionnaireRes res) async {
    if (_skipToPacksHandled || _redirectToPacksInFlight || !mounted) {
      return;
    }

    _redirectToPacksInFlight = true;
    res.showRecomended = true;

    try {
      await replaceIpsRoute(
        context,
        route: MiniAppRoutes.packs,
        arguments: res,
      );
      _skipToPacksHandled = true;
    } finally {
      _redirectToPacksInFlight = false;
    }
  }

  bool _shouldShowBootstrapLoading(IpsQuestionnaireState state) {
    if (!_prefsLoaded) {
      return true;
    }

    if (state.isLoading) {
      return true;
    }

    if (state.skipCalculation && state.res != null) {
      return true;
    }

    return false;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return BlocConsumer<IpsQuestionnaireCubit, IpsQuestionnaireState>(
      listenWhen:
          (IpsQuestionnaireState previous, IpsQuestionnaireState current) {
            return previous.isLoading != current.isLoading ||
                previous.skipCalculation != current.skipCalculation ||
                previous.res != current.res;
          },
      listener: (BuildContext context, IpsQuestionnaireState state) {
        if (state.isLoading || state.res == null || !state.skipCalculation) {
          return;
        }

        unawaited(_redirectToPacks(state.res!));
      },
      builder: (BuildContext context, IpsQuestionnaireState state) {
        if (_shouldShowBootstrapLoading(state)) {
          return _QuestionnaireBootstrapLoadingView(
            title: l10n.commonLoading,
            message: state.skipCalculation && state.res != null
                ? l10n.ipsPackLoading
                : l10n.ipsQuestionnaireLoading,
          );
        }

        if (state.skipContractAndQuestions && !state.skipCalculation) {
          return const QuestionnaireCalculationScreen();
        }

        return Navigator(
          onGenerateRoute: (_) => MaterialPageRoute<void>(
            builder: (_) {
              if (QuestionnaireLocalPrefs.hasCompletedAgreementAndSignature) {
                return const QuestionnaireRecommendationScreen();
              }
              return QuestionnaireAgreementScreen(
                signatureUploadService: widget.signatureUploadService,
              );
            },
          ),
        );
      },
    );
  }
}

/// Full-screen loading state used while questionnaire routing is resolved.
class _QuestionnaireBootstrapLoadingView extends StatelessWidget {
  /// Creates the bootstrap loading view.
  const _QuestionnaireBootstrapLoadingView({
    required this.title,
    required this.message,
  });

  /// Main loading title.
  final String title;

  /// Supporting loading message.
  final String message;

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;

    return CustomScaffold(
      hasAppBar: false,
      showCloseButton: false,
      showBackButton: false,
      backgroundColor: DesignTokens.softSurface,
      body: Center(
        child: Padding(
          padding: responsive.insetsSymmetric(horizontal: 32),
          child: MiniAppLoadingState(
            title: title,
            message: message,
          ),
        ),
      ),
    );
  }
}
