import 'package:flutter/material.dart';
import '../theme.dart';
import '../utils/date_utils_ar.dart';

class HeaderWelcome extends StatelessWidget {
  final String name;
  final VoidCallback onTodayTap;
  const HeaderWelcome({super.key, required this.name, required this.onTodayTap});

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now();
    final dateStr = '${today.day} ${monthNameAr(today.month)} ${today.year}';


    return Directionality(
      textDirection: TextDirection.rtl,
      child: Column(
        children: [
          Text('مرحباً أستاذ $name',
              style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: Text(dateStr,
                    textAlign: TextAlign.right,
                    style: const TextStyle(
                        color: AppTheme.textSecondary,
                        fontWeight: FontWeight.w800)),
              ),
              InkWell(
                onTap: onTodayTap,
                borderRadius: BorderRadius.circular(14),
                child: Ink(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE9EEF5),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Text('اليوم',
                          style: TextStyle(
                              fontWeight: FontWeight.w800,
                              color: AppTheme.primary)),
                      SizedBox(width: 8),
                      Icon(Icons.event, size: 18, color: AppTheme.primary),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}