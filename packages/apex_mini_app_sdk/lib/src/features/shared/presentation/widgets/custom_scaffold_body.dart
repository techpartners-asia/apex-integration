import 'package:flutter/material.dart';
import 'package:mini_app_ui/mini_app_ui.dart';

class CustomScaffoldBody extends StatelessWidget {
  final String title;
  final String? subtitle;
  final List<Widget> actions;
  final List<Widget> children;
  final EdgeInsets bodyPadding;
  final Future<void> Function()? onRefresh;
  final Color? refreshIndicatorColor;

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
      physics: onRefresh != null
          ? const AlwaysScrollableScrollPhysics()
          : null,
      child: Padding(
        padding: bodyPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            if (title.trim().isNotEmpty) ...<Widget>[
              CustomText(
                title,
                variant: MiniAppTextVariant.title,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: MiniAppTypography.bold,
                ),
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
                  variant: MiniAppTextVariant.bodySmall,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodySmall,
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
