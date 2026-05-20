import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:apex_mini_app_sdk/apex_mini_app_sdk.dart';

/// Form screen for creating a new support feedback item.
class CreateFeedbackScreen extends StatefulWidget {
  /// Creates the create-feedback screen.
  const CreateFeedbackScreen({super.key});

  @override
  State<CreateFeedbackScreen> createState() => _CreateFeedbackScreenState();
}

/// Owns feedback form controllers and submit enablement.
class _CreateFeedbackScreenState extends State<CreateFeedbackScreen> {
  /// Feedback title controller.
  final TextEditingController _titleController = TextEditingController();

  /// Feedback body controller.
  final TextEditingController _bodyController = TextEditingController();

  /// Maximum body length accepted by the form.
  static const int _maxBodyLength = 500;

  /// Whether both required fields contain text.
  bool get _canSubmit =>
      _titleController.text.trim().isNotEmpty &&
      _bodyController.text.trim().isNotEmpty;

  @override
  void dispose() {
    _titleController.dispose();
    _bodyController.dispose();
    super.dispose();
  }

  /// Submits the feedback through the existing cubit.
  void _submit() {
    if (!_canSubmit) return;

    context.read<FeedbackCubit>().createFeedback(
      title: _titleController.text.trim(),
      description: _bodyController.text.trim(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;
    final l10n = context.l10n;

    return BlocListener<FeedbackCubit, FeedbackState>(
      listener: (BuildContext context, FeedbackState state) {
        if (state.lastCreated != null) {
          Navigator.of(context).pop();
        }
        if (state.errorMessage != null) {
          MiniAppToast.showError(
            context,
            message: state.errorMessage!,
          );
          context.read<FeedbackCubit>().clearFeedback();
        }
      },
      child: CustomScaffold(
        appBarTitle: l10n.ipsFeedbackTitle,
        showCloseButton: false,
        body: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: responsive.spacing.financialCardSpacing,
          ),
          child: Column(
            children: <Widget>[
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      SizedBox(height: responsive.spacing.sectionSpacing),
                      CustomTextField(
                        label: l10n.ipsFeedbackCreateTitle,
                        controller: _titleController,
                        onChanged: (_) => setState(() {}),
                      ),
                      SizedBox(height: responsive.spacing.cardGap),
                      _FeedbackBodyField(
                        controller: _bodyController,
                        label: l10n.ipsFeedbackCreateBody,
                        hint: l10n.ipsFeedbackCreateBodyHint,
                        maxLength: _maxBodyLength,
                        onChanged: (_) => setState(() {}),
                      ),
                    ],
                  ),
                ),
              ),
              BlocBuilder<FeedbackCubit, FeedbackState>(
                builder: (BuildContext context, FeedbackState state) {
                  return BottomActionBar(
                    child: PrimaryButton(
                      label: state.isSubmitting
                          ? '${l10n.commonSubmit}...'
                          : l10n.commonSubmit,
                      onPressed: _canSubmit && !state.isSubmitting
                          ? _submit
                          : null,
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Multiline feedback body field with character counter.
class _FeedbackBodyField extends StatelessWidget {
  /// Creates the body text field.
  const _FeedbackBodyField({
    required this.controller,
    required this.label,
    required this.hint,
    required this.maxLength,
    this.onChanged,
  });

  /// Body text controller.
  final TextEditingController controller;

  /// Field label.
  final String label;

  /// Field hint.
  final String hint;

  /// Max body length.
  final int maxLength;

  /// Text change callback.
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    return CustomTextField(
      label: label,
      hintText: hint,
      controller: controller,
      maxLength: maxLength,
      minLines: 4,
      maxLines: 6,
      keyboardType: TextInputType.multiline,
      textInputAction: TextInputAction.newline,
      showCounter: true,
      onChanged: onChanged,
    );
  }
}
