import 'package:flutter/material.dart';
import '../theme.dart';

class RoundedSearchField extends StatelessWidget {
  final String hint;
  final ValueChanged<String>? onChanged;
  const RoundedSearchField({super.key, required this.hint, this.onChanged});

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: onChanged,
      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
      decoration: const InputDecoration(
        hintText: 'ابحث عن طالب...',
        prefixIcon: Icon(Icons.search_rounded, color: Colors.white70),
      ).copyWith(hintText: hint, fillColor: const Color(0xFF273449)),
    );
  }
}