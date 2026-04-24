import 'package:mini_app_ui/mini_app_ui.dart';
import 'package:flutter/material.dart';
import 'package:mini_app_sdk/mini_app_sdk.dart';

class SecAcntBankSelectionSheet extends StatefulWidget {
  final SecAcntBankOption? selectedBank;
  final SecAcntBankOptionsRepository bankOptionsRepository;

  const SecAcntBankSelectionSheet({super.key, required this.selectedBank, required this.bankOptionsRepository});

  @override
  State<SecAcntBankSelectionSheet> createState() => _SecAcntBankSelectionSheetState();
}

class _SecAcntBankSelectionSheetState extends State<SecAcntBankSelectionSheet> {
  late Future<List<SecAcntBankOption>> _bankOptionsFuture;

  @override
  void initState() {
    super.initState();
    _bankOptionsFuture = _loadBankOptions();
  }

  Future<List<SecAcntBankOption>> _loadBankOptions({bool forceRefresh = false}) {
    return widget.bankOptionsRepository.getBankOptions(forceRefresh: forceRefresh);
  }

  void _retry() {
    setState(() => _bankOptionsFuture = _loadBankOptions(forceRefresh: true));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final responsive = context.responsive;
    final int crossAxisCount = switch (responsive.sizeClass) {
      MiniAppSizeClass.compact => 4,
      MiniAppSizeClass.medium => 5,
      MiniAppSizeClass.expanded => 6,
    };

    return ActionSheet(
      title: l10n.secAcntBankSelectionTitle,
      titleStyle: Theme.of(context).textTheme.titleMedium?.copyWith(
        color: DesignTokens.ink,
        fontWeight: MiniAppTypography.bold,
      ),
      showHandle: false,
      trailing: MiniAppAdaptiveIconButton(
        icon: Icons.close_rounded,
        onPressed: () => Navigator.maybePop(context),
        size: responsive.dp(36),
        iconSize: responsive.dp(16),
        backgroundColor: const Color(0xFFF4F6FA),
        foregroundColor: DesignTokens.ink,
        boxShadow: const <BoxShadow>[],
      ),
      child: FutureBuilder<List<SecAcntBankOption>>(
        future: _bankOptionsFuture,
        builder: (BuildContext context, AsyncSnapshot<List<SecAcntBankOption>> snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return _SecAcntSheetStatusView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  SizedBox(
                    width: responsive.component(24),
                    height: responsive.component(24),
                    child: const CircularProgressIndicator(
                      strokeWidth: 2.5,
                    ),
                  ),
                  SizedBox(height: responsive.space(AppSpacing.md)),
                  CustomText(l10n.commonLoading, style: Theme.of(context).textTheme.bodyMedium),
                ],
              ),
            );
          }

          if (snapshot.hasError) {
            return _SecAcntSheetStatusView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  CustomText(
                    l10n.errorsApiLoadFailed,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  SizedBox(height: responsive.space(AppSpacing.md)),
                  SecondaryButton(
                    label: l10n.commonRetry,
                    onPressed: _retry,
                  ),
                ],
              ),
            );
          }

          final List<SecAcntBankOption> bankOptions = snapshot.data ?? const <SecAcntBankOption>[];
          if (bankOptions.isEmpty) {
            return _SecAcntSheetStatusView(
              child: CustomText(
                l10n.commonNoData,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            );
          }

          return GridView.builder(
            shrinkWrap: true,
            physics: const ScrollPhysics(),
            itemCount: bankOptions.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              crossAxisSpacing: responsive.dp(10),
              mainAxisSpacing: responsive.dp(10),
              mainAxisExtent: responsive.dp(100),
            ),
            itemBuilder: (BuildContext context, int index) {
              final SecAcntBankOption bank = bankOptions[index];
              final bool selected = widget.selectedBank == bank;
              return BankAccountTile(
                bank: bank,
                selected: selected,
                onTap: () => Navigator.pop(context, bank),
              );
            },
          );
        },
      ),
    );
  }
}

class _SecAcntSheetStatusView extends StatelessWidget {
  final Widget child;

  const _SecAcntSheetStatusView({required this.child});

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;

    return Padding(
      padding: responsive.insetsSymmetric(horizontal: AppSpacing.md, vertical: AppSpacing.lg),
      child: Center(child: child),
    );
  }
}
