/// Status values returned by the loyalty endpoint.
enum LoyaltyStatus {
  /// Milestone already completed.
  passed,

  /// Milestone currently in progress.
  active,

  /// Milestone not yet reached.
  inactive,
}

/// DTO for a single loyalty milestone from the backend.
class LoyaltyItemDto {
  /// Unique milestone id.
  final int id;

  /// Display name of the milestone.
  final String name;

  /// Bonus value.
  final int bonus;

  /// Bonus type (e.g. CUPON).
  final String bonusType;

  /// Current streak count.
  final int streak;

  /// Milestone status.
  final LoyaltyStatus status;

  /// Creates a loyalty item DTO.
  const LoyaltyItemDto({
    required this.id,
    required this.name,
    required this.bonus,
    required this.bonusType,
    required this.streak,
    required this.status,
  });

  /// Parses a single item from JSON.
  factory LoyaltyItemDto.fromJson(Map<String, Object?> json) {
    return LoyaltyItemDto(
      id: (json['id'] as num?)?.toInt() ?? 0,
      name: json['name'] as String? ?? '',
      bonus: (json['bonus'] as num?)?.toInt() ?? 0,
      bonusType: json['bonus_type'] as String? ?? '',
      streak: (json['streak'] as num?)?.toInt() ?? 0,
      status: _parseStatus(json['status'] as String?),
    );
  }

  /// Parses the list from the API envelope `{ "body": [...] }`.
  static List<LoyaltyItemDto> listFromJson(Map<String, Object?> json) {
    final Object? body = json['body'];
    if (body is! List) return const <LoyaltyItemDto>[];
    return body
        .whereType<Map<String, Object?>>()
        .map(LoyaltyItemDto.fromJson)
        .toList(growable: false);
  }

  static LoyaltyStatus _parseStatus(String? raw) {
    switch (raw?.toUpperCase()) {
      case 'PASSED':
        return LoyaltyStatus.passed;
      case 'ACTIVE':
        return LoyaltyStatus.active;
      default:
        return LoyaltyStatus.inactive;
    }
  }
}
