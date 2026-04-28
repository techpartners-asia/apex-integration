import 'package:flutter/material.dart';
import 'package:mini_app_ui/mini_app_ui.dart';
import 'package:mini_app_sdk/mini_app_sdk.dart';

class ContractQuantityKeypad extends StatelessWidget {
  const ContractQuantityKeypad({
    super.key,
    required this.onDigitPressed,
    required this.onBackspacePressed,
  });

  final ValueChanged<int> onDigitPressed;
  final VoidCallback onBackspacePressed;

  static const Map<int, String> _digitLabels = <int, String>{
    2: 'ABC',
    3: 'DEF',
    4: 'GHI',
    5: 'JKL',
    6: 'MNO',
    7: 'PQRS',
    8: 'TUV',
    9: 'WXYZ',
  };

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;

    return Column(
      children: <Widget>[
        _KeypadRow(
          children: <Widget>[
            _KeypadButton(digit: 1, onPressed: () => onDigitPressed(1)),
            _KeypadButton(
              digit: 2,
              label: _digitLabels[2],
              onPressed: () => onDigitPressed(2),
            ),
            _KeypadButton(
              digit: 3,
              label: _digitLabels[3],
              onPressed: () => onDigitPressed(3),
            ),
          ],
        ),
        SizedBox(height: responsive.spacing.inlineSpacing * 0.9),
        _KeypadRow(
          children: <Widget>[
            _KeypadButton(
              digit: 4,
              label: _digitLabels[4],
              onPressed: () => onDigitPressed(4),
            ),
            _KeypadButton(
              digit: 5,
              label: _digitLabels[5],
              onPressed: () => onDigitPressed(5),
            ),
            _KeypadButton(
              digit: 6,
              label: _digitLabels[6],
              onPressed: () => onDigitPressed(6),
            ),
          ],
        ),
        SizedBox(height: responsive.spacing.inlineSpacing * 0.9),
        _KeypadRow(
          children: <Widget>[
            _KeypadButton(
              digit: 7,
              label: _digitLabels[7],
              onPressed: () => onDigitPressed(7),
            ),
            _KeypadButton(
              digit: 8,
              label: _digitLabels[8],
              onPressed: () => onDigitPressed(8),
            ),
            _KeypadButton(
              digit: 9,
              label: _digitLabels[9],
              onPressed: () => onDigitPressed(9),
            ),
          ],
        ),
        SizedBox(height: responsive.spacing.inlineSpacing * 0.9),
        _KeypadRow(
          children: <Widget>[
            const _KeypadSpacer(),
            _KeypadButton(digit: 0, onPressed: () => onDigitPressed(0)),
            _KeypadActionButton(
              icon: Icons.backspace_outlined,
              onPressed: onBackspacePressed,
            ),
          ],
        ),
      ],
    );
  }
}

class _KeypadSpacer extends StatelessWidget {
  const _KeypadSpacer();

  @override
  Widget build(BuildContext context) {
    return SizedBox(height: context.responsive.dp(68));
  }
}

class _KeypadRow extends StatelessWidget {
  const _KeypadRow({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;

    return Row(
      children: children
          .map(
            (Widget child) => Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: responsive.spacing.inlineSpacing * 0.35,
                ),
                child: child,
              ),
            ),
          )
          .toList(growable: false),
    );
  }
}

class _KeypadButton extends StatelessWidget {
  const _KeypadButton({
    required this.digit,
    required this.onPressed,
    this.label,
  });

  final int digit;
  final String? label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(responsive.radius(16)),
        border: Border.all(color: DesignTokens.border),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(responsive.radius(16)),
          child: SizedBox(
            height: responsive.dp(68),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                CustomText(
                  digit.toString(),
                  variant: MiniAppTextVariant.subtitle2,
                  color: DesignTokens.ink,
                ),
                if (label != null) ...<Widget>[
                  SizedBox(height: responsive.spacing.inlineSpacing * 0.25),
                  CustomText(
                    label!,
                    variant: MiniAppTextVariant.overline2,
                    color: DesignTokens.muted,
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

class _KeypadActionButton extends StatelessWidget {
  const _KeypadActionButton({required this.icon, required this.onPressed});

  final IconData icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(responsive.radius(16)),
        border: Border.all(color: DesignTokens.border),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(responsive.radius(16)),
          child: SizedBox(
            height: responsive.dp(68),
            child: Center(
              child: Icon(
                icon,
                color: DesignTokens.ink,
                size: responsive.dp(24),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
