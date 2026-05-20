import 'package:apex_mini_app_sdk/apex_mini_app_sdk.dart';

/// Domain request used when creating or confirming an investment contract.
class ContractReq {
  /// Selected investment package.
  final IpsPack pack;

  /// Questionnaire result used to determine the package recommendation.
  final QuestionnaireRes questionnaireRes;

  /// Creates the contract request domain object.
  const ContractReq({required this.pack, required this.questionnaireRes});
}
