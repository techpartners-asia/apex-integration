extension SafeBoolExtension on bool? {
  bool get trueOrFalse => this ?? false;
}
