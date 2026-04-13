import 'package:intl/intl.dart';

String formatIpsAmount(double amount, String currency) {
  return '${amount.toStringAsFixed(2)} $currency';
}

String formatIpsPaymentAmount(double amount, String currency) {
  final String normalizedCurrency = currency.trim().toUpperCase();
  if (normalizedCurrency.isEmpty || normalizedCurrency == 'MNT' || normalizedCurrency == '₮') {
    return NumberFormat.currency(
      locale: 'mn_MN',
      symbol: '₮',
      decimalDigits: 0,
      customPattern: '#,##0¤',
    ).format(amount);
  }

  return NumberFormat.currency(
    locale: 'en_US',
    symbol: '$currency ',
    decimalDigits: amount % 1 == 0 ? 0 : 2,
    customPattern: '#,##0.##¤',
  ).format(amount);
}

String formatIpsDate(DateTime dateTime) {
  return DateFormat('yyyy-MM-dd HH:mm').format(dateTime.toLocal());
}
