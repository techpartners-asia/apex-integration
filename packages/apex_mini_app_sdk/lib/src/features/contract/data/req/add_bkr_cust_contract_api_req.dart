import 'package:mini_app_sdk/mini_app_sdk.dart';

class AddBkrCustContractApiReq {
  final String srcFiCode;
  final String bankCode;
  final String bankAcntCode;
  final String bankAcntName;
  final String verfType;

  const AddBkrCustContractApiReq({
    required this.srcFiCode,
    required this.bankCode,
    required this.bankAcntCode,
    required this.bankAcntName,
    this.verfType = IpsDefaults.contractVerificationType,
  });

  Map<String, Object?> toJson() {
    return <String, Object?>{
      'srcFiCode': srcFiCode,
      'bankCode': bankCode,
      'bankAcntCode': bankAcntCode,
      'bankAcntName': bankAcntName,
      'verfType': verfType,
    };
  }
}
