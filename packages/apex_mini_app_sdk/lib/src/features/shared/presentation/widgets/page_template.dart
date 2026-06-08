import 'package:flutter/material.dart';

import 'package:apex_mini_app_sdk/apex_mini_app_sdk.dart';

/// Standard vertical template for forms with content sections and an action bar.
class FormPageTemplate extends StatelessWidget {
  /// Form sections rendered from top to bottom.
  final List<Widget> sections;

  /// Bottom action area, usually a primary button or fixed action row.
  final Widget actionBar;

  /// Creates a vertical form template with section spacing and actions.
  const FormPageTemplate({
    super.key,
    required this.sections,
    required this.actionBar,
  });

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        ...sections.expand(
          (Widget section) => <Widget>[
            section,
            SizedBox(height: responsive.spacing.sectionSpacing),
          ],
        ),
        actionBar,
      ],
    );
  }
}

/// Card-based template for selection flows such as package or option picking.
class SelectionPageTemplate extends StatelessWidget {
  /// Header content shown at the top of the selection card.
  final Widget header;

  /// Optional main content area.
  final Widget? content;

  /// Required action area.
  final Widget actionBar;

  /// Optional status/error/loading widget.
  final Widget? status;

  /// Optional footer content below the action area.
  final Widget? footer;

  /// Whether to add bottom margin around the surface card.
  final bool hasMargin;

  /// Creates a card-based selection template.
  const SelectionPageTemplate({
    super.key,
    required this.header,
    required this.actionBar,
    this.content,
    this.status,
    this.footer,
    this.hasMargin = false,
  });

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;

    return Padding(
      padding: hasMargin ? EdgeInsets.only(bottom: AppSpacing.xl) : EdgeInsets.zero,
      child: MiniAppGlassCard(
        radius: responsive.radius(20),
        padding: EdgeInsets.zero,
        child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          header,
          if (content != null) ...<Widget>[
            SizedBox(height: responsive.spacing.sectionSpacing),
            content!,
          ],
          if (status != null) ...<Widget>[
            SizedBox(height: responsive.spacing.sectionSpacing),
            status!,
          ],
          SizedBox(height: responsive.spacing.sectionSpacing),
          actionBar,
          SizedBox(height: responsive.spacing.sectionSpacing),
          if (footer != null) ...<Widget>[
            SizedBox(height: responsive.spacing.inlineSpacing),
            footer!,
          ],
        ],
      ),
      ),
    );
  }
}

/// Simple detail-page template with an optional header and repeated sections.
class DetailPageTemplate extends StatelessWidget {
  /// Creates a detail template with optional header content.
  const DetailPageTemplate({
    super.key,
    this.header,
    required this.sections,
  });

  /// Header shown before the detail sections.
  final Widget? header;

  /// Detail sections rendered with standard spacing.
  final List<Widget> sections;

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        if (header != null) ...<Widget>[
          header!,
          if (sections.isNotEmpty)
            SizedBox(height: responsive.spacing.sectionSpacing),
        ],
        ...sections.expand(
          (Widget section) => <Widget>[
            section,
            SizedBox(height: responsive.spacing.sectionSpacing),
          ],
        ),
      ],
    );
  }
}

/// Result/success/failure page template built on [CustomScaffold].
class ResultPageTemplate extends StatelessWidget {
  /// Page title.
  final String title;

  /// Page subtitle.
  final String subtitle;

  /// Main result content.
  final Widget content;

  /// Optional banner shown above the main content.
  final Widget? banner;

  /// Creates a result page template with optional banner content.
  const ResultPageTemplate({
    super.key,
    required this.title,
    required this.subtitle,
    required this.content,
    this.banner,
  });

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;

    return CustomScaffold(
      title: title,
      subtitle: subtitle,
      children: <Widget>[
        if (banner != null) ...<Widget>[
          banner!,
          SizedBox(height: responsive.spacing.sectionSpacing),
        ],
        content,
      ],
    );
  }
}
