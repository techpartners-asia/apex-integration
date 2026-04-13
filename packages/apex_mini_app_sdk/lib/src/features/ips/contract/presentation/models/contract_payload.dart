import '../../../shared/domain/models/ips_models.dart';

class ContractPayload {
  final IpsPack pack;
  final QuestionnaireRes? res;

  const ContractPayload({required this.pack, this.res});
}
