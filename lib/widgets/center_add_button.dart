import 'package:flutter/material.dart';

class CenterAddButton extends StatelessWidget {
  const CenterAddButton({super.key});
  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [BoxShadow(color: Color(0x33000000), blurRadius: 10, offset: Offset(0, 6))],
      ),
      child: const SizedBox(width: 52, height: 52, child: Icon(Icons.add, color: Colors.white)),
    );
  }
}