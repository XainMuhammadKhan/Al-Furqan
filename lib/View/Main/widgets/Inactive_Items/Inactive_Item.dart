import 'package:flutter/material.dart';

class InactiveItem extends StatelessWidget {
  final String icon;
  final String label;

  const InactiveItem({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(height: 8),
        Image.asset(icon, width: 30, height: 30, fit: BoxFit.contain),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 11,
            color: Colors.white60,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }
}
