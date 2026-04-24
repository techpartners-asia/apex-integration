import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mini_app_ui/mini_app_ui.dart';
import 'package:mini_app_sdk/mini_app_sdk.dart';

class CreateFeedbackScreen extends StatefulWidget {
  const CreateFeedbackScreen({super.key});

  @override
  State<CreateFeedbackScreen> createState() => _CreateFeedbackScreenState();
}

class _CreateFeedbackScreenState extends State<CreateFeedbackScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _bodyController = TextEditingController();
  static const int _maxBodyLength = 500;

  bool get _canSubmit =>
      _titleController.text.trim().isNotEmpty &&
      _bodyController.text.trim().isNotEmpty;

  @override
  void dispose() {
    _titleController.dispose();
    _bodyController.dispose();
    super.dispose();
  }

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

class _FeedbackBodyField extends StatelessWidget {
  const _FeedbackBodyField({
    required this.controller,
    required this.label,
    required this.hint,
    required this.maxLength,
    this.onChanged,
  });

  final TextEditingController controller;
  final String label;
  final String hint;
  final int maxLength;
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;
    final TextTheme textTheme = context.textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        TextFormField(
          controller: controller,
          maxLength: maxLength,
          maxLines: 6,
          minLines: 4,
          onChanged: onChanged,
          onTapOutside: (_) => FocusScope.of(context).unfocus(),
          decoration: InputDecoration(
            labelText: label,
            hintText: hint,
            floatingLabelBehavior: FloatingLabelBehavior.auto,
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(responsive.radiusMd),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(responsive.radiusMd),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(responsive.radiusMd),
              borderSide: const BorderSide(
                color: DesignTokens.rose,
                width: 1,
              ),
            ),
            counterStyle: textTheme.bodySmall?.copyWith(
              color: DesignTokens.muted,
            ),
          ),
        ),
      ],
    );
  }
}
