import 'dart:collection';

import 'package:adaptive_platform_ui/adaptive_platform_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

/// Adaptive app wrapper used by the SDK instead of raw `MaterialApp`.
///
/// It configures Material/Cupertino themes from the same source and guarantees
/// Flutter localization delegates are present even when the host provides only
/// SDK-specific delegates.
class MiniAppPlatformApp extends StatelessWidget {
  /// Navigator key for non-router mode.
  final GlobalKey<NavigatorState>? navigatorKey;

  /// Home widget for non-router mode.
  final Widget? home;

  /// Light Material theme.
  final ThemeData theme;

  /// Optional dark Material theme.
  final ThemeData? darkTheme;

  /// App title.
  final String title;

  /// Forced locale.
  final Locale? locale;

  /// SDK/host localization delegates.
  final Iterable<LocalizationsDelegate<dynamic>>? localizationsDelegates;

  /// Locale-list resolver passed to the underlying app.
  final LocaleListResolutionCallback? localeListResolutionCallback;

  /// Locale resolver passed to the underlying app.
  final LocaleResolutionCallback? localeResolutionCallback;

  /// Locales supported by the mini app.
  final Iterable<Locale> supportedLocales;

  /// Whether to show Flutter's debug banner.
  final bool debugShowCheckedModeBanner;

  /// Builder hook passed to the underlying app.
  final TransitionBuilder? builder;

  /// Optional generated title callback.
  final GenerateAppTitle? onGenerateTitle;

  /// Scaffold messenger key used by SDK overlays/snackbars.
  final GlobalKey<ScaffoldMessengerState>? scaffoldMessengerKey;

  /// Router config for router mode.
  final RouterConfig<Object>? routerConfig;

  /// Router route information provider.
  final RouteInformationProvider? routeInformationProvider;

  /// Router route information parser.
  final RouteInformationParser<Object>? routeInformationParser;

  /// Router delegate.
  final RouterDelegate<Object>? routerDelegate;

  /// Router back button dispatcher.
  final BackButtonDispatcher? backButtonDispatcher;

  /// Creates the platform-adaptive mini-app root.
  const MiniAppPlatformApp({
    super.key,
    this.navigatorKey,
    required this.home,
    required this.theme,
    this.darkTheme,
    this.title = '',
    this.locale,
    this.localizationsDelegates,
    this.localeListResolutionCallback,
    this.localeResolutionCallback,
    this.supportedLocales = const <Locale>[Locale('en', 'US')],
    this.debugShowCheckedModeBanner = false,
    this.builder,
    this.onGenerateTitle,
    this.scaffoldMessengerKey,
  }) : routerConfig = null,
       routeInformationProvider = null,
       routeInformationParser = null,
       routerDelegate = null,
       backButtonDispatcher = null;

  const MiniAppPlatformApp.router({
    super.key,
    required this.theme,
    this.darkTheme,
    this.title = '',
    this.locale,
    this.localizationsDelegates,
    this.localeListResolutionCallback,
    this.localeResolutionCallback,
    this.supportedLocales = const <Locale>[Locale('en', 'US')],
    this.debugShowCheckedModeBanner = false,
    this.builder,
    this.onGenerateTitle,
    this.scaffoldMessengerKey,
    this.routerConfig,
    this.routeInformationProvider,
    this.routeInformationParser,
    this.routerDelegate,
    this.backButtonDispatcher,
  }) : navigatorKey = null,
       home = null;

  @override
  Widget build(BuildContext context) {
    final ThemeData materialLightTheme = theme;
    final ThemeData materialDarkTheme = darkTheme ?? theme;
    final Iterable<LocalizationsDelegate<dynamic>>
    effectiveLocalizationsDelegates = _mergeLocalizationDelegates(
      localizationsDelegates,
    );

    MaterialAppData materialBuilder(BuildContext _, PlatformTarget _) {
      return MaterialAppData(
        debugShowCheckedModeBanner: debugShowCheckedModeBanner,
      );
    }

    CupertinoAppData cupertinoBuilder(BuildContext _, PlatformTarget _) {
      return CupertinoAppData(
        debugShowCheckedModeBanner: debugShowCheckedModeBanner,
      );
    }

    if (routerConfig != null ||
        routeInformationProvider != null ||
        routeInformationParser != null ||
        routerDelegate != null) {
      return AdaptiveApp.router(
        routerConfig: routerConfig,
        routeInformationProvider: routeInformationProvider,
        routeInformationParser: routeInformationParser,
        routerDelegate: routerDelegate,
        backButtonDispatcher: backButtonDispatcher,
        title: title,
        onGenerateTitle: onGenerateTitle,
        builder: builder,
        locale: locale,
        localizationsDelegates: effectiveLocalizationsDelegates,
        localeListResolutionCallback: localeListResolutionCallback,
        localeResolutionCallback: localeResolutionCallback,
        supportedLocales: supportedLocales,
        materialLightTheme: materialLightTheme,
        materialDarkTheme: materialDarkTheme,
        cupertinoLightTheme: MaterialBasedCupertinoThemeData(
          materialTheme: materialLightTheme,
        ),
        cupertinoDarkTheme: MaterialBasedCupertinoThemeData(
          materialTheme: materialDarkTheme,
        ),
        scaffoldMessengerKey: scaffoldMessengerKey,
        material: materialBuilder,
        cupertino: cupertinoBuilder,
      );
    }

    return AdaptiveApp(
      navigatorKey: navigatorKey,
      home: home,
      title: title,
      onGenerateTitle: onGenerateTitle,
      builder: builder,
      locale: locale,
      localizationsDelegates: effectiveLocalizationsDelegates,
      localeListResolutionCallback: localeListResolutionCallback,
      localeResolutionCallback: localeResolutionCallback,
      supportedLocales: supportedLocales,
      materialLightTheme: materialLightTheme,
      materialDarkTheme: materialDarkTheme,
      cupertinoLightTheme: MaterialBasedCupertinoThemeData(
        materialTheme: materialLightTheme,
      ),
      cupertinoDarkTheme: MaterialBasedCupertinoThemeData(
        materialTheme: materialDarkTheme,
      ),
      scaffoldMessengerKey: scaffoldMessengerKey,
      material: materialBuilder,
      cupertino: cupertinoBuilder,
    );
  }

  /// Merges caller delegates with required Flutter localization delegates.
  static Iterable<LocalizationsDelegate<dynamic>> _mergeLocalizationDelegates(
    Iterable<LocalizationsDelegate<dynamic>>? delegates,
  ) {
    final LinkedHashMap<Type, LocalizationsDelegate<dynamic>> merged =
        LinkedHashMap<Type, LocalizationsDelegate<dynamic>>();

    for (final LocalizationsDelegate<dynamic> delegate
        in delegates ?? const <LocalizationsDelegate<dynamic>>[]) {
      merged[delegate.runtimeType] = delegate;
    }

    for (final LocalizationsDelegate<dynamic> delegate
        in const <LocalizationsDelegate<dynamic>>[
          GlobalMaterialLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ]) {
      merged.putIfAbsent(delegate.runtimeType, () => delegate);
    }

    return merged.values;
  }
}
