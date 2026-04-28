import 'package:mini_app_sdk/mini_app_sdk.dart';

abstract interface class PackService {
  Future<List<IpsPack>> getPacks({
    String? srcFiCode,
    bool forceRefresh = false,
  });
}
