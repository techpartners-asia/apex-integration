import 'package:flutter/widgets.dart';

import 'mini_app_host_controller.dart';
import 'mini_app_host_controller_provider.dart';
import 'mini_app_host_controller_registry.dart';

class MiniAppHostControllerScope extends StatefulWidget {
  final MiniAppHostController controller;
  final Widget child;

  const MiniAppHostControllerScope({
    super.key,
    required this.controller,
    required this.child,
  });

  @override
  State<MiniAppHostControllerScope> createState() =>
      _MiniAppHostControllerScopeState();
}

class _MiniAppHostControllerScopeState
    extends State<MiniAppHostControllerScope> {
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

  void _attach() {
    _registration = MiniAppHostControllerRegistry.attach(
      controller: widget.controller,
      context: context,
    );
  }

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
