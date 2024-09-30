import 'package:bank_application/presentation/screens/payment_success_screen.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:slide_to_act/slide_to_act.dart';

import '../../data/api.dart';
import '../widget/key_pad.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen(
      {super.key,
      required this.opration,
      required this.balance,
      required this.userId});
  final String opration;
  final double balance;
  final int userId;

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  String amount = '10'; // Initial amount
  var f = NumberFormat('#,##0.00', 'en_US');
  bool isFetchingBalance = false;
  bool isTransaction = false;
  final GlobalKey<SlideActionState> _slideActionKey = GlobalKey();

  void _onKeypadTap(String value) {
    setState(() {
      if (value == 'C') {
        if (amount.isNotEmpty) {
          amount = amount.substring(
              0, amount.length - 1); // Remove the last character
        }
      } else {
        amount += value; // Append value
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 40),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    isFetchingBalance
                        ? const CircularProgressIndicator() // Show loading indicator if fetching balance
                        : Text(
                            'Balance \$${f.format(widget.balance)}',
                            style: const TextStyle(fontSize: 20),
                          ),
                    const SizedBox(height: 30),
                    Text(
                      '\$$amount',
                      style: const TextStyle(
                          fontSize: 48, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
            Keypad(
              onKeypadTap: _onKeypadTap,
            ),
            _payButton2(),
          ],
        ),
      ),
    );
  }

  Widget _payButton2() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SlideAction(
        key: _slideActionKey,
        text: 'Slide to ${widget.opration}',
        sliderButtonIcon: const Icon(
          Iconsax.dollar_circle,
          color: Colors.black,
          size: 20,
        ),
        borderRadius: 12,
        outerColor: const Color(0xFF1B1B1B),
        onSubmit: () async {
          setState(() {
            isTransaction = true; // Start loading
          });

          bool response = await handleTransaction(widget.opration, amount);

          setState(() {
            isTransaction = false; // Stop loading
          });

          if (response) {
            if (mounted) {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) => PaymentSuccessScreen(
                    amount: '\$$amount',
                    paytype: widget.opration,
                  ),
                ),
                (Route<dynamic> route) => false, // Remove all previous routes
              );
            }
          } else {
            // Optionally handle transaction failure (e.g., show a snackbar)
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text('Transaction failed. Please try again.')),
              );
            }
          }
        },
      ),
    );
  }

  Future<bool> handleTransaction(String operation, String amount) async {
    try {
      double parsedAmount = double.parse(amount);
      if (operation == 'Deposit') {
        return await ApiService.addMoney(1, parsedAmount);
      } else if (operation == 'Withdraw') {
        return await ApiService.withdraw(1, parsedAmount);
      }
    } catch (e) {
      // Handle parsing error or API call failure
      // ignore: avoid_print
      print('Error: $e');
    }
    return false; // Return false in case of failure
  }

  @override
  void dispose() {
    super.dispose();
  }
}
