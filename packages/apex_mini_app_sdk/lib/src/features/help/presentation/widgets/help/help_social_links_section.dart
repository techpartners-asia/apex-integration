part of '../help_sections.dart';

/// Displays support social links in a two-column grid.
class HelpSocialLinksSection extends StatelessWidget {
  /// Links to render as social chips.
  final List<SocialMediaEntity> links;

  /// Creates a social-links section.
  const HelpSocialLinksSection({
    super.key,
    required this.links,
  });

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;
    final double spacing = responsive.dp(12);

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: links.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: spacing,
        mainAxisSpacing: spacing,
        childAspectRatio: 1.8,
      ),
      itemBuilder: (BuildContext context, int index) {
        return _SocialChip(link: links[index]);
      },
    );
  }
}
