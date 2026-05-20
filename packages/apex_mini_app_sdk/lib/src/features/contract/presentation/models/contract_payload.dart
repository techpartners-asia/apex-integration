import 'package:apex_mini_app_sdk/apex_mini_app_sdk.dart';

/// Navigation payload passed from pack selection into contract flow.
class ContractPayload {
  /// Selected investment pack.
  final IpsPack pack;

  /// Optional questionnaire result that led to this contract.
  final QuestionnaireRes? res;

  /// Creates navigation payload for the contract route.
  const ContractPayload({required this.pack, this.res});
}
