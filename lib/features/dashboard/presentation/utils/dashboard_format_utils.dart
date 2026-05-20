import 'package:flutter/material.dart';

String formatDashboardNumber(int number) {
  final text = number.toString();
  final buffer = StringBuffer();

  for (var i = 0; i < text.length; i++) {
    final positionFromEnd = text.length - i;
    buffer.write(text[i]);
    if (positionFromEnd > 1 && positionFromEnd % 3 == 1) {
      buffer.write(',');
    }
  }

  return buffer.toString();
}

String formatDashboardCurrency(double amount) {
  return '₹${formatDashboardNumber(amount.round())}';
}

Color colorFromHex(String hex) {
  final cleaned = hex.replaceFirst('#', '');
  return Color(int.parse('FF$cleaned', radix: 16));
}
