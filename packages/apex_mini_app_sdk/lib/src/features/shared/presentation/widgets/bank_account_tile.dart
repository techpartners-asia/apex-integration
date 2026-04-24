import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mini_app_ui/mini_app_ui.dart';
import 'package:mini_app_sdk/mini_app_sdk.dart';

class BankAccountTile extends StatelessWidget {
  final SecAcntBankOption bank;
  final bool selected;
  final VoidCallback? onTap;

  const BankAccountTile({
    super.key,
    required this.bank,
    required this.selected,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;
    final BorderRadius borderRadius = BorderRadius.circular(
      responsive.radius(16),
    );
    final bool hasLogo = bank.logoUrl.trim().isNotEmpty;
    final Color backgroundColor = selected
        ? const Color(0xFFFFF4F7)
        : Colors.white;
    final Color borderColor = selected
        ? DesignTokens.rose
        : const Color(0xFFF0F2F6);

    Widget buildFallback() {
      return Center(
        child: Text(
          bank.shortLabel,
          style: TextStyle(
            color: DesignTokens.ink,
            fontWeight: MiniAppTypography.bold,
            fontSize: responsive.sp(12),
          ),
        ),
      );
    }

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: borderRadius,
        onTap: onTap,
        child: Ink(
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: borderRadius,
            border: Border.all(color: borderColor, width: selected ? 1.4 : 1),
            boxShadow: const <BoxShadow>[
              BoxShadow(
                color: Color(0x0A101828),
                blurRadius: 10,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Padding(
            padding: EdgeInsets.fromLTRB(
              responsive.dp(6),
              responsive.dp(10),
              responsive.dp(6),
              responsive.dp(8),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Container(
                  width: responsive.dp(40),
                  height: responsive.dp(40),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8FAFD),
                    borderRadius: BorderRadius.circular(responsive.radius(12)),
                  ),
                  padding: EdgeInsets.all(responsive.dp(hasLogo ? 3 : 0)),
                  child: hasLogo
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(
                            responsive.radius(10),
                          ),
                          child: CachedNetworkImage(
                            imageUrl: bank.logoUrl,
                            fit: BoxFit.cover,
                            placeholder: (BuildContext context, String url) =>
                                buildFallback(),
                            errorWidget:
                                (
                                  BuildContext context,
                                  String url,
                                  Object error,
                                ) => buildFallback(),
                          ),
                        )
                      : buildFallback(),
                ),
                SizedBox(height: responsive.dp(8)),
                Expanded(
                  child: Center(
                    child: CustomText(
                      bank.label,
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: DesignTokens.ink.withValues(alpha: 0.84),
                        fontSize: responsive.sp(9.5),
                        fontWeight: MiniAppTypography.semiBold,
                        height: 1.15,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
