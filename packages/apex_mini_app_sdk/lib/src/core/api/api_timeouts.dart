final class ApiTimeouts {
  static const Duration connect = Duration(seconds: 30);
  static const Duration send = Duration(seconds: 30);
  static const Duration receive = Duration(seconds: 30);

  const ApiTimeouts._();
}
