import 'package:flutter/material.dart';
import 'package:mini_app_ui/mini_app_ui.dart';

import 'investx_action_sheet.dart';

Future<bool?> showInvestXConfirmationSheet({
  required BuildContext context,
  required String title,
  required String message,
  required String confirmLabel,
  required String cancelLabel,
  bool destructive = false,
}) {
  return showModalBottomSheet<bool>(
    context: context,
    builder: (BuildContext sheetContext) {
      final responsive = sheetContext.responsive;
      return InvestXActionSheet(
        title: title,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            CustomText(
              message,
              variant: MiniAppTextVariant.body,
              style: Theme.of(sheetContext).textTheme.bodyMedium?.copyWith(
                color: MiniAppStateColors.mutedForeground,
              ),
            ),
            SizedBox(height: responsive.spacing.sectionSpacing),
            MiniAppAdaptivePressable(
              // style: destructive
              //     ? FilledButton.styleFrom(
              //         backgroundColor: MiniAppStateColors.errorForeground,
              //       )
              //     : null,
              onPressed: () => Navigator.pop(sheetContext, true),
              child: CustomText(
                confirmLabel,
                variant: MiniAppTextVariant.button,
              ),
            ),
            SizedBox(height: responsive.spacing.inlineSpacing),
            MiniAppAdaptivePressable(
              onPressed: () => Navigator.pop(sheetContext, false),
              child: CustomText(
                cancelLabel,
                variant: MiniAppTextVariant.button,
              ),
            ),
          ],
        ),
      );
    },
  );
}
