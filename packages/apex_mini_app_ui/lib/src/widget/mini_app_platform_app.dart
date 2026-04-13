import 'dart:collection';

import 'package:adaptive_platform_ui/adaptive_platform_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

class MiniAppPlatformApp extends StatelessWidget {
  final GlobalKey<NavigatorState>? navigatorKey;
  final Widget? home;
  final ThemeData theme;
  final ThemeData? darkTheme;
  final String title;
  final Locale? locale;
  final Iterable<LocalizationsDelegate<dynamic>>? localizationsDelegates;
  final LocaleListResolutionCallback? localeListResolutionCallback;
  final LocaleResolutionCallback? localeResolutionCallback;
  final Iterable<Locale> supportedLocales;
  final bool debugShowCheckedModeBanner;
  final TransitionBuilder? builder;
  final GenerateAppTitle? onGenerateTitle;
  final GlobalKey<ScaffoldMessengerState>? scaffoldMessengerKey;
  final RouterConfig<Object>? routerConfig;
  final RouteInformationProvider? routeInformationProvider;
  final RouteInformationParser<Object>? routeInformationParser;
  final RouterDelegate<Object>? routerDelegate;
  final BackButtonDispatcher? backButtonDispatcher;

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
    final Iterable<LocalizationsDelegate<dynamic>> effectiveLocalizationsDelegates = _mergeLocalizationDelegates(
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

    if (routerConfig != null || routeInformationProvider != null || routeInformationParser != null || routerDelegate != null) {
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

  static Iterable<LocalizationsDelegate<dynamic>> _mergeLocalizationDelegates(
    Iterable<LocalizationsDelegate<dynamic>>? delegates,
  ) {
    final LinkedHashMap<Type, LocalizationsDelegate<dynamic>> merged = LinkedHashMap<Type, LocalizationsDelegate<dynamic>>();

    for (final LocalizationsDelegate<dynamic> delegate in delegates ?? const <LocalizationsDelegate<dynamic>>[]) {
      merged[delegate.runtimeType] = delegate;
    }

    for (final LocalizationsDelegate<dynamic> delegate in const <LocalizationsDelegate<dynamic>>[
      GlobalMaterialLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
    ]) {
      merged.putIfAbsent(delegate.runtimeType, () => delegate);
    }

    return merged.values;
  }
}
