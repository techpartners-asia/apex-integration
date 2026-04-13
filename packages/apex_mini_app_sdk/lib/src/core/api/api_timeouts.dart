final class ApiTimeouts {
  static const Duration connect = Duration(seconds: 10);
  static const Duration send = Duration(seconds: 15);
  static const Duration receive = Duration(seconds: 15);

  const ApiTimeouts._();
}
