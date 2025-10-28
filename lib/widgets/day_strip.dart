import 'package:flutter/material.dart';
import '../theme.dart';
import '../utils/date_utils_ar.dart';

class DayStrip extends StatelessWidget {
  final DateTime selected;
  final ValueChanged<DateTime> onChanged;
  const DayStrip({super.key, required this.selected, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final start = selected.subtract(const Duration(days: 3));
    final days = List.generate(7,
            (i) => DateTime(start.year, start.month, start.day + i));


    return Directionality(
      textDirection: TextDirection.rtl,
      child: SizedBox(
        height: 84,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(vertical: 6),
          itemCount: days.length,
          separatorBuilder: (_, __) => const SizedBox(width: 12),
          itemBuilder: (_, i) {
            final d = days[i];
            final sel = isSameDay(d, selected);
            return InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: () => onChanged(d),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 160),
                width: 82,
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: sel ? AppTheme.primary : Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x14000000),
                      blurRadius: 10,
                      offset: Offset(0, 6),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      weekdayShortAr(d.weekday),
                      style: TextStyle(
                        color:
                        sel ? Colors.white : AppTheme.textSecondary,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '${d.day}',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: sel ? Colors.white : AppTheme.text,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}