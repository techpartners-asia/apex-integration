import 'package:flutter/material.dart';
import 'package:mini_app_ui/mini_app_ui.dart';

import '../helpers/investx_design_tokens.dart';

const List<Color> _shimmerColors = <Color>[
  Color(0xFFF0ECE6),
  Color(0xFFF7F4EF),
  Color(0xFFF0ECE6),
];

class InvestXSkeletonLoader extends StatefulWidget {
  const InvestXSkeletonLoader({super.key});

  @override
  State<InvestXSkeletonLoader> createState() => _InvestXSkeletonLoaderState();
}

class _InvestXSkeletonLoaderState extends State<InvestXSkeletonLoader> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;

    return AnimatedBuilder(
      animation: _controller,
      builder: (BuildContext context, Widget? child) => child!,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: responsive.spacing.financialCardSpacing,
          vertical: responsive.spacing.sectionSpacing,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            _SkeletonCard(animation: _controller),
            SizedBox(height: responsive.spacing.cardGap),
            _SkeletonCard(animation: _controller, height: responsive.dp(120)),
            SizedBox(height: responsive.spacing.cardGap),
            _SkeletonLines(animation: _controller, lineCount: 3),
          ],
        ),
      ),
    );
  }
}

class _SkeletonCard extends StatelessWidget {
  const _SkeletonCard({required this.animation, this.height});

  final Animation<double> animation;
  final double? height;

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;
    final double h = height ?? responsive.dp(80);

    return AnimatedBuilder(
      animation: animation,
      builder: (BuildContext context, Widget? child) {
        return Container(
          height: h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(responsive.radius(12)),
            gradient: LinearGradient(
              begin: Alignment(-1.0 + 2.0 * animation.value, 0),
              end: Alignment(1.0 + 2.0 * animation.value, 0),
              colors: _shimmerColors,
            ),
          ),
        );
      },
    );
  }
}

class _SkeletonLines extends StatelessWidget {
  const _SkeletonLines({required this.animation, required this.lineCount});

  final Animation<double> animation;
  final int lineCount;

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: List<Widget>.generate(lineCount, (int index) {
        final double widthFactor = index == lineCount - 1 ? 0.6 : 1.0;
        return Padding(
          padding: EdgeInsets.only(bottom: responsive.dp(8)),
          child: FractionallySizedBox(
            widthFactor: widthFactor,
            child: AnimatedBuilder(
              animation: animation,
              builder: (BuildContext context, Widget? child) {
                return Container(
                  height: responsive.dp(14),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(responsive.dp(4)),
                    gradient: LinearGradient(
                      begin: Alignment(-1.0 + 2.0 * animation.value, 0),
                      end: Alignment(1.0 + 2.0 * animation.value, 0),
                      colors: _shimmerColors,
                    ),
                  ),
                );
              },
            ),
          ),
        );
      }),
    );
  }
}

class InvestXSkeletonListLoader extends StatefulWidget {
  const InvestXSkeletonListLoader({super.key, this.itemCount = 4});

  final int itemCount;

  @override
  State<InvestXSkeletonListLoader> createState() => _InvestXSkeletonListLoaderState();
}

class _InvestXSkeletonListLoaderState extends State<InvestXSkeletonListLoader> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;

    return AnimatedBuilder(
      animation: _controller,
      builder: (BuildContext context, Widget? child) => child!,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: responsive.spacing.financialCardSpacing,
          vertical: responsive.spacing.sectionSpacing,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: List<Widget>.generate(widget.itemCount, (int index) {
            return Padding(
              padding: EdgeInsets.only(bottom: responsive.spacing.cardGap),
              child: _SkeletonListItem(animation: _controller),
            );
          }),
        ),
      ),
    );
  }
}

class _SkeletonListItem extends StatelessWidget {
  const _SkeletonListItem({required this.animation});

  final Animation<double> animation;

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;

    return AnimatedBuilder(
      animation: animation,
      builder: (BuildContext context, Widget? child) {
        final Gradient shimmer = LinearGradient(
          begin: Alignment(-1.0 + 2.0 * animation.value, 0),
          end: Alignment(1.0 + 2.0 * animation.value, 0),
          colors: _shimmerColors,
        );

        return Container(
          padding: EdgeInsets.all(responsive.dp(16)),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(responsive.radius(12)),
            border: Border.all(color: InvestXDesignTokens.muted.withValues(alpha: 0.12)),
          ),
          child: Row(
            children: <Widget>[
              Container(
                width: responsive.dp(40),
                height: responsive.dp(40),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: shimmer,
                ),
              ),
              SizedBox(width: responsive.dp(12)),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    FractionallySizedBox(
                      widthFactor: 0.7,
                      child: Container(
                        height: responsive.dp(12),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(responsive.dp(3)),
                          gradient: shimmer,
                        ),
                      ),
                    ),
                    SizedBox(height: responsive.dp(6)),
                    FractionallySizedBox(
                      widthFactor: 0.4,
                      child: Container(
                        height: responsive.dp(10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(responsive.dp(3)),
                          gradient: shimmer,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
