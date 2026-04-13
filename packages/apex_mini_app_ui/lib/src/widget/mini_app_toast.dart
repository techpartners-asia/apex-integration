import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mini_app_ui/mini_app_ui.dart';

enum MiniAppToastType { info, success, warning, error }

final class MiniAppToast {
  const MiniAppToast._();

  static OverlayEntry? _currentEntry;

  static void show(
    BuildContext context, {
    required String message,
    String? title,
    MiniAppToastType type = MiniAppToastType.info,
    Duration duration = const Duration(seconds: 3),
  }) {
    final OverlayState? overlay = Navigator.maybeOf(context, rootNavigator: true)?.overlay ?? Overlay.maybeOf(context, rootOverlay: true);

    if (overlay == null || !context.mounted) {
      return;
    }

    hide();

    late final OverlayEntry entry;
    entry = OverlayEntry(
      builder: (BuildContext overlayContext) {
        return _MiniAppToastOverlay(
          title: title,
          message: message,
          type: type,
          duration: duration,
          onDismissed: () {
            if (identical(_currentEntry, entry)) {
              _currentEntry = null;
            }
            if (entry.mounted) {
              entry.remove();
            }
          },
        );
      },
    );

    _currentEntry = entry;
    overlay.insert(entry);
  }

  static void showInfo(
    BuildContext context, {
    required String message,
    String? title,
    Duration duration = const Duration(seconds: 3),
  }) {
    show(
      context,
      message: message,
      title: title,
      type: MiniAppToastType.info,
      duration: duration,
    );
  }

  static void showSuccess(
    BuildContext context, {
    required String message,
    String? title,
    Duration duration = const Duration(seconds: 3),
  }) {
    show(
      context,
      message: message,
      title: title,
      type: MiniAppToastType.success,
      duration: duration,
    );
  }

  static void showWarning(
    BuildContext context, {
    required String message,
    String? title,
    Duration duration = const Duration(seconds: 3),
  }) {
    show(
      context,
      message: message,
      title: title,
      type: MiniAppToastType.warning,
      duration: duration,
    );
  }

  static void showError(
    BuildContext context, {
    required String message,
    String? title,
    Duration duration = const Duration(seconds: 4),
  }) {
    show(
      context,
      message: message,
      title: title,
      type: MiniAppToastType.error,
      duration: duration,
    );
  }

  static void hide() {
    final OverlayEntry? entry = _currentEntry;
    _currentEntry = null;
    if (entry?.mounted ?? false) {
      entry!.remove();
    }
  }
}

class _MiniAppToastOverlay extends StatefulWidget {
  final String? title;
  final String message;
  final MiniAppToastType type;
  final Duration duration;
  final VoidCallback onDismissed;

  const _MiniAppToastOverlay({
    required this.message,
    required this.type,
    required this.duration,
    required this.onDismissed,
    this.title,
  });

  @override
  State<_MiniAppToastOverlay> createState() => _MiniAppToastOverlayState();
}

class _MiniAppToastOverlayState extends State<_MiniAppToastOverlay> with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 220),
    reverseDuration: const Duration(milliseconds: 180),
  );
  late final Animation<double> _opacity = CurvedAnimation(
    parent: _controller,
    curve: Curves.easeOutCubic,
    reverseCurve: Curves.easeInCubic,
  );
  late final Animation<Offset> _offset = Tween<Offset>(
    begin: const Offset(0, -0.08),
    end: Offset.zero,
  ).animate(_opacity);

  Timer? _dismissTimer;
  bool _isClosing = false;

  @override
  void initState() {
    super.initState();
    _controller.forward();
    _dismissTimer = Timer(widget.duration, _dismiss);
  }

  @override
  void dispose() {
    _dismissTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  Future<void> _dismiss() async {
    if (_isClosing || !mounted) {
      return;
    }
    _isClosing = true;
    await _controller.reverse();
    widget.onDismissed();
  }

  @override
  Widget build(BuildContext context) {
    final _MiniAppToastStyle style = _MiniAppToastStyle.resolve(widget.type);
    final ThemeData theme = Theme.of(context);
    final MediaQueryData mediaQuery = MediaQuery.of(context);

    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: IgnorePointer(
        ignoring: false,
        child: SafeArea(
          bottom: false,
          child: Padding(
            padding: EdgeInsets.fromLTRB(
              16,
              12 + mediaQuery.viewPadding.top * 0.15,
              16,
              0,
            ),
            child: Align(
              alignment: Alignment.topCenter,
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 560),
                child: SlideTransition(
                  position: _offset,
                  child: FadeTransition(
                    opacity: _opacity,
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(18),
                        onTap: _dismiss,
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            color: style.backgroundColor,
                            borderRadius: BorderRadius.circular(18),
                            border: Border.all(color: style.borderColor),
                            boxShadow: const <BoxShadow>[
                              BoxShadow(
                                color: Color(0x14000000),
                                blurRadius: 24,
                                offset: Offset(0, 10),
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 14,
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                  width: 28,
                                  height: 28,
                                  decoration: BoxDecoration(
                                    color: style.iconBackgroundColor,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    style.icon,
                                    size: 16,
                                    color: style.foregroundColor,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      if (widget.title?.trim().isNotEmpty == true)
                                        Padding(
                                          padding: const EdgeInsets.only(
                                            bottom: 4,
                                          ),
                                          child: CustomText(
                                            widget.title!.trim(),
                                            style: theme.textTheme.labelLarge?.copyWith(
                                              color: style.titleColor,
                                              fontWeight: MiniAppTypography.bold,
                                            ),
                                          ),
                                        ),
                                      CustomText(
                                        widget.message,
                                        style: theme.textTheme.bodyMedium?.copyWith(
                                          color: style.messageColor,
                                          height: 1.35,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Icon(
                                  Icons.close_rounded,
                                  size: 18,
                                  color: style.foregroundColor.withValues(
                                    alpha: 0.72,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

final class _MiniAppToastStyle {
  final Color backgroundColor;
  final Color borderColor;
  final Color foregroundColor;
  final Color iconBackgroundColor;
  final IconData icon;
  final Color titleColor;
  final Color messageColor;

  const _MiniAppToastStyle({
    required this.backgroundColor,
    required this.borderColor,
    required this.foregroundColor,
    required this.iconBackgroundColor,
    required this.icon,
    required this.titleColor,
    required this.messageColor,
  });

  static _MiniAppToastStyle resolve(MiniAppToastType type) {
    return switch (type) {
      MiniAppToastType.info => const _MiniAppToastStyle(
        backgroundColor: MiniAppStateColors.infoSurface,
        borderColor: MiniAppStateColors.infoBorder,
        foregroundColor: MiniAppStateColors.infoForeground,
        iconBackgroundColor: Color(0x1F175CD3),
        icon: Icons.info_outline_rounded,
        titleColor: Color(0xFF101828),
        messageColor: Color(0xFF344054),
      ),
      MiniAppToastType.success => const _MiniAppToastStyle(
        backgroundColor: MiniAppStateColors.successSurface,
        borderColor: MiniAppStateColors.successBorder,
        foregroundColor: MiniAppStateColors.successForeground,
        iconBackgroundColor: Color(0x1F12B76A),
        icon: Icons.check_circle_outline_rounded,
        titleColor: Color(0xFF101828),
        messageColor: Color(0xFF344054),
      ),
      MiniAppToastType.warning => const _MiniAppToastStyle(
        backgroundColor: MiniAppStateColors.warningSurface,
        borderColor: MiniAppStateColors.warningBorder,
        foregroundColor: MiniAppStateColors.warningForeground,
        iconBackgroundColor: Color(0x1FB54708),
        icon: Icons.warning_amber_rounded,
        titleColor: Color(0xFF101828),
        messageColor: Color(0xFF344054),
      ),
      MiniAppToastType.error => const _MiniAppToastStyle(
        backgroundColor: MiniAppStateColors.errorSurface,
        borderColor: MiniAppStateColors.errorBorder,
        foregroundColor: MiniAppStateColors.errorForeground,
        iconBackgroundColor: Color(0x1FD92D20),
        icon: Icons.error_outline_rounded,
        titleColor: Color(0xFF101828),
        messageColor: Color(0xFF344054),
      ),
    };
  }
}
