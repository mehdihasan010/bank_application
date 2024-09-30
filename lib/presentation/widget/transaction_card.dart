import 'package:flutter/material.dart';

class TransactionCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String amount;
  final String date;

  const TransactionCard({
    super.key,
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.amount,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      //color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 14),
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: const Color(0xFF0B438C).withOpacity(0.7),
            child: Icon(icon, color: Colors.white),
          ),
          title: Text(
            title,
            style: const TextStyle(fontSize: 20),
          ),
          subtitle: Text(
            date,
            style: const TextStyle(fontSize: 14, color: Color(0xFF808080)),
          ),
          trailing: Text(
            amount,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: iconColor,
            ),
          ),
        ),
      ),
    );
  }
}
