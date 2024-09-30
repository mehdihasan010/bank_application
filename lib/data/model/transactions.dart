class Transaction {
  final String type;
  final double amount;
  final String date;

  Transaction({required this.type, required this.amount, required this.date});

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      type: json['type'],
      amount: double.parse(json['amount']),
      date: json['date'],
    );
  }
}
