import 'package:intl/intl.dart';

class BalanceFormate {
  late NumberFormat _numberFormat;

  BalanceFormate() {
    _numberFormat = NumberFormat('#,##0.00', 'en_US');
  }
  String formatBalance(double balance) {
    return _numberFormat.format(balance);
  }
}
