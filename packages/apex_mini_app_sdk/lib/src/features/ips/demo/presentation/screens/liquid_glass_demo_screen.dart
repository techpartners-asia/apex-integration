import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:liquid_glass_widgets/liquid_glass_widgets.dart';

import '../../../../../../mini_app_sdk.dart';

const Color _liquidGlassDemoPrimaryTextColor = Color(0xFF10233F);
const Color _liquidGlassDemoSecondaryTextColor = Color(0xFF5F7089);
const Color _liquidGlassDemoTertiaryTextColor = Color(0xFF7D8DA5);
const Color _liquidGlassDemoPanelFillColor = Color(0x14A7B4C8);

class LiquidGlassDemoScreen extends StatefulWidget {
  const LiquidGlassDemoScreen({super.key});

  @override
  State<LiquidGlassDemoScreen> createState() => _LiquidGlassDemoScreenState();
}

class _LiquidGlassDemoScreenState extends State<LiquidGlassDemoScreen> {
  static Future<void>? _initializationFuture;

  static const List<_DemoPosition> _positions = <_DemoPosition>[
    _DemoPosition(
      symbol: 'MND Bond',
      title: 'Government Bond 2028',
      allocation: '34%',
      changeLabel: '+2.4%',
      changeColor: Color(0xFF69F0AE),
    ),
    _DemoPosition(
      symbol: 'TCK',
      title: 'Tech Growth Basket',
      allocation: '26%',
      changeLabel: '+4.8%',
      changeColor: Color(0xFF7CFCF7),
    ),
    _DemoPosition(
      symbol: 'GLD',
      title: 'Defensive Income Pack',
      allocation: '18%',
      changeLabel: '-0.6%',
      changeColor: Color(0xFFFFD180),
    ),
  ];

  static const List<_DemoActivityItem> _activity = <_DemoActivityItem>[
    _DemoActivityItem(
      title: 'Auto-invest executed',
      subtitle: 'Growth portfolio top-up',
      amount: '+120,000 MNT',
      timestamp: 'Today • 10:24',
      accent: Color(0xFF7CFCF7),
    ),
    _DemoActivityItem(
      title: 'Dividend credited',
      subtitle: 'MND Bond 2028',
      amount: '+18,430 MNT',
      timestamp: 'Yesterday • 16:10',
      accent: Color(0xFF69F0AE),
    ),
    _DemoActivityItem(
      title: 'Risk profile updated',
      subtitle: 'Balanced strategy',
      amount: 'Profile sync',
      timestamp: 'Apr 06 • 09:12',
      accent: Color(0xFFFFD180),
    ),
  ];

  int _selectedTabIndex = 0;
  bool _notificationsEnabled = true;
  bool _autoSweepEnabled = true;
  bool _rebalanceProtectionEnabled = false;
  int _selectedWatchlistIndex = 0;

  @override
  void initState() {
    super.initState();
    _initializationFuture ??= LiquidGlassWidgets.initialize();
  }

  LiquidGlassSettings get _bodyGlassSettings => const LiquidGlassSettings(
    blur: 8,
    thickness: 26,
    lightIntensity: .65,
    ambientStrength: .12,
    saturation: 1.2,
  );

  LiquidGlassSettings get _surfaceGlassSettings => LiquidGlassSettings(
    blur: 4,
    thickness: 30,
    lightIntensity: .75,
    ambientStrength: .16,
    saturation: 1.35,
    glassColor: Colors.white.withValues(alpha: 0.8),
  );

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: _initializationFuture,
      builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
        if (snapshot.hasError) {
          return _LiquidGlassDemoFallback(
            title: 'Liquid Glass Demo',
            message: 'Failed to initialize liquid glass shaders.',
            actionLabel: 'Close',
            onAction: () => Navigator.of(context).maybePop(),
          );
        }

        if (snapshot.connectionState != ConnectionState.done) {
          return const _LiquidGlassDemoFallback(
            title: 'Liquid Glass Demo',
            message: 'Preparing glass shaders and surfaces...',
            showProgress: true,
          );
        }

        final ThemeData baseTheme = Theme.of(context);
        final ThemeData demoTheme = baseTheme.copyWith(
          brightness: Brightness.light,
          scaffoldBackgroundColor: InvestXDesignTokens.softSurface,
          textTheme: baseTheme.textTheme.apply(
            bodyColor: _liquidGlassDemoPrimaryTextColor,
            displayColor: _liquidGlassDemoPrimaryTextColor,
          ),
          colorScheme: const ColorScheme.light(
            primary: Color(0xFF4D8BFF),
            secondary: Color(0xFFFF9B8A),
            surface: InvestXDesignTokens.softSurface,
          ),
        );

        return Theme(
          data: demoTheme,
          child: LiquidGlassWidgets.wrap(
            LiquidGlassScope.stack(
              background: const _LiquidGlassDemoBackground(),
              content: Positioned.fill(
                child: Scaffold(
                  backgroundColor: InvestXDesignTokens.softSurface,

                  extendBody: true,
                  appBar: GlassAppBar(
                    useOwnLayer: true,
                    quality: GlassQuality.premium,
                    settings: _surfaceGlassSettings,
                    preferredSize: const Size.fromHeight(56),
                    centerTitle: false,
                    leading: Padding(
                      padding: const EdgeInsets.only(left: 4),
                      child: GlassIconButton(
                        useOwnLayer: true,
                        quality: GlassQuality.standard,
                        icon: const Icon(CupertinoIcons.chevron_left),
                        onPressed: () => Navigator.of(context).maybePop(),
                      ),
                    ),
                    title: const Text(
                      'Liquid Glass Demo',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: _liquidGlassDemoPrimaryTextColor,
                      ),
                    ),
                    actions: <Widget>[
                      GlassIconButton(
                        useOwnLayer: true,
                        quality: GlassQuality.standard,
                        icon: const Icon(CupertinoIcons.info_circle),
                        onPressed: () => _showMessage(
                          'This screen is isolated and uses liquid_glass_widgets only inside the demo route.',
                        ),
                      ),
                    ],
                  ),
                  body: AdaptiveLiquidGlassLayer(
                    settings: _bodyGlassSettings,
                    quality: GlassQuality.standard,
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 220),
                      switchInCurve: Curves.easeOutCubic,
                      switchOutCurve: Curves.easeInCubic,
                      child: KeyedSubtree(
                        key: ValueKey<int>(_selectedTabIndex),
                        child: _buildCurrentTab(context),
                      ),
                    ),
                  ),
                  bottomNavigationBar: GlassBottomBar(
                    quality: GlassQuality.premium,
                    magnification: 1.3,
                    glassSettings: _surfaceGlassSettings,
                    selectedIconColor: _liquidGlassDemoPrimaryTextColor,
                    unselectedIconColor: _liquidGlassDemoSecondaryTextColor,
                    selectedIndex: _selectedTabIndex,
                    onTabSelected: (int index) {
                      if (_selectedTabIndex == index) {
                        return;
                      }
                      setState(() => _selectedTabIndex = index);
                    },
                    extraButton: GlassBottomBarExtraButton(
                      label: 'Portfolio',
                      icon: Icon(CupertinoIcons.chart_pie),
                      onTap: () {},
                    ),
                    tabs: const <GlassBottomBarTab>[
                      GlassBottomBarTab(
                        label: 'Portfolio',
                        icon: Icon(CupertinoIcons.chart_pie),
                        activeIcon: Icon(CupertinoIcons.chart_pie_fill),
                      ),
                      GlassBottomBarTab(
                        label: 'Activity',
                        icon: Icon(CupertinoIcons.arrow_2_circlepath),
                        activeIcon: Icon(
                          CupertinoIcons.arrow_2_circlepath_circle_fill,
                        ),
                      ),
                      GlassBottomBarTab(
                        label: 'Controls',
                        icon: Icon(CupertinoIcons.slider_horizontal_3),
                        activeIcon: Icon(CupertinoIcons.slider_horizontal_3),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildCurrentTab(BuildContext context) {
    switch (_selectedTabIndex) {
      case 1:
        return _buildActivityTab(context);
      case 2:
        return _buildControlsTab(context);
      case 0:
      default:
        return _buildPortfolioTab(context);
    }
  }

  Widget _buildPortfolioTab(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 128),
      children: <Widget>[
        GlassPanel(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Text(
                'Portfolio preview',
                style: TextStyle(
                  fontSize: 14,
                  letterSpacing: 0.4,
                  color: _liquidGlassDemoSecondaryTextColor,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                '8,420,500 MNT',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w700,
                  color: _liquidGlassDemoPrimaryTextColor,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                '+4.12% this month',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF7CFCF7),
                ),
              ),
              const SizedBox(height: 18),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: <Widget>[
                  const GlassChip(
                    label: 'Balanced profile',
                    icon: Icon(CupertinoIcons.waveform_path_ecg),
                    selected: true,
                  ),
                  GlassChip(
                    label: _selectedWatchlistIndex == 0
                        ? 'Cash ready'
                        : 'Growth watch',
                    icon: const Icon(CupertinoIcons.bolt_fill),
                    selected: true,
                    selectedColor: const Color(0x33FFD180),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                children: const <Widget>[
                  Expanded(
                    child: _DemoMetric(
                      label: 'Available cash',
                      value: '1.2M',
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: _DemoMetric(
                      label: 'Income',
                      value: '342K',
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: _DemoMetric(
                      label: 'Risk',
                      value: 'Moderate',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                children: <Widget>[
                  Expanded(
                    child: GlassButton.custom(
                      width: double.infinity,
                      height: 52,
                      label: 'Deposit cash',
                      shape: const LiquidRoundedSuperellipse(borderRadius: 18),
                      child: const _DemoButtonLabel(
                        icon: CupertinoIcons.arrow_down_circle_fill,
                        text: 'Deposit',
                      ),
                      onTap: () =>
                          _showMessage('Demo action: deposit cash flow'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: GlassButton.custom(
                      width: double.infinity,
                      height: 52,
                      label: 'View report',
                      shape: const LiquidRoundedSuperellipse(borderRadius: 18),
                      child: const _DemoButtonLabel(
                        icon: CupertinoIcons.doc_chart_fill,
                        text: 'Report',
                      ),
                      onTap: () =>
                          _showMessage('Demo action: monthly report preview'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 18),
        const _SectionTitle(
          title: 'Watchlist',
          subtitle: 'Scrollable glass cards with realistic investment data',
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: List<Widget>.generate(3, (int index) {
            final String label = switch (index) {
              0 => 'Income',
              1 => 'Growth',
              _ => 'Defensive',
            };
            return GlassChip(
              label: label,
              selected: _selectedWatchlistIndex == index,
              onTap: () => setState(() => _selectedWatchlistIndex = index),
            );
          }),
        ),
        const SizedBox(height: 14),
        ..._positions.map(_buildPositionCard),
      ],
    );
  }

  Widget _buildPositionCard(_DemoPosition position) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: GlassCard(
        padding: const EdgeInsets.all(18),
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: const Color(0x22FFFFFF),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    position.symbol,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        position.title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: _liquidGlassDemoPrimaryTextColor,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${position.allocation} allocation',
                        style: const TextStyle(
                          fontSize: 13,
                          color: _liquidGlassDemoSecondaryTextColor,
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  position.changeLabel,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: position.changeColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ClipRRect(
              borderRadius: BorderRadius.circular(999),
              child: LinearProgressIndicator(
                minHeight: 8,
                value: switch (position.symbol) {
                  'MND Bond' => 0.68,
                  'TCK' => 0.52,
                  _ => 0.34,
                },
                backgroundColor: const Color(0x18FFFFFF),
                valueColor: AlwaysStoppedAnimation<Color>(position.changeColor),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActivityTab(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 128),
      children: <Widget>[
        GlassPanel(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Row(
                children: <Widget>[
                  Icon(
                    CupertinoIcons.bell_fill,
                    color: Color(0xFFFFD180),
                    size: 20,
                  ),
                  SizedBox(width: 8),
                  Text(
                    'Market reminder',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: _liquidGlassDemoPrimaryTextColor,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              const Text(
                'Tomorrow at 09:30 the demo sends a market-open summary. This panel is useful for checking how large glass surfaces hold layered text and icons.',
                style: TextStyle(
                  height: 1.45,
                  fontSize: 14,
                  color: _liquidGlassDemoSecondaryTextColor,
                ),
              ),
              const SizedBox(height: 18),
              GlassButton.custom(
                width: double.infinity,
                height: 52,
                shape: const LiquidRoundedSuperellipse(borderRadius: 18),
                label: 'Preview reminder',
                child: const _DemoButtonLabel(
                  icon: CupertinoIcons.eye_fill,
                  text: 'Preview reminder',
                ),
                onTap: () =>
                    _showMessage('Demo reminder preview opened successfully'),
              ),
            ],
          ),
        ),
        const SizedBox(height: 18),
        const _SectionTitle(
          title: 'Recent activity',
          subtitle: 'Cards, timestamps, chips, and CTA controls in one feed',
        ),
        const SizedBox(height: 12),
        ..._activity.map(
          (item) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: GlassCard(
              padding: const EdgeInsets.all(18),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    width: 12,
                    height: 12,
                    margin: const EdgeInsets.only(top: 6),
                    decoration: BoxDecoration(
                      color: item.accent,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          item.title,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: _liquidGlassDemoPrimaryTextColor,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          item.subtitle,
                          style: const TextStyle(
                            fontSize: 14,
                            color: _liquidGlassDemoSecondaryTextColor,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          item.timestamp,
                          style: const TextStyle(
                            fontSize: 12,
                            letterSpacing: 0.2,
                            color: _liquidGlassDemoTertiaryTextColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    item.amount,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: item.accent,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildControlsTab(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 128),
      children: <Widget>[
        GlassPanel(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Text(
                'Interactive controls',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: _liquidGlassDemoPrimaryTextColor,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'This tab is intended for quick tactile checks: buttons, switches, spacing, and layered text while keeping the implementation isolated from production screens.',
                style: TextStyle(
                  height: 1.45,
                  fontSize: 14,
                  color: _liquidGlassDemoSecondaryTextColor,
                ),
              ),
              const SizedBox(height: 18),
              _SwitchRow(
                label: 'Trade alerts',
                value: _notificationsEnabled,
                onChanged: (bool value) {
                  setState(() => _notificationsEnabled = value);
                },
              ),
              const SizedBox(height: 16),
              _SwitchRow(
                label: 'Auto-sweep idle cash',
                value: _autoSweepEnabled,
                onChanged: (bool value) {
                  setState(() => _autoSweepEnabled = value);
                },
              ),
              const SizedBox(height: 16),
              _SwitchRow(
                label: 'Rebalance guardrails',
                value: _rebalanceProtectionEnabled,
                onChanged: (bool value) {
                  setState(() => _rebalanceProtectionEnabled = value);
                },
              ),
            ],
          ),
        ),
        const SizedBox(height: 18),
        GlassCard(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Text(
                'Quick actions',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: _liquidGlassDemoPrimaryTextColor,
                ),
              ),
              const SizedBox(height: 14),
              Row(
                children: <Widget>[
                  Expanded(
                    child: GlassButton.custom(
                      width: double.infinity,
                      height: 52,
                      label: 'Send test push',
                      shape: const LiquidRoundedSuperellipse(borderRadius: 18),
                      child: const _DemoButtonLabel(
                        icon: CupertinoIcons.paperplane_fill,
                        text: 'Send push',
                      ),
                      onTap: () =>
                          _showMessage('Demo push notification scheduled'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: GlassButton.custom(
                      width: double.infinity,
                      height: 52,
                      label: 'Show confirmation',
                      shape: const LiquidRoundedSuperellipse(borderRadius: 18),
                      child: const _DemoButtonLabel(
                        icon: CupertinoIcons.check_mark_circled_solid,
                        text: 'Confirm',
                      ),
                      onTap: () => _showMessage(
                        'Control interaction confirmed with liquid glass styling',
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Text(
                'Implementation note: scrollable content uses the package in standard quality mode for stability, while the app bar and bottom bar use premium quality to better showcase the surface effect.',
                style: TextStyle(
                  fontSize: 13,
                  height: 1.45,
                  color: _liquidGlassDemoSecondaryTextColor,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _showMessage(String message) {
    MiniAppToast.showInfo(context, message: message);
  }
}

class _LiquidGlassDemoFallback extends StatelessWidget {
  const _LiquidGlassDemoFallback({
    required this.title,
    required this.message,
    this.showProgress = false,
    this.actionLabel,
    this.onAction,
  });

  final String title;
  final String message;
  final bool showProgress;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: InvestXDesignTokens.softSurface,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                if (showProgress)
                  const Padding(
                    padding: EdgeInsets.only(bottom: 20),
                    child: CircularProgressIndicator.adaptive(),
                  ),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: _liquidGlassDemoPrimaryTextColor,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                Text(
                  message,
                  style: const TextStyle(
                    fontSize: 15,
                    height: 1.45,
                    color: _liquidGlassDemoSecondaryTextColor,
                  ),
                  textAlign: TextAlign.center,
                ),
                if (actionLabel != null && onAction != null) ...<Widget>[
                  const SizedBox(height: 20),
                  FilledButton(
                    onPressed: onAction,
                    child: Text(actionLabel!),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _LiquidGlassDemoBackground extends StatelessWidget {
  const _LiquidGlassDemoBackground();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: InvestXDesignTokens.softSurface,
      ),
      child: Stack(
        children: <Widget>[
          Positioned(
            top: -80,
            right: -40,
            child: _GlowOrb(
              size: 240,
              color: const Color(0x3378D6FF),
            ),
          ),
          Positioned(
            top: 180,
            left: -60,
            child: _GlowOrb(
              size: 220,
              color: const Color(0x33B7F0E8),
            ),
          ),
          Positioned(
            bottom: -50,
            right: 30,
            child: _GlowOrb(
              size: 200,
              color: const Color(0x33FFCBB8),
            ),
          ),
        ],
      ),
    );
  }
}

class _GlowOrb extends StatelessWidget {
  const _GlowOrb({
    required this.size,
    required this.color,
  });

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            colors: <Color>[
              color,
              color.withValues(alpha: 0),
            ],
          ),
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({
    required this.title,
    required this.subtitle,
  });

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: _liquidGlassDemoPrimaryTextColor,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          subtitle,
          style: const TextStyle(
            fontSize: 13,
            height: 1.4,
            color: _liquidGlassDemoSecondaryTextColor,
          ),
        ),
      ],
    );
  }
}

class _DemoMetric extends StatelessWidget {
  const _DemoMetric({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: _liquidGlassDemoPanelFillColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: _liquidGlassDemoTertiaryTextColor,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: _liquidGlassDemoPrimaryTextColor,
            ),
          ),
        ],
      ),
    );
  }
}

class _DemoButtonLabel extends StatelessWidget {
  const _DemoButtonLabel({
    required this.icon,
    required this.text,
  });

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Icon(icon, color: _liquidGlassDemoPrimaryTextColor, size: 18),
        const SizedBox(width: 8),
        Text(
          text,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: _liquidGlassDemoPrimaryTextColor,
          ),
        ),
      ],
    );
  }
}

class _SwitchRow extends StatelessWidget {
  const _SwitchRow({
    required this.label,
    required this.value,
    required this.onChanged,
  });

  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: _liquidGlassDemoPrimaryTextColor,
            ),
          ),
        ),
        GlassSwitch(
          value: value,
          onChanged: onChanged,
        ),
      ],
    );
  }
}

class _DemoPosition {
  const _DemoPosition({
    required this.symbol,
    required this.title,
    required this.allocation,
    required this.changeLabel,
    required this.changeColor,
  });

  final String symbol;
  final String title;
  final String allocation;
  final String changeLabel;
  final Color changeColor;
}

class _DemoActivityItem {
  const _DemoActivityItem({
    required this.title,
    required this.subtitle,
    required this.amount,
    required this.timestamp,
    required this.accent,
  });

  final String title;
  final String subtitle;
  final String amount;
  final String timestamp;
  final Color accent;
}
