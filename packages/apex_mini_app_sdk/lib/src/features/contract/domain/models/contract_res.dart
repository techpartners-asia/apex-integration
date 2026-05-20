/// Domain result returned after creating/confirming a contract.
class ContractRes {
  /// Backend contract identifier.
  final String contractId;

  /// Backend message to show or log.
  final String message;

  /// Creates the contract result domain object.
  const ContractRes({required this.contractId, required this.message});
}
