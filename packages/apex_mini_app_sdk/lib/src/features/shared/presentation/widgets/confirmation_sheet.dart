import 'package:flutter/material.dart';
import 'package:apex_mini_app_sdk/apex_mini_app_sdk.dart';

/// Shows a reusable confirmation bottom sheet and returns the user's choice.
Future<bool?> showConfirmationSheet({
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
      return ActionSheet(
        title: title,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            CustomText(
              message,
              variant: MiniAppTextVariant.body2,
              color: MiniAppStateColors.mutedForeground,
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
                variant: MiniAppTextVariant.buttonMedium,
              ),
            ),
            SizedBox(height: responsive.spacing.inlineSpacing),
            MiniAppAdaptivePressable(
              onPressed: () => Navigator.pop(sheetContext, false),
              child: CustomText(
                cancelLabel,
                variant: MiniAppTextVariant.buttonMedium,
              ),
            ),
          ],
        ),
      );
    },
  );
}
