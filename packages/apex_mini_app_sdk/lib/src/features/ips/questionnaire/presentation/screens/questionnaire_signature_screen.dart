import 'package:flutter/material.dart';
import '../../../../../shared/l10n/sdk_localizations_x.dart';

import '../../../shared/application/investx_signature_upload_service.dart';
import '../../../shared/presentation/helpers/ips_error_formatter.dart';
import '../../../shared/presentation/screens/investx_signature_screen.dart';
import '../../../shared/presentation/widgets/widgets.dart';
import 'questionnaire_recommendation_screen.dart';

class QuestionnaireSignatureScreen extends StatefulWidget {
  const QuestionnaireSignatureScreen({
    super.key,
    required this.signatureUploadService,
  });

  final InvestXSignatureUploadService signatureUploadService;

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
    return InvestXSignatureScreen(
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
          : InvestXNoticeBanner(
              title: context.l10n.errorsActionFailed,
              message: _errorMessage!,
              icon: Icons.error_outline_rounded,
            ),
      overlay: _isUploading
          ? InvestXBlockingLoadingOverlay(
              title: context.l10n.commonLoading,
              message: context.l10n.ipsSignatureUploading,
            )
          : null,
    );
  }
}
