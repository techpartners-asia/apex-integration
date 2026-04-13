import 'package:flutter/material.dart';
import '../../../shared/images/images.dart';
import '../../../shared/presentation/widgets/widgets.dart';
import 'package:mini_app_ui/mini_app_ui.dart';

class SecAcntStatusContent extends StatelessWidget {
  final String title;
  final String cardTitle;
  final String message;

  const SecAcntStatusContent({
    super.key,
    required this.title,
    required this.cardTitle,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final EdgeInsets padding = EdgeInsets.fromLTRB(
          responsive.dp(20),
          responsive.dp(24),
          responsive.dp(20),
          responsive.dp(20),
        );

        return SingleChildScrollView(
          padding: padding,
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: constraints.maxHeight - padding.vertical,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                SizedBox(height: responsive.dp(28)),
                Center(
                  child: CustomImage(
                    path: Img.success,
                    width: responsive.dp(53),
                    height: responsive.dp(53),
                  ),
                ),
                SizedBox(height: responsive.dp(20)),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: responsive.dp(20)),
                  child: CustomText(
                    title,
                    textAlign: TextAlign.center,
                    variant: MiniAppTextVariant.headline,
                  ),
                ),
                SizedBox(height: responsive.dp(30)),
                _SecAcntStatusCard(title: cardTitle, message: message),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _SecAcntStatusCard extends StatelessWidget {
  const _SecAcntStatusCard({required this.title, required this.message});

  final String title;
  final String message;

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;
    final ThemeData theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(responsive.dp(20)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(responsive.radius(20)),
        boxShadow: InvestXDesignTokens.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          CustomImage(
            path: Img.clock,
            width: responsive.dp(56),
            height: responsive.dp(56),
          ),
          SizedBox(height: responsive.dp(15)),

          /// Title
          CustomText(title, variant: MiniAppTextVariant.titleSmall),

          SizedBox(height: responsive.dp(10)),

          /// Message
          CustomText(
            message,
            style: theme.textTheme.bodySmall?.copyWith(
              color: InvestXDesignTokens.muted,
            ),
          ),
        ],
      ),
    );
  }
}
