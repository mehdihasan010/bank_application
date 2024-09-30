// ignore_for_file: avoid_print

import 'dart:async';

import 'package:bank_application/presentation/screens/sign_in_screen.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../../data/api.dart';

class OtpScreen extends StatefulWidget {
  const OtpScreen({super.key, required this.email});
  final String email;

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  late Timer _timer;
  int _secondsRemaining = 0;
  int seconds = 60;
  String otp = '';
  // ignore: prefer_final_fields
  bool _hasError = false; // To track whether there's an error

  @override
  void initState() {
    super.initState();
    _secondsRemaining = seconds;
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining == 0) {
        timer.cancel();
      } else {
        setState(() {
          _secondsRemaining--;
        });
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  Future<void> _validateOTP() async {
    bool result = await ApiService.validateOTP(widget.email, otp);

    if (result) {
      _showSnackBar('Successfully Signup.');
      Navigator.pushAndRemoveUntil(
        // ignore: use_build_context_synchronously
        context,
        MaterialPageRoute(
          builder: (context) => const SignInScreen(),
        ),
        (Route<dynamic> route) => false,
      );
    } else {
      // Show error from result
      _showSnackBar('Invalid OTP');
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
      backgroundColor: Colors.teal,
      behavior: SnackBarBehavior.floating,
    ));
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 100),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _buildHeader(textTheme),
              const SizedBox(height: 40),
              _buildDescription(textTheme),
              const SizedBox(height: 80),
              _buildPinCodeField(context),
              const SizedBox(height: 50),
              _buildVerifyButton(),
              const SizedBox(height: 30),
              _buildResendText(context),
              const SizedBox(height: 4),
              _buildCountdownTimer(textTheme),
              // Show error message if needed
              if (_hasError)
                const Padding(
                  padding: EdgeInsets.only(top: 20),
                  child: Text(
                    'Please enter a valid 6-digit code',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
            ],
          ),
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FloatingActionButton(
          backgroundColor: const Color(0xFF1B1B1B),
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Icon(
            Iconsax.arrow_left_2,
            color: Colors.white,
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
    );
  }

  Widget _buildHeader(TextTheme textTheme) {
    return Text(
      'Almost there',
      style: textTheme.headlineLarge?.copyWith(fontWeight: FontWeight.bold),
    );
  }

  Widget _buildDescription(TextTheme textTheme) {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        text: 'Please enter the 6-digit code sent to your email ',
        style: textTheme.titleSmall?.copyWith(color: Colors.black),
        children: [
          TextSpan(
            text: widget.email,
            style: textTheme.titleSmall?.copyWith(color: Colors.red),
            children: [
              TextSpan(
                text: 'for verification.',
                style: textTheme.titleSmall?.copyWith(color: Colors.black),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPinCodeField(BuildContext context) {
    return PinCodeTextField(
      appContext: context,
      keyboardType: TextInputType.number,
      length: 6,
      obscureText: false,
      animationType: AnimationType.fade,
      cursorColor: Colors.black45,
      pinTheme: PinTheme(
        shape: PinCodeFieldShape.box,
        borderRadius: BorderRadius.circular(5),
        fieldHeight: 50,
        fieldWidth: 40,
        // Conditional fill colors depending on error state
        activeFillColor: _hasError
            ? Colors.red.withOpacity(0.3)
            : const Color(0xFFC4C4C4).withOpacity(0.4),
        inactiveFillColor: _hasError
            ? Colors.red.withOpacity(0.3)
            : const Color(0xFFC4C4C4).withOpacity(0.4),
        selectedFillColor: _hasError
            ? Colors.red.withOpacity(0.3)
            : const Color(0xFFC4C4C4).withOpacity(0.4),
        // Conditional border colors depending on error state
        activeColor: _hasError ? Colors.red : Colors.transparent,
        inactiveColor: _hasError ? Colors.red : Colors.transparent,
        selectedColor: _hasError ? Colors.red : Colors.transparent,
      ),
      animationDuration: const Duration(milliseconds: 300),
      backgroundColor: Colors.transparent,
      enableActiveFill: true,
      onChanged: (value) {
        setState(() {
          otp = value;
          _hasError = false; // Reset error on input change
        });
      },
      onCompleted: (value) {
        otp = value;
      },
    );
  }

  Widget _buildVerifyButton() {
    return ElevatedButton(
      onPressed: _verifyPin,
      child: const Text(
        'Verify',
        style: TextStyle(fontSize: 24),
      ),
    );
  }

  Widget _buildResendText(BuildContext context) {
    return RichText(
      text: TextSpan(
        text: "Didn’t receive any code? ",
        style: const TextStyle(color: Colors.black),
        children: [
          TextSpan(
            text: 'Resend Again',
            style: TextStyle(
                color: _secondsRemaining == 0 ? Colors.red : Colors.black45),
            recognizer: _secondsRemaining == 0
                ? (TapGestureRecognizer()..onTap = () => _handleResend(context))
                : null,
          ),
        ],
      ),
    );
  }

  Widget _buildCountdownTimer(TextTheme textTheme) {
    return Text(
      'Request a new code in 00:${_secondsRemaining}s',
      style: textTheme.labelLarge?.copyWith(color: Colors.black54),
    );
  }

  void _handleResend(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('Sent OTP to ${widget.email}'),
      backgroundColor: Colors.teal,
      behavior: SnackBarBehavior.floating,
    ));

    // Cancel the current timer if it's running
    if (_timer.isActive) {
      _timer.cancel();
    }

    // Reset the countdown and start a new timer
    setState(() {
      _secondsRemaining = seconds; // Reset countdown to initial value
    });

    // Start the timer again
    _startTimer();
  }

  void _verifyPin() {
    if (otp.length != 6) {
      // Show error if the pin is not 6 digits
      setState(() {
        _hasError = true;
      });
    } else {
      // Pin is valid, proceed with your logic
      setState(() {
        _hasError = false;
      });
      // Navigate or perform other actions
      // Handle OTP verification
      _validateOTP();
    }
  }
}
