import 'package:flutter/material.dart';
import 'package:mini_app_sdk/mini_app_sdk.dart';

class QuestionnaireSignatureScreen extends StatefulWidget {
  final SignatureUploadService signatureUploadService;

  const QuestionnaireSignatureScreen({super.key, required this.signatureUploadService});

  @override
  State<QuestionnaireSignatureScreen> createState() => _QuestionnaireSignatureScreenState();
}

class _QuestionnaireSignatureScreenState extends State<QuestionnaireSignatureScreen> {
  final List<Offset?> _points = <Offset?>[];
  bool _isUploading = false;
  String? _errorMessage;

  bool get _hasSignature => _points.any((Offset? point) => point != null);

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
