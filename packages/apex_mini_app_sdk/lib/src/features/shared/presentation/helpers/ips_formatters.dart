import 'package:intl/intl.dart';

/// Formats an amount with two decimals and a resolved currency symbol.
String formatIpsAmount(double amount, String currency) {
  return '${amount.toStringAsFixed(2)} ${convertCurrencyToSymbol(currency)}';
}

/// Formats payment amounts with Mongolian currency conventions by default.
String formatIpsPaymentAmount(
  double amount,
  String currency, {
  bool showDecimal = false,
}) {
  final String normalizedCurrency = currency.trim().toUpperCase();
  if ((normalizedCurrency.isEmpty ||
          normalizedCurrency == 'MNT' ||
          normalizedCurrency == '₮') &&
      !showDecimal) {
    return NumberFormat.currency(
      locale: 'mn_MN',
      symbol: '₮',
      decimalDigits: 0,
      customPattern: '#,##0¤',
    ).format(amount);
  }

  return NumberFormat.currency(
    locale: 'en_US',
    symbol: convertCurrencyToSymbol(currency),
    decimalDigits: amount % 1 == 0 ? 0 : 2,
    customPattern: '#,##0.##¤',
  ).format(amount);
}

/// Formats a local IPS timestamp for list/detail screens.
String formatIpsDate(DateTime dateTime) {
  return DateFormat('yyyy-MM-dd HH:mm').format(dateTime.toLocal());
}

/// Converts common currency codes to display symbols.
String convertCurrencyToSymbol(String currency) {
  switch (currency) {
    case 'MNT':
      return '₮';
    case 'USD':
      return '\$';
    case 'EUR':
      return '€';
    case 'JPY':
      return '¥';
    case 'GBP':
      return '£';
    default:
      return '₮';
  }
}
