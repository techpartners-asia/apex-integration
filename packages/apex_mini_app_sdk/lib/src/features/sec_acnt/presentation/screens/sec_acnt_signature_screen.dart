import 'package:flutter/material.dart';
import 'package:apex_mini_app_sdk/apex_mini_app_sdk.dart';

/// Signature capture step for securities account onboarding.
class SecAcntSignatureScreen extends StatefulWidget {
  /// Creates the signature screen.
  const SecAcntSignatureScreen({
    super.key,
    required this.bootstrapState,
    required this.draft,
    required this.appApi,
    this.currentUser,
  });

  /// Bootstrap data used to resolve the next step.
  final AcntBootstrapState? bootstrapState;

  /// Draft personal/bank data carried through the flow.
  final SecAcntFlowDraft draft;

  /// Profile repository used to upload the signature image.
  final MiniAppProfileRepository appApi;

  /// Current profile used by skip logic.
  final UserEntityDto? currentUser;

  @override
  State<SecAcntSignatureScreen> createState() => _SecAcntSignatureScreenState();
}

/// Owns signature strokes and upload state for the securities flow.
class _SecAcntSignatureScreenState extends State<SecAcntSignatureScreen> {
  /// Captured signature points; null values split strokes.
  final List<Offset?> _points = <Offset?>[];

  /// Service created from the injected profile repository.
  late final SignatureUploadService _uploadService;

  /// Whether signature upload is currently in progress.
  bool _isUploading = false;

  /// Last upload error shown below the signature pad.
  String? _errorMessage;

  /// Whether the user has drawn at least one stroke.
  bool get _hasSignature => _points.any((Offset? point) => point != null);

  @override
  void initState() {
    super.initState();
    _uploadService = SignatureUploadService(appApi: widget.appApi);
  }

  /// Uploads the signature and routes to the next required onboarding step.
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
    final SecAcntFlowStep nextStep =
        resolveNextSecAcntFlowStep(
          SecAcntFlowStep.signature,
          widget.bootstrapState,
          currentUser: widget.currentUser,
        ) ??
        SecAcntFlowStep.payment;

    await pushSecAcntFlowStep(
      context,
      step: nextStep,
      bootstrapState: widget.bootstrapState,
      draft: widget.draft,
      appApi: widget.appApi,
      currentUser: widget.currentUser,
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
      onDismiss: () => closeMiniAppSafely(context),
      hasSafeArea: false,
      headerWidget: Padding(
        padding: EdgeInsets.symmetric(horizontal: context.responsive.dp(16)),
        child: SecAcntStepIndicator(
          currentStep: SecAcntFlowStep.signature,
          bootstrapState: widget.bootstrapState,
          currentUser: widget.currentUser,
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
