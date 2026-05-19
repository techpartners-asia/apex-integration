import 'package:apex_mini_app_sdk/apex_mini_app_sdk_internal.dart';

abstract interface class PackService {
  Future<List<IpsPack>> getPacks({
    String? srcFiCode,
    bool forceRefresh = false,
  });
}
