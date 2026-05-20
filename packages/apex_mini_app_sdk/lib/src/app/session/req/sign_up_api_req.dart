import '../../../core/exception/api_exception.dart';

/// Request body sent when bootstrapping/signing up a host user in Apex.
///
/// The mini app receives the host token through SDK config and forwards it to
/// the signup/bootstrap endpoint. Empty tokens are rejected before the network
/// call so host integration mistakes surface immediately.
class SignUpApiReq {
  /// Host-provided user token used by the backend to resolve/create the user.
  final String token;

  /// Creates a signup request from a host token.
  ///
  /// [token] is trimmed and must not be empty.
  SignUpApiReq({required String token}) : token = token.trim() {
    if (this.token.isEmpty) {
      throw const ApiIntegrationException(
        'signUp requires a non-empty host userToken.',
      );
    }
  }

  /// Converts this request to the backend JSON payload.
  Map<String, Object?> toJson() {
    return <String, Object?>{'token': token};
  }
}
