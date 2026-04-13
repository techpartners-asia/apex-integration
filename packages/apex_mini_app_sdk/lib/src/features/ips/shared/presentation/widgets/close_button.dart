import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mini_app_ui/mini_app_ui.dart';

class CustomCloseBtn extends StatelessWidget {
  final VoidCallback onPressed;
  final bool isSplashBtn;

  const CustomCloseBtn({
    super.key,
    required this.onPressed,
    this.isSplashBtn = false,
  });

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;
    return PhysicalModel(
      color: isSplashBtn ? Colors.black54 : Colors.white,
      shape: BoxShape.circle,
      shadowColor: Colors.black,
      elevation: 1.0,
      child: Padding(
        padding: EdgeInsets.all(responsive.spacingMd),
        child: MiniAppAdaptiveIconButton(
          icon: Icons.close_rounded,
          iosIcon: CupertinoIcons.xmark,
          onPressed: onPressed,
          size: responsive.component(AppComponentSize.controlSm),
          iconSize: responsive.icon(AppComponentSize.iconSm),
          backgroundColor: isSplashBtn ? Colors.white : Colors.black,
          foregroundColor: isSplashBtn ? Colors.black : Colors.white,
        ),
      ),
    );
  }
}
