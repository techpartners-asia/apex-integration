import 'package:mini_app_sdk/mini_app_sdk.dart';

class ContractPayload {
  final IpsPack pack;
  final QuestionnaireRes? res;

  const ContractPayload({required this.pack, this.res});
}
