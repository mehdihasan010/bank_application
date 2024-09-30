import 'package:flutter/material.dart';

class Keypad extends StatelessWidget {
  final Function(String) onKeypadTap;

  const Keypad({super.key, required this.onKeypadTap});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GridView.count(
        padding: const EdgeInsets.all(20),
        crossAxisCount: 3,
        childAspectRatio: 2.0,
        children: ['1', '2', '3', '4', '5', '6', '7', '8', '9', '.', '0', 'C']
            .map((key) {
          return GridTile(
            child: InkWell(
              borderRadius: BorderRadius.circular(100),
              onTap: () => onKeypadTap(key),
              child: Center(
                child: Text(
                  key,
                  style: const TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
