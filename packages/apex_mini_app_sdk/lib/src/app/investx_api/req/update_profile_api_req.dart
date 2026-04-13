class UpdateProfileActionType {
  static final String updateProfile = 'profile_update';
  static final String updateInformation = 'information_update';
}

class UpdateProfileApiReq {
  final UpdateProfileBankApiReq? bank;
  final String? email;
  final String? phone;
  final String? phoneAddition;
  final String actionType;
  final String? currentDepartment;
  final String? currentPosition;
  final String? gender;
  final String? lastName;
  final String? firstName;
  final String? residenceAddress;
  final String? residenceCountry;
  final int? regionId;

  const UpdateProfileApiReq({
    this.bank,
    this.email,
    this.phone,
    this.phoneAddition,
    required this.actionType,
    this.currentDepartment,
    this.currentPosition,
    this.gender,
    this.lastName,
    this.firstName,
    this.residenceAddress,
    this.residenceCountry,
    this.regionId,
  });

  Map<String, Object?> toJson() {
    return <String, Object?>{
      'bank': bank?.toJson(),
      'email': email?.trim(),
      'phone': phone?.trim(),
      'phone_addition': phoneAddition?.trim(),
      'action_type': actionType.trim(),
      'current_department': currentDepartment?.trim(),
      'current_position': currentPosition?.trim(),
      'gender': gender?.trim(),
      'last_name': lastName?.trim(),
      'first_name': firstName?.trim(),
      'residence_address': residenceAddress?.trim(),
      'residence_country': residenceCountry?.trim(),
      'region_id': 1,
    };
  }
}

class UpdateProfileBankApiReq {
  final String accountNumber;
  final String bankCode;
  final String bankName;
  final String accountName;

  const UpdateProfileBankApiReq({
    required this.accountNumber,
    required this.bankCode,
    required this.bankName,
    required this.accountName,
  });

  Map<String, Object?> toJson() {
    return <String, Object?>{
      'account_number': accountNumber.trim(),
      'bank_code': bankCode.trim(),
      'bank_name': bankName.trim(),
      'account_name': accountName.trim(),
    };
  }
}
