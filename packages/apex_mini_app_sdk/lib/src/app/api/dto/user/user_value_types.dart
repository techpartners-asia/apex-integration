part of '../user_entity_dto.dart';

/// String constants for KYC status values returned by the backend.
class KycStatusType {
  /// KYC has been submitted and is awaiting review.
  static const pending = 'pending';

  /// KYC has been approved.
  static const verified = 'verified';

  /// KYC has been rejected.
  static const rejected = 'rejected';

  /// Fallback status for missing or unrecognized values.
  static const unknown = 'unknown';
}

/// String constants for the host platform/source values in user payloads.
class PlatformType {
  /// Tino host platform.
  static const tino = 'tino';

  /// Grape host platform.
  static const grape = 'grape';

  /// Fallback platform for missing or unrecognized values.
  static const unknown = 'unknown';
}
