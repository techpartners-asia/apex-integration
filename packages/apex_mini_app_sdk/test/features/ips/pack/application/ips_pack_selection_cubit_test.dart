import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mini_app_sdk/mini_app_sdk.dart';

void main() {
  final SdkLocalizations l10n = lookupSdkLocalizations(const Locale('en'));

  test('initial packs are shown without immediately calling getPacks', () {
    final _FakePackService service = _FakePackService();
    final IpsPackSelectionCubit cubit = IpsPackSelectionCubit(
      service: service,
      l10n: l10n,
      initialPacks: _testPacks,
    );

    expect(cubit.state.status, LoadableStatus.success);
    expect(cubit.state.data, _testPacks);
    expect(service.getPacksCallCount, 0);
  });

  test('load can still force refresh packs after initial data', () async {
    final _FakePackService service = _FakePackService();
    final IpsPackSelectionCubit cubit = IpsPackSelectionCubit(
      service: service,
      l10n: l10n,
      initialPacks: _testPacks,
    );

    await cubit.load(forceRefresh: true);

    expect(service.getPacksCallCount, 1);
    expect(service.lastForceRefresh, isTrue);
    expect(cubit.state.status, LoadableStatus.success);
    expect(cubit.state.data, _testPacks);
  });
}

const List<IpsPack> _testPacks = <IpsPack>[
  IpsPack(
    packCode: '1',
    name: 'Pack 1',
    isRecommended: 1,
    bondPercent: 85,
    stockPercent: 15,
    assetPercent: 0,
  ),
];

class _FakePackService implements PackService {
  int getPacksCallCount = 0;
  bool? lastForceRefresh;

  @override
  Future<List<IpsPack>> getPacks({
    String? srcFiCode,
    bool forceRefresh = false,
  }) async {
    getPacksCallCount += 1;
    lastForceRefresh = forceRefresh;
    return _testPacks;
  }
}
