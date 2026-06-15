import 'package:shared_preferences/shared_preferences.dart';

/// Persists questionnaire flow flags across sessions using SharedPreferences.
class QuestionnaireLocalPrefs {
  QuestionnaireLocalPrefs._();

  static const String _keyHasAcceptedAgreement =
      'questionnaire_has_accepted_agreement';
  static const String _keyHasUploadedSignature =
      'questionnaire_has_uploaded_signature';

  static bool _hasAcceptedAgreement = false;
  static bool _hasUploadedSignature = false;

  /// Loads stored flags into memory. Call once before the flow starts.
  static Future<void> init() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    _hasAcceptedAgreement =
        prefs.getBool(_keyHasAcceptedAgreement) ?? false;
    _hasUploadedSignature =
        prefs.getBool(_keyHasUploadedSignature) ?? false;
  }

  /// Whether the user has previously accepted the questionnaire agreement.
  static bool get hasAcceptedAgreement => _hasAcceptedAgreement;

  /// Whether the user has previously uploaded a questionnaire signature.
  static bool get hasUploadedSignature => _hasUploadedSignature;

  /// Whether both agreement and signature steps have been completed.
  static bool get hasCompletedAgreementAndSignature =>
      _hasAcceptedAgreement && _hasUploadedSignature;

  /// Marks the questionnaire agreement as accepted and persists it.
  static Future<void> markAgreementAccepted() async {
    _hasAcceptedAgreement = true;
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyHasAcceptedAgreement, true);
  }

  /// Marks the questionnaire signature as uploaded and persists it.
  static Future<void> markSignatureUploaded() async {
    _hasUploadedSignature = true;
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyHasUploadedSignature, true);
  }

  /// Clears all persisted questionnaire flags. Use for testing/debug only.
  static Future<void> reset() async {
    _hasAcceptedAgreement = false;
    _hasUploadedSignature = false;
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyHasAcceptedAgreement);
    await prefs.remove(_keyHasUploadedSignature);
  }
}
