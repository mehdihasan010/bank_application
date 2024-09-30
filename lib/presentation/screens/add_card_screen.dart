import 'package:bank_application/data/api.dart';
import 'package:bank_application/presentation/screens/payment_success_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../data/model/card.dart';

class AddCardScreen extends StatefulWidget {
  const AddCardScreen({super.key});

  @override
  State<AddCardScreen> createState() => _AddCardScreenState();
}

class _AddCardScreenState extends State<AddCardScreen> {
  final TextEditingController _cardNumberController = TextEditingController();
  final TextEditingController _cardHolderNameController =
      TextEditingController();
  final TextEditingController _expiryDateController = TextEditingController();
  final TextEditingController _cvvController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String cardNumber = '0000 0000 0000 0000';
  String cardHolderName = 'Cardholder Name';
  String expiryDate = 'MM/YY';
  String cvv = '***';
  String cardType = '';

  // Helper method to detect card type based on the card number prefix
  void detectCardType(String number) {
    if (number.startsWith('4')) {
      setState(() {
        cardType = 'visa'; // Visa starts with 4
      });
    } else if (number.startsWith('5')) {
      setState(() {
        cardType = 'mastercard'; // MasterCard starts with 5
      });
    } else {
      setState(() {
        cardType = ''; // Unknown card type
      });
    }
  }

  void addNewCard() async {
    CardData cardData = CardData(
      userId: '1',
      cardNumber: _cardNumberController.text,
      cardholderName: _cardHolderNameController.text,
      expiryDate: _expiryDateController.text,
      cvv: _cvvController.text,
      cardType: 'MC',
    );

    String result = await ApiService.addCard(cardData);
    // ignore: avoid_print
    print(result); // Handle the response
    Navigator.pushAndRemoveUntil(
      // ignore: use_build_context_synchronously
      context,
      MaterialPageRoute(
        builder: (context) => PaymentSuccessScreen(
          paytype: result,
          amount: '',
        ), // Replace with your HomeScreen widget
      ),
      (Route<dynamic> route) => false, // Remove all previous routes
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Card'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1.0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Card Preview
              _buildCardPreview(),
              const SizedBox(height: 40),
              _buildAddCardform(),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(child: _addCardButton()),
    );
  }

  Widget _buildCardPreview() {
    return Container(
      height:
          MediaQuery.of(context).size.width * .60, // card ratio = 85.60/53.98
      width: MediaQuery.of(context).size.width * .9,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Colors.green, Colors.blue],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Card Logo
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Image.asset(
                "assets/images/ostad.png",
                height: 60,
                width: 100,
              ),
              Align(
                alignment: Alignment.topRight,
                child: cardType == 'visa'
                    ? Image.asset('assets/images/visa.png', height: 30)
                    : cardType == 'mastercard'
                        ? Image.asset('assets/images/mastercard.png',
                            height: 30)
                        : Container(),
              ),
            ],
          ),
          Row(
            children: [
              Image.asset(
                "assets/images/chip.png",
                height: 40,
                width: 40,
              ),
              const SizedBox(width: 20),
              Image.asset(
                "assets/images/contact_less.png",
                height: 30,
                width: 30,
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(cardNumber,
              style: GoogleFonts.courierPrime(
                textStyle: const TextStyle(
                    color: Colors.white, fontSize: 24, letterSpacing: 1),
              )),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'CARDHOLDER NAME',
                    style: TextStyle(color: Colors.white70),
                  ),
                  Text(
                    cardHolderName,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'EXP DATE',
                    style: TextStyle(color: Colors.white70),
                  ),
                  Text(
                    expiryDate,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAddCardform() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            controller: _cardNumberController,
            decoration: const InputDecoration(
              labelText: 'Card Number',
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly, // Allow only digits
              LengthLimitingTextInputFormatter(16), // Limit to 16 digits
              CardNumberInputFormatter()
            ],
            onChanged: (value) {
              setState(() {
                cardNumber = value.isEmpty ? '0000 0000 0000 0000' : value;
              });
              detectCardType(value.replaceAll(' ', ''));
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter Card Number';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),

          // Cardholder Name Input
          TextFormField(
            controller: _cardHolderNameController,
            decoration: const InputDecoration(
              labelText: 'Cardholder Name',
              border: OutlineInputBorder(),
            ),
            onChanged: (value) {
              setState(() {
                cardHolderName = value.isEmpty ? 'Cardholder Name' : value;
              });
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter Cardholder Name';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),

          // Expiry Date and CVV Row
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _expiryDateController,
                  decoration: const InputDecoration(
                    labelText: 'Expiry Date',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.datetime,
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(
                        5), // Limit to MM/YY format
                    ExpiryDateInputFormatter(), // Custom formatter for MM/YY
                  ],
                  onChanged: (value) {
                    setState(() {
                      expiryDate = value.isEmpty ? 'MM/YY' : value;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter Expiry Date';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: TextFormField(
                  controller: _cvvController,
                  decoration: const InputDecoration(
                    labelText: 'CVV',
                    border: OutlineInputBorder(),
                  ),
                  //keyboardType: TextInputType.number,
                  onChanged: (value) {
                    setState(() {
                      cvv = value.isEmpty ? '***' : value;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter CVV';
                    }
                    return null;
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _addCardButton() {
    TextTheme textTheme = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ElevatedButton(
        onPressed: () {
          // Add card logic here
          if (_formKey.currentState!.validate()) {
            addNewCard();
          }
        },
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(double.infinity, 60), // full-width button
          backgroundColor: const Color(0xFF1B1B1B),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14.0),
          ),
        ),
        child: Text(
          'Add Card',
          style: textTheme.titleLarge?.copyWith(color: Colors.white),
        ),
      ),
    );
  }
}

// Custom TextInputFormatter to automatically insert a space every 4 digits
class CardNumberInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    String newText = newValue.text;
    newText = newText.replaceAll(' ', ''); // Remove any existing spaces

    // Insert a space every 4 characters
    String formattedText = '';
    for (int i = 0; i < newText.length; i++) {
      formattedText += newText[i];
      if ((i + 1) % 4 == 0 && (i + 1) != newText.length) {
        formattedText += ' ';
      }
    }

    return newValue.copyWith(
      text: formattedText,
      selection: TextSelection.collapsed(offset: formattedText.length),
    );
  }
}

// Custom TextInputFormatter to automatically format input as MM/YY
class ExpiryDateInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    String newText = newValue.text;

    // Remove any existing slashes
    newText = newText.replaceAll('/', '');

    if (newText.isEmpty) {
      return newValue;
    } else if (newText.length <= 2) {
      // If length is 1 or 2, just allow the input (this is the MM part)
      return newValue.copyWith(
        text: newText,
        selection: TextSelection.collapsed(offset: newText.length),
      );
    } else if (newText.length <= 4) {
      // When length is between 3 and 4, insert the slash after the month
      String formattedText =
          '${newText.substring(0, 2)}/${newText.substring(2)}';
      return newValue.copyWith(
        text: formattedText,
        selection: TextSelection.collapsed(offset: formattedText.length),
      );
    }

    // Prevent more than 4 digits (i.e., MMYY)
    return oldValue;
  }
}
