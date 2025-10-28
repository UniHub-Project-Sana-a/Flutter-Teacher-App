import 'package:flutter/material.dart';
import '../theme.dart';

class SliderWithBubble extends StatelessWidget {
  final double value;
  final double min;
  final double max;
  final ValueChanged<double> onChanged;

  const SliderWithBubble({
    super.key,
    required this.value,
    required this.min,
    required this.max,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final divisions = (max - min).toInt() > 0 ? (max - min).toInt() : null;

    return Column(
      children: [
        Text(
          '${value.toInt()} طالب',
          style: TextStyle(fontWeight: FontWeight.w700, color: AppTheme.text),
        ),
        Slider(
          value: value.clamp(min, max),
          min: min,
          max: max,
          divisions: divisions,
          label: value.toInt().toString(),
          onChanged: onChanged,
        ),
      ],
    );
  }
}