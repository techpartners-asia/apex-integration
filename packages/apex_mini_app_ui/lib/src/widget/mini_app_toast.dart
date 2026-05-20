import 'dart:async';

import 'package:apex_mini_app_ui/apex_mini_app_ui.dart';
import 'package:flutter/material.dart';

/// Visual severity for mini-app toast overlays.
enum MiniAppToastType { info, success, warning, error }

/// Static toast manager for transient SDK-owned overlay messages.
final class MiniAppToast {
  const MiniAppToast._();

  static OverlayEntry? _currentEntry;

  /// Shows a toast and replaces any currently visible toast.
  static void show(
    BuildContext context, {
    required String message,
    String? title,
    MiniAppToastType type = MiniAppToastType.info,
    Duration duration = const Duration(seconds: 3),
  }) {
    final OverlayState? overlay =
        Navigator.maybeOf(context)?.overlay ??
        Overlay.maybeOf(context) ??
        Navigator.maybeOf(context, rootNavigator: true)?.overlay ??
        Overlay.maybeOf(context, rootOverlay: true);

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

  /// Shows an informational toast.
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

  /// Shows a success toast.
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

  /// Shows a warning toast.
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

  /// Shows an error toast.
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

  /// Removes the current toast immediately.
  static void hide() {
    final OverlayEntry? entry = _currentEntry;
    _currentEntry = null;
    if (entry?.mounted ?? false) {
      entry!.remove();
    }
  }
}

/// Animated overlay entry used by [MiniAppToast].
class _MiniAppToastOverlay extends StatefulWidget {
  /// Optional bold title shown above [message].
  final String? title;

  /// Main toast message.
  final String message;

  /// Visual severity used to resolve colors and icon.
  final MiniAppToastType type;

  /// Time before the toast auto-dismisses.
  final Duration duration;

  /// Called after the exit animation completes.
  final VoidCallback onDismissed;

  /// Creates a toast overlay widget.
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

/// Drives toast enter/exit animation and timed dismissal.
class _MiniAppToastOverlayState extends State<_MiniAppToastOverlay>
    with SingleTickerProviderStateMixin {
  /// Animation controller for fade/slide transitions.
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

  /// Auto-dismiss timer for the visible toast.
  Timer? _dismissTimer;

  /// Prevents double removal when the user taps during auto-dismiss.
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

  /// Animates the toast out and removes its overlay entry.
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      if (widget.title?.trim().isNotEmpty ==
                                          true)
                                        Padding(
                                          padding: const EdgeInsets.only(
                                            bottom: 4,
                                          ),
                                          child: CustomText(
                                            widget.title!.trim(),
                                            variant:
                                                MiniAppTextVariant.buttonMedium,
                                            color: style.titleColor,
                                          ),
                                        ),
                                      CustomText(
                                        widget.message,
                                        variant: MiniAppTextVariant.body2,
                                        color: style.messageColor,
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

/// Resolved colors and icon for a specific toast type.
final class _MiniAppToastStyle {
  /// Toast container background.
  final Color backgroundColor;

  /// Toast outline color.
  final Color borderColor;

  /// Primary icon/accent color.
  final Color foregroundColor;

  /// Circle background behind the icon.
  final Color iconBackgroundColor;

  /// Icon shown for the toast type.
  final IconData icon;

  /// Title text color.
  final Color titleColor;

  /// Message text color.
  final Color messageColor;

  /// Creates resolved toast style data.
  const _MiniAppToastStyle({
    required this.backgroundColor,
    required this.borderColor,
    required this.foregroundColor,
    required this.iconBackgroundColor,
    required this.icon,
    required this.titleColor,
    required this.messageColor,
  });

  /// Maps toast severity to design-token colors and icons.
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
