import 'package:apex_mini_app_sdk/apex_mini_app_sdk_internal.dart';

class ContractPayload {
  final IpsPack pack;
  final QuestionnaireRes? res;

  const ContractPayload({required this.pack, this.res});
}
