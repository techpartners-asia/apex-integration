import 'package:apex_mini_app_sdk/apex_mini_app_sdk.dart';

/// Investment pack service contract.
abstract interface class PackService {
  /// Loads available packs, optionally scoped by source FI code.
  Future<List<IpsPack>> getPacks({
    String? srcFiCode,
    bool forceRefresh = false,
  });
}
