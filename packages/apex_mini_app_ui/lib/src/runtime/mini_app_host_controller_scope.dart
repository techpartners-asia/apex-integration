import 'package:flutter/widgets.dart';

import 'mini_app_host_controller.dart';
import 'mini_app_host_controller_provider.dart';
import 'mini_app_host_controller_registry.dart';

/// Widget boundary that both provides and registers a mini-app controller.
///
/// Route pages must be built under this scope so delayed callbacks and nested
/// widgets can still resolve the currently active controller.
class MiniAppHostControllerScope extends StatefulWidget {
  /// Controller owned by the active mini-app runtime.
  final MiniAppHostController controller;

  /// Mini-app subtree that should use [controller].
  final Widget child;

  /// Creates a controller scope for a visible mini-app route subtree.
  const MiniAppHostControllerScope({
    super.key,
    required this.controller,
    required this.child,
  });

  @override
  State<MiniAppHostControllerScope> createState() =>
      _MiniAppHostControllerScopeState();
}

/// Registers the scope context while the widget is mounted.
class _MiniAppHostControllerScopeState
    extends State<MiniAppHostControllerScope> {
  /// Registry handle for this mounted controller/context pair.
  MiniAppHostControllerRegistration? _registration;

  @override
  void initState() {
    super.initState();
    _attach();
  }

  @override
  void didUpdateWidget(covariant MiniAppHostControllerScope oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!identical(oldWidget.controller, widget.controller)) {
      _detach();
      _attach();
    }
  }

  @override
  void dispose() {
    _detach();
    super.dispose();
  }

  /// Adds this mounted context to the active controller registry.
  void _attach() {
    _registration = MiniAppHostControllerRegistry.attach(
      controller: widget.controller,
      context: context,
    );
  }

  /// Removes this scope's registry entry.
  void _detach() {
    final MiniAppHostControllerRegistration? registration = _registration;
    if (registration == null) {
      return;
    }

    MiniAppHostControllerRegistry.detach(registration);
    _registration = null;
  }

  @override
  Widget build(BuildContext context) {
    return MiniAppHostControllerProvider(
      controller: widget.controller,
      child: widget.child,
    );
  }
}
