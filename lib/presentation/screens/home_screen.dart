import 'package:bank_application/presentation/screens/notification_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';

import '../../data/api.dart';
import '../../data/model/transactions.dart';
import '../widget/balance_card.dart';
import '../widget/credit_cards.dart';
import '../widget/transaction_card.dart';
import 'payment_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Transaction> transactions = [];
  double balance = 0.0;
  bool isLoading = true;
  int userId = 1; // Replace with the actual user ID

  @override
  void initState() {
    super.initState();
    fetchTransactions();
    fetchBalance();
  }

  Future<void> fetchTransactions() async {
    try {
      final fetchedTransactions = await ApiService.fetchTransactions(userId);
      setState(() {
        transactions = fetchedTransactions;
        isLoading = false;
      });
    } catch (error) {
      setState(() {
        isLoading = false;
      });
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load transactions: $error')),
      );
    }
  }

  Future<void> fetchBalance() async {
    var response =
        await ApiService.getBalance(userId); // Call getBalance statically
    setState(() {
      balance = response!; // Update your state with the fetched balance
    });
  }

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: false,
        title: Text(
          'OstadBank',
          style: GoogleFonts.reemKufiFun(
              textStyle: const TextStyle(
                  color: Colors.black, fontSize: 24, letterSpacing: 2)),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconBtnWithCounter(
              svgSrc: bellIcon,
              numOfitem: 3,
              press: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) =>
                        const NotificationScreen(),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BalanceCard(
              balance: balance,
              userId: userId,
            ),
            const SizedBox(height: 20),

            // Buttons Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: MediaQuery.sizeOf(context).width * 0.4,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (BuildContext context) => PaymentScreen(
                            opration: 'Withdraw',
                            balance: balance,
                            userId: userId,
                          ),
                        ),
                      );
                    },
                    icon: const Icon(
                      Iconsax.send,
                      color: Colors.black,
                      size: 28,
                    ),
                    label: Text(
                      'Withdraw',
                      style: textTheme.titleSmall,
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFECA65),
                    ),
                  ),
                ),
                SizedBox(
                  width: MediaQuery.sizeOf(context).width * 0.4,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (BuildContext context) => PaymentScreen(
                              opration: 'Deposit',
                              balance: balance,
                              userId: userId),
                        ),
                      );
                    },
                    icon: const Icon(
                      Iconsax.received,
                      color: Colors.black,
                      size: 30,
                    ),
                    label: Text(
                      'Deposit',
                      style: textTheme.titleSmall,
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFB3E0B8),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 40),

            // Recent Transactions Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Recent Transactions',
                  style: textTheme.headlineSmall,
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Transaction Cards
            isLoading
                ? const Center(child: CircularProgressIndicator())
                : Expanded(
                    child: ListView(
                      children: transactions.take(5).map((transaction) {
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
          ],
        ),
      ),
      //bottomNavigationBar: const BottomNavigation(),
    );
  }
}
