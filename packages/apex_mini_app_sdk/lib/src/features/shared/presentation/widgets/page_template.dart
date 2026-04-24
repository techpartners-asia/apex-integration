import 'package:flutter/material.dart';
import 'package:mini_app_sdk/mini_app_sdk.dart';
import 'package:mini_app_ui/mini_app_ui.dart';

class FormPageTemplate extends StatelessWidget {
  final List<Widget> sections;
  final Widget actionBar;

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

class SelectionPageTemplate extends StatelessWidget {
  final Widget header;
  final Widget? content;
  final Widget actionBar;
  final Widget? status;
  final Widget? footer;
  final bool hasMargin;

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

    return MiniAppSurfaceCard(
      padding: EdgeInsets.zero,
      margin: hasMargin ? EdgeInsets.only(bottom: AppSpacing.xl) : null,
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
    );
  }
}

class DetailPageTemplate extends StatelessWidget {
  const DetailPageTemplate({
    super.key,
    this.header,
    required this.sections,
  });

  final Widget? header;
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

class ResultPageTemplate extends StatelessWidget {
  final String title;
  final String subtitle;
  final Widget content;
  final Widget? banner;

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
