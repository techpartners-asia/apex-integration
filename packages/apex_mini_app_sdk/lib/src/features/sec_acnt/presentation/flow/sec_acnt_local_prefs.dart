import 'package:shared_preferences/shared_preferences.dart';

/// Persists sec_acnt flow flags across sessions using SharedPreferences.
class SecAcntLocalPrefs {
  SecAcntLocalPrefs._();

  static const String _keyHasAcceptedSecAgreement = 'sec_acnt_has_accepted_sec_agreement';

  static bool _hasAcceptedSecAgreement = false;

  /// Loads stored flags into memory. Call once before the flow starts.
  static Future<void> init() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    _hasAcceptedSecAgreement = prefs.getBool(_keyHasAcceptedSecAgreement) ?? false;
  }

  /// Whether the user has previously accepted the securities account agreement.
  static bool get hasAcceptedSecAgreement => _hasAcceptedSecAgreement;

  /// Marks the securities account agreement as accepted and persists it.
  static Future<void> markSecAgreementAccepted() async {
    _hasAcceptedSecAgreement = true;
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyHasAcceptedSecAgreement, true);
  }

  /// Clears all persisted sec_acnt flags. Use for testing/debug only.
  static Future<void> reset() async {
    _hasAcceptedSecAgreement = false;
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyHasAcceptedSecAgreement);
  }
}
