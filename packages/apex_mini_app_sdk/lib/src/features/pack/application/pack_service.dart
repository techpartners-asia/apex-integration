import 'package:apex_mini_app_sdk/apex_mini_app_sdk.dart';

abstract interface class PackService {
  Future<List<IpsPack>> getPacks({
    String? srcFiCode,
    bool forceRefresh = false,
  });
}
