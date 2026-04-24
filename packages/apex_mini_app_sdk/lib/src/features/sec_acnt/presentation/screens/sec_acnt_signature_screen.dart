import 'package:flutter/material.dart';
import 'package:mini_app_ui/mini_app_ui.dart';
import 'package:mini_app_sdk/mini_app_sdk.dart';

class SecAcntSignatureScreen extends StatefulWidget {
  const SecAcntSignatureScreen({
    super.key,
    required this.bootstrapState,
    required this.draft,
    required this.appApi,
  });

  final AcntBootstrapState? bootstrapState;
  final SecAcntFlowDraft draft;
  final MiniAppApiRepository appApi;

  @override
  State<SecAcntSignatureScreen> createState() => _SecAcntSignatureScreenState();
}

class _SecAcntSignatureScreenState extends State<SecAcntSignatureScreen> {
  final List<Offset?> _points = <Offset?>[];
  late final SignatureUploadService _uploadService;
  bool _isUploading = false;
  String? _errorMessage;

  bool get _hasSignature => _points.any((Offset? point) => point != null);

  @override
  void initState() {
    super.initState();
    _uploadService = SignatureUploadService(appApi: widget.appApi);
  }

  Future<void> _openNextStep() async {
    if (_isUploading) {
      return;
    }

    setState(() {
      _isUploading = true;
      _errorMessage = null;
    });

    try {
      await _uploadService.uploadSignature(_points);
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
        builder: (_) => SecAcntPaymentScreen(
          bootstrapState: widget.bootstrapState,
          draft: widget.draft,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final SecAcntWizardHeaderData header = buildSecAcntHeader(
      context,
      SecAcntFlowStep.signature,
    );

    return SignatureScreen(
      appBarTitle: header.title,
      appBarCenterTitle: header.centerTitle,
      appBarReserveLeadingSpace: header.reserveLeadingSpace,
      appBarTitleSpacing: header.centerTitle ? null : context.responsive.dp(20),
      appBarTitleStyle: buildSecAcntHeaderTitleStyle(context, header),
      showBackButton: header.showBack,
      showCloseButton: header.showClose,
      onBack: () => Navigator.of(context).maybePop(),
      onClose: () => Navigator.of(context, rootNavigator: true).maybePop(),
      hasSafeArea: false,
      headerWidget: Padding(
        padding: EdgeInsets.symmetric(horizontal: context.responsive.dp(16)),
        child: SecAcntStepIndicator(
          currentStep: SecAcntFlowStep.signature,
          bootstrapState: widget.bootstrapState,
        ),
      ),
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
