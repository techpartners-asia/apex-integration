/// Backend action names accepted by the profile update endpoint.
///
/// The API uses this string to distinguish a full profile update from a
/// targeted information update, so callers should pass one of these constants
/// instead of hardcoding action names in feature code.
class UpdateProfileActionType {
  /// Updates profile-level fields such as contact and bank information.
  static final String updateProfile = 'profile_update';

  /// Updates personal information fields used by onboarding.
  static final String updateInformation = 'information_update';
}

/// Request body used to update the current user's profile information.
///
/// All optional text values are trimmed before they are sent to the backend.
/// `actionType` is required because the endpoint changes behavior based on the
/// requested profile action.
class UpdateProfileApiReq {
  /// Optional bank account payload included when bank fields are submitted.
  final UpdateProfileBankApiReq? bank;

  /// User email address.
  final String? email;

  /// Primary phone number.
  final String? phone;

  /// Secondary phone number.
  final String? phoneAddition;

  /// Backend action name from [UpdateProfileActionType].
  final String actionType;

  /// Employment department used by extended personal information forms.
  final String? currentDepartment;

  /// Employment position used by extended personal information forms.
  final String? currentPosition;

  /// User gender value expected by the backend.
  final String? gender;

  /// User last name.
  final String? lastName;

  /// User first name.
  final String? firstName;

  /// Residential address entered during onboarding/profile update.
  final String? residenceAddress;

  /// Residential country value.
  final String? residenceCountry;

  /// Region identifier when the backend accepts a region mapping.
  final int? regionId;

  /// Creates a profile update request.
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

  /// Converts the request into the backend JSON field names.
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

/// Bank account payload nested inside [UpdateProfileApiReq].
///
/// This is used by the securities account onboarding personal-info step and by
/// profile updates that need to save IBAN/bank owner data.
class UpdateProfileBankApiReq {
  /// User bank account or IBAN number.
  final String accountNumber;

  /// Backend bank code selected from the bank list.
  final String bankCode;

  /// Human-readable bank name selected by the user.
  final String bankName;

  /// Account holder name resolved or entered for the bank account.
  final String accountName;

  /// Creates a profile bank update payload.
  const UpdateProfileBankApiReq({
    required this.accountNumber,
    required this.bankCode,
    required this.bankName,
    required this.accountName,
  });

  /// Converts the nested bank object into backend JSON field names.
  Map<String, Object?> toJson() {
    return <String, Object?>{
      'account_number': accountNumber.trim(),
      'bank_code': bankCode.trim(),
      'bank_name': bankName.trim(),
      'account_name': accountName.trim(),
    };
  }
}
