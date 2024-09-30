import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class BalanceCard extends StatefulWidget {
  const BalanceCard({super.key, required this.balance, required this.userId});
  final double balance;
  final int userId;

  @override
  State<BalanceCard> createState() => _BalanceCardState();
}

class _BalanceCardState extends State<BalanceCard> {
  var f = NumberFormat('#,##0.00', 'en_US');

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: const DecorationImage(
          image: AssetImage('assets/images/containerbg.png'),
          fit: BoxFit.cover,
        ),
        borderRadius: BorderRadius.circular(14),
      ),
      padding: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                CircleAvatar(
                  backgroundImage: AssetImage('assets/images/profile.jpeg'),
                  radius: 30,
                ),
                SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Mehdi Hassan',
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2),
                    ),
                    Text('Good Afternoon'),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Text(
              'Total Balance',
              style: TextStyle(color: Colors.black54, fontSize: 16),
            ),
            Text(
              '\$${f.format(widget.balance)}',
              style: const TextStyle(
                  fontSize: 34, fontWeight: FontWeight.bold, letterSpacing: 1),
            ),
            const SizedBox(height: 10),
            const Text(
              '1234 **** **** 7985',
              style: TextStyle(
                  color: Colors.black54, fontSize: 16, letterSpacing: 4),
            ),
          ],
        ),
      ),
    );
  }
}
