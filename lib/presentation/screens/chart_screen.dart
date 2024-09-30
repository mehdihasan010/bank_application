import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import '../../data/api.dart';
import '../../data/model/transactions.dart';
import '../widget/transaction_card.dart';

class ChartScreen extends StatefulWidget {
  const ChartScreen({super.key});

  @override
  State<ChartScreen> createState() => _ChartScreenState();
}

class _ChartScreenState extends State<ChartScreen> {
  List<Transaction> transactions = [];
  bool isLoading = true;
  int userId = 1; // Replace with the actual user ID

  @override
  void initState() {
    super.initState();
    fetchTransactions();
  }

  Future<void> fetchTransactions() async {
    try {
      final fetchedTransactions = await ApiService.fetchTransactions(userId);
      setState(() {
        transactions = fetchedTransactions;
        //print(transactions);
        isLoading = false;
      });
    } catch (error) {
      //print(error);
      setState(() {
        isLoading = false;
      });
      // Handle error appropriately (e.g., show a dialog)
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment History'),
        centerTitle: true,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: transactions.map((transaction) {
                    return TransactionCard(
                      icon: transaction.type == 'withdraw'
                          ? Iconsax.send
                          : Iconsax.received,
                      iconColor: transaction.type == 'withdraw'
                          ? Colors.red
                          : Colors.green,
                      title: transaction.type,
                      amount: transaction.type == 'withdraw'
                          ? '-${transaction.amount.toString()}'
                          : '+${transaction.amount.toString()}',
                      date: transaction.date,
                    );
                  }).toList(),
                ),
              ),
            ),
    );
  }
}
