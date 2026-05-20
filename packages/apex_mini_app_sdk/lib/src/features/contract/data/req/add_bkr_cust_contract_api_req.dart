import 'package:apex_mini_app_sdk/apex_mini_app_sdk.dart';

/// Request body for adding a broker customer contract.
class AddBkrCustContractApiReq {
  /// Source financial institution code.
  final String srcFiCode;

  /// Selected bank code.
  final String bankCode;

  /// Bank account or IBAN code.
  final String bankAcntCode;

  /// Bank account holder name.
  final String bankAcntName;

  /// Verification type expected by the contract endpoint.
  final String verfType;

  /// Creates a broker customer contract request.
  const AddBkrCustContractApiReq({
    required this.srcFiCode,
    required this.bankCode,
    required this.bankAcntCode,
    required this.bankAcntName,
    this.verfType = IpsDefaults.contractVerificationType,
  });

  /// Converts this contract request to backend JSON.
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
