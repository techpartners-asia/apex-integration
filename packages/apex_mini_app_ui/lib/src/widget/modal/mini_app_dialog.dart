import 'package:flutter/material.dart';

import '../../responsive/mini_app_responsive.dart';
import '../custom_text.dart';
import '../mini_app_surface_card.dart';

class MiniAppDialog extends StatelessWidget {
  final String title;
  final Widget body;
  final List<Widget> actions;
  final Widget? icon;

  const MiniAppDialog({
    super.key,
    required this.title,
    required this.body,
    this.actions = const <Widget>[],
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;

    return Align(
      alignment: Alignment.center,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: responsive.constraints.maxDialogWidth,
        ),
        child: MiniAppSurfaceCard(
          borderRadius: responsive.spacing.radiusLarge,
          padding: EdgeInsets.all(responsive.spacing.modalPadding),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              if (icon != null) ...<Widget>[
                Align(alignment: Alignment.centerLeft, child: icon!),
                SizedBox(height: responsive.spacing.inlineSpacing),
              ],
              CustomText(
                title,
                variant: MiniAppTextVariant.subtitle2,
              ),
              SizedBox(height: responsive.spacing.inlineSpacing),
              body,
              if (actions.isNotEmpty) ...<Widget>[
                SizedBox(height: responsive.spacing.sectionSpacing),
                Wrap(
                  spacing: responsive.spacing.inlineSpacing,
                  runSpacing: responsive.spacing.inlineSpacing,
                  alignment: WrapAlignment.end,
                  children: actions,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

Future<T?> showMiniAppDialog<T>({
  required BuildContext context,
  required String title,
  required Widget body,
  List<Widget> actions = const <Widget>[],
  Widget? icon,
  bool barrierDismissible = true,
}) {
  return showDialog<T>(
    context: context,
    barrierDismissible: barrierDismissible,
    builder: (BuildContext dialogContext) {
      final responsive = dialogContext.responsive;
      return Dialog(
        insetPadding: responsive.insetsSymmetric(horizontal: 20, vertical: 24),
        backgroundColor: Colors.transparent,
        child: MiniAppDialog(
          title: title,
          body: body,
          actions: actions,
          icon: icon,
        ),
      );
    },
  );
}
