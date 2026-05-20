import 'package:apex_mini_app_sdk/apex_mini_app_sdk.dart';

/// Contract setup service contract.
abstract interface class ContractService {
  /// Adds/initializes broker-customer contract.
  Future<ContractRes> addBrokerCustContract();
}
