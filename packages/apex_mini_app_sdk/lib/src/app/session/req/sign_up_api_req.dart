import '../../../core/exception/api_exception.dart';

class SignUpApiReq {
  final String token;

  SignUpApiReq({required String token}) : token = token.trim() {
    if (this.token.isEmpty) {
      throw const ApiIntegrationException(
        'signUp requires a non-empty host userToken.',
      );
    }
  }

  Map<String, Object?> toJson() {
    return <String, Object?>{'token': token};
  }
}
