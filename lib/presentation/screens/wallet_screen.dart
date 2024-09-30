import 'package:bank_application/data/model/card.dart';
import 'package:bank_application/presentation/screens/add_card_screen.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';

import '../../data/api.dart';
import '../../data/model/transactions.dart';
import '../widget/transaction_card.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({super.key});

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  int currentIndex = 0;
  List<Transaction> transactions = [];
  List<CardData> cards = [];
  bool isLoading = true;
  bool isLoading2 = true;
  int userId = 1; // Replace with the actual user ID

  @override
  void initState() {
    super.initState();
    fetchTransactions();
    //fetchCards();
  }

  Future<void> fetchCards() async {
    try {
      final fetchedCards = await ApiService.fetchCards(userId.toString());
      setState(() {
        cards = fetchedCards;
        isLoading = false;
      });
    } catch (error) {
      setState(() {
        isLoading = false;
      });
      _showErrorDialog();
    }
  }

  Future<void> fetchTransactions() async {
    try {
      final fetchedTransactions = await ApiService.fetchTransactions(userId);
      setState(() {
        transactions = fetchedTransactions;
        isLoading2 = false;
      });
    } catch (error) {
      setState(() {
        isLoading2 = false;
      });
      _showErrorDialog();
    }
  }

  void _showErrorDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error'),
          content: const Text('Failed to load transactions.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Credit Card'),
        centerTitle: true,
      ),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            child: CarouselSlider(
              options: CarouselOptions(
                height: MediaQuery.of(context).size.width * 0.70,
                autoPlay: false,
                enlargeCenterPage: true,
                aspectRatio: 2.0,
                viewportFraction: 0.9,
                onPageChanged: (index, reason) {
                  setState(() {
                    currentIndex = index;
                  });
                },
              ),
              items: _buildCards(context).map((card) {
                return Builder(
                  builder: (BuildContext context) {
                    return card;
                  },
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 10),
          _buildDotsIndicator(),
          const SizedBox(height: 10),
          _buildActionsRow(),
          const SizedBox(height: 10),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              'Card Transactions',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(
            //height: MediaQuery.of(context).size.height * 0.3,
            child: isLoading2
                ? const Center(child: CircularProgressIndicator())
                : TransactionList(transactions: transactions),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: const Color(0xFF0B438C),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) => const AddCardScreen(),
            ),
          );
        },
        label: const Text(
          'Add Card',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        icon: const Icon(Icons.add, color: Colors.white, size: 25),
      ),
    );
  }

  List<Card> _buildCards(BuildContext context) {
    return [
      _buildCreditCard(
        context: context,
        color: const Color(0xFF3b556e).withOpacity(0.9),
        cardNumber: '1234 5678 9123 4567',
        cardHolder: 'Mehdi Hassan',
        cardExpiration: '02/26',
        category: 'MC',
      ),
      _buildCreditCard(
        context: context,
        color: const Color(0xFF0d233a).withOpacity(0.6),
        cardNumber: '1234 5678 9123 4567',
        cardHolder: 'Emran',
        cardExpiration: '02/26',
        category: 'VC',
      ),
    ];
  }

  Row _buildDotsIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(4, (index) {
        return AnimatedContainer(
          duration: const Duration(milliseconds: 600),
          width: index == currentIndex ? 24.0 : 10,
          height: 10.0,
          margin: const EdgeInsets.symmetric(horizontal: 4.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16.0),
            color:
                index == currentIndex ? const Color(0xFF0B438C) : Colors.grey,
          ),
        );
      }),
    );
  }

  Row _buildActionsRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildActionIcon(Iconsax.send_1, 'Send', () {}),
        _buildActionIcon(Iconsax.receive_square_24, 'Receive', () {}),
        _buildActionIcon(Iconsax.menu, 'More', () {}),
      ],
    );
  }

  InkWell _buildActionIcon(IconData icon, String label, VoidCallback onTap) {
    TextTheme textTheme = Theme.of(context).textTheme;
    return InkWell(
      borderRadius: BorderRadius.circular(100),
      onTap: onTap,
      child: Container(
        height: MediaQuery.of(context).size.width * 0.2,
        width: MediaQuery.of(context).size.width * 0.2,
        decoration: BoxDecoration(
          color: const Color(0xFF0B438C).withOpacity(0.2),
          shape: BoxShape.circle,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon),
            Text(
              label,
              style: textTheme.titleSmall,
            )
          ],
        ),
      ),
    );
  }

  Card _buildCreditCard({
    required BuildContext context,
    required Color color,
    required String cardNumber,
    required String cardHolder,
    required String cardExpiration,
    required String category,
  }) {
    return Card(
      color: color,
      shadowColor: Colors.grey,
      elevation: 3.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
      ),
      child: Container(
        height: MediaQuery.of(context).size.width * .56,
        width: MediaQuery.of(context).size.width * .9,
        padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 22.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          image: const DecorationImage(
            image: AssetImage("assets/images/cardbg.png"),
            fit: BoxFit.cover,
            opacity: 0.6,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            _buildLogosBlock(category),
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Row(
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
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10.0, left: 10),
              child: Text(cardNumber,
                  style: GoogleFonts.courierPrime(
                    textStyle: const TextStyle(
                        color: Colors.white, fontSize: 24, letterSpacing: 1),
                  )),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                _buildDetailsBlock(
                  label: 'CARDHOLDER',
                  value: cardHolder,
                ),
                _buildDetailsBlock(label: 'VALID THRU', value: cardExpiration),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Row _buildLogosBlock(String category) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Image.asset(
          "assets/images/ostad.png",
          height: 60,
          width: 100,
        ),
        Image.asset(
          category == 'MC'
              ? "assets/images/mastercard.png"
              : "assets/images/visa1.png",
          height: 50,
          width: 50,
        ),
      ],
    );
  }

  Column _buildDetailsBlock({required String label, required String value}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          label,
          style: const TextStyle(
              color: Colors.grey, fontSize: 9, fontWeight: FontWeight.bold),
        ),
        Text(
          value,
          style: const TextStyle(
              color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),
        )
      ],
    );
  }
}

class TransactionList extends StatelessWidget {
  final List<Transaction> transactions;

  const TransactionList({
    super.key,
    required this.transactions,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: transactions.length,
      itemBuilder: (context, index) {
        final transaction = transactions[index];
        return TransactionCard(
          icon: transaction.type == 'withdraw'
              ? Iconsax.send_1
              : Iconsax.receive_square_24,
          iconColor: const Color(0xFF0B438C),
          title: transaction.type == 'withdraw' ? 'Send' : 'Receive',
          amount: transaction.type == 'withdraw'
              ? '-${transaction.amount.toString()}'
              : '+${transaction.amount.toString()}',
          date: transaction.date,
        );
      },
    );
  }
}
