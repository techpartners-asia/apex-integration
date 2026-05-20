import 'package:flutter/material.dart';
import 'package:apex_mini_app_sdk/apex_mini_app_sdk.dart';

/// Default scrollable body used by [CustomScaffold] when no body override exists.
class CustomScaffoldBody extends StatelessWidget {
  /// Optional body title.
  final String title;

  /// Optional body subtitle.
  final String? subtitle;

  /// Action widgets rendered after children.
  final List<Widget> actions;

  /// Main content children.
  final List<Widget> children;

  /// Padding around the scroll content.
  final EdgeInsets bodyPadding;

  /// Optional pull-to-refresh callback.
  final Future<void> Function()? onRefresh;

  /// Optional refresh indicator color.
  final Color? refreshIndicatorColor;

  /// Creates the default scrollable scaffold body.
  const CustomScaffoldBody({
    super.key,
    required this.title,
    required this.subtitle,
    required this.actions,
    required this.children,
    required this.bodyPadding,
    this.onRefresh,
    this.refreshIndicatorColor,
  });

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;

    final Widget scrollView = SingleChildScrollView(
      physics: onRefresh != null ? const AlwaysScrollableScrollPhysics() : null,
      child: Padding(
        padding: bodyPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            if (title.trim().isNotEmpty) ...<Widget>[
              CustomText(
                title,
                variant: MiniAppTextVariant.title1,
                textAlign: TextAlign.center,
              ),
            ],
            if (subtitle != null && subtitle!.trim().isNotEmpty) ...<Widget>[
              SizedBox(height: responsive.spacing.inlineSpacing * 0.65),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: responsive.spacing.inlineSpacing,
                ),
                child: CustomText(
                  subtitle!,
                  variant: MiniAppTextVariant.caption1,
                  textAlign: TextAlign.center,
                ),
              ),
            ],
            SizedBox(height: responsive.spacing.sectionSpacing),
            ...children,
            if (actions.isNotEmpty) ...<Widget>[
              SizedBox(height: responsive.spacing.sectionSpacing),
              ...actions.map(
                (Widget action) => Padding(
                  padding: EdgeInsets.only(
                    bottom: responsive.spacing.inlineSpacing,
                  ),
                  child: SizedBox(width: double.infinity, child: action),
                ),
              ),
            ],
          ],
        ),
      ),
    );

    if (onRefresh != null) {
      return RefreshIndicator(
        onRefresh: onRefresh!,
        color: refreshIndicatorColor,
        child: scrollView,
      );
    }

    return scrollView;
  }
}
