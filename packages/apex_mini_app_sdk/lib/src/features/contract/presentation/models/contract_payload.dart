import 'package:apex_mini_app_sdk/apex_mini_app_sdk.dart';

class ContractPayload {
  final IpsPack pack;
  final QuestionnaireRes? res;

  const ContractPayload({required this.pack, this.res});
}
