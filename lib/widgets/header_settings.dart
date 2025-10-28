import 'package:flutter/material.dart';
import '../theme.dart';

class HeaderSettings extends StatelessWidget {
  final String title;
  const HeaderSettings({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w900,
        color: AppTheme.text,
      ),
    );
  }
}