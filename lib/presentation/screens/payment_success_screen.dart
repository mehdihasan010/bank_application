import 'package:bank_application/presentation/screens/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class PaymentSuccessScreen extends StatefulWidget {
  const PaymentSuccessScreen(
      {super.key, required this.amount, required this.paytype});
  final String? amount;
  final String paytype;

  @override
  State<PaymentSuccessScreen> createState() => _PaymentSuccessScreenState();
}

class _PaymentSuccessScreenState extends State<PaymentSuccessScreen> {
  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // Success Icon
              SvgPicture.asset(
                'assets/images/confirm.svg',
                height: 180,
                width: 180,
                // ignore: deprecated_member_use
                color: isDarkMode
                    ? const Color(0xFFFFFFFF)
                    : const Color(0xFF1B1B1B),
              ),
              const SizedBox(height: 30),

              // Success message
              Text(
                'Congratulation!',
                style: textTheme.displayMedium,
              ),
              const SizedBox(height: 20),

              // Vehicle Number
              Text(
                'You\'ve successfully completed a ${widget.paytype}  ${widget.amount}',
                textAlign: TextAlign.center,
                style: textTheme.labelLarge?.copyWith(color: Colors.grey),
              ),
              const SizedBox(height: 30),

              // "View All Tags" Button
            ],
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SizedBox(
            height: 60,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        const MainScreen(), // Replace with your HomeScreen widget
                  ),
                  (Route<dynamic> route) => false, // Remove all previous routes
                );
              },
              child: Text(
                'Back to Home',
                style: textTheme.titleLarge?.copyWith(color: Colors.white),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
