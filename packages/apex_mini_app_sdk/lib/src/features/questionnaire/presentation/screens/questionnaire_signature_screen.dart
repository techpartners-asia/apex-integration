import 'dart:async';

import 'package:apex_mini_app_sdk/apex_mini_app_sdk.dart';
import 'package:flutter/material.dart';

/// Signature step before questionnaire recommendation/questions.
class QuestionnaireSignatureScreen extends StatefulWidget {
  /// Service that uploads captured signature strokes.
  final SignatureUploadService signatureUploadService;

  /// Creates the questionnaire signature screen.
  const QuestionnaireSignatureScreen({
    super.key,
    required this.signatureUploadService,
  });

  @override
  State<QuestionnaireSignatureScreen> createState() =>
      _QuestionnaireSignatureScreenState();
}

/// Captures signature strokes and uploads them before recommendation.
class _QuestionnaireSignatureScreenState
    extends State<QuestionnaireSignatureScreen> {
  /// Signature stroke points; null values separate strokes.
  final List<Offset?> _points = <Offset?>[];

  /// Whether a signature upload is in progress.
  bool _isUploading = false;

  /// Last upload/validation error shown on the screen.
  String? _errorMessage;

  /// Whether the user has drawn at least one stroke.
  bool get _hasSignature => _points.any((Offset? point) => point != null);

  /// Uploads the signature and opens the recommendation step.
  Future<void> _openNextStep() async {
    if (_isUploading) {
      return;
    }

    setState(() {
      _isUploading = true;
      _errorMessage = null;
    });

    try {
      await widget.signatureUploadService.uploadSignature(_points);
    } catch (error) {
      if (!mounted) {
        return;
      }
      setState(() {
        _isUploading = false;
        _errorMessage = formatIpsError(error, context.l10n);
      });
      return;
    }

    if (!mounted) {
      return;
    }

    unawaited(QuestionnaireLocalPrefs.markSignatureUploaded());
    setState(() => _isUploading = false);
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => const QuestionnaireRecommendationScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SignatureScreen(
      appBarTitle: context.l10n.ipsContractTitle,
      title: context.l10n.commonDrawSignaturePrompt,
      points: _points,
      onPointAdd: (Offset point) => setState(() {
        _points.add(point);
        _errorMessage = null;
      }),
      onStrokeEnd: () => setState(() => _points.add(null)),
      onClear: () => setState(() {
        _points.clear();
        _errorMessage = null;
      }),
      continueLabel: context.l10n.commonContinue,
      continueEnabled: _hasSignature && !_isUploading,
      onContinue: _openNextStep,
      showPlaceholderWhenEmpty: false,
      onBack: () => Navigator.of(context).maybePop(),
      message: _errorMessage == null || _errorMessage!.trim().isEmpty
          ? null
          : NoticeBanner(
              title: context.l10n.errorsActionFailed,
              message: _errorMessage!,
              icon: Icons.error_outline_rounded,
            ),
      overlay: _isUploading
          ? BlockingLoadingOverlay(
              title: context.l10n.commonLoading,
              message: context.l10n.ipsSignatureUploading,
            )
          : null,
    );
  }
}
