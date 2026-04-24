import 'package:flutter/material.dart';
import 'package:mini_app_sdk/mini_app_sdk.dart';
import 'package:mini_app_ui/mini_app_ui.dart';

class AgreementBodyCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final Color backgroundColor;
  final double? borderRadius;

  const AgreementBodyCard({
    super.key,
    required this.child,
    this.padding,
    this.backgroundColor = Colors.white,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;
    final double resolvedRadius = borderRadius ?? responsive.radius(16);

    return DecoratedBox(
      decoration: const BoxDecoration(
        boxShadow: DesignTokens.cardShadow,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(resolvedRadius),
        child: MiniAppSurfaceCard(
          backgroundColor: backgroundColor,
          borderColor: Colors.transparent,
          borderRadius: resolvedRadius,
          padding:
              padding ??
              EdgeInsets.fromLTRB(
                responsive.dp(16),
                responsive.dp(14),
                responsive.dp(16),
                responsive.dp(16),
              ),
          child: child,
        ),
      ),
    );
  }
}

class AgreementPageTemplate extends StatelessWidget {
  final String? title;
  final Widget body;
  final String? consentLabel;
  final bool? accepted;
  final ValueChanged<bool>? onAcceptedChanged;
  final bool wrapBodyInCard;
  final EdgeInsetsGeometry? contentPadding;
  final EdgeInsetsGeometry? bodyCardPadding;

  const AgreementPageTemplate({
    super.key,
    required this.body,
    this.title,
    this.consentLabel,
    this.accepted,
    this.onAcceptedChanged,
    this.wrapBodyInCard = true,
    this.contentPadding,
    this.bodyCardPadding,
  }) : assert(
         consentLabel == null ||
             (accepted != null && onAcceptedChanged != null),
         'accepted and onAcceptedChanged are required when consentLabel is set.',
       );

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;
    final ThemeData theme = Theme.of(context);
    final Widget content = wrapBodyInCard
        ? AgreementBodyCard(
            padding: bodyCardPadding ?? EdgeInsets.zero,
            child: body,
          )
        : body;

    return Padding(
      padding:
          contentPadding ??
          EdgeInsets.fromLTRB(
            responsive.dp(20),
            responsive.dp(16),
            responsive.dp(20),
            responsive.dp(18),
          ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          if (title != null && title!.trim().isNotEmpty) ...<Widget>[
            Text(
              title!,
              style: theme.textTheme.titleMedium?.copyWith(
                color: DesignTokens.ink,
                fontWeight: MiniAppTypography.bold,
                height: 1.25,
              ),
            ),
            SizedBox(height: responsive.dp(12)),
          ],
          Expanded(child: content),
          if (consentLabel != null) ...<Widget>[
            SizedBox(height: responsive.dp(18)),
            ConsentCheckboxRow(
              label: consentLabel!,
              accepted: accepted!,
              onAcceptedChanged: onAcceptedChanged!,
            ),
          ],
        ],
      ),
    );
  }
}
