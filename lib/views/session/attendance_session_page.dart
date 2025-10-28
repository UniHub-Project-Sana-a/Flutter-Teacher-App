// lib/views/session/attendance_session_page.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/attendance_controller.dart';
import '../../theme.dart';
import '../../widgets/pill_stat.dart';
import '../../widgets/qr_box.dart';
import '../../utils/time_utils.dart';
import 'attendees_page.dart';

class AttendanceSessionPage extends StatelessWidget {
  final int minutes, rotation, limit;
  final bool unlimited;
  final String course;

  const AttendanceSessionPage({
    super.key,
    required this.minutes,
    required this.rotation,
    required this.unlimited,
    required this.limit,
    required this.course,
  });

  @override
  Widget build(BuildContext context) {
    final c = Get.find<AttendanceController>();
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(title: const Text('جلسة التحضير (QR)')),
        body: SafeArea(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
            children: [
              Obx(() => QrBox(data: c.qrData.value)),
              const SizedBox(height: 16),
              Obx(() {
                final m = minutesOf(c.remainingSeconds.value);
                final s = secondsRemainder(c.countdown.value);
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    PillStat(value: two(m), label: 'دقائق'),
                    const SizedBox(width: 14),
                    PillStat(value: two(s), label: 'ثوانٍ'),
                  ],
                );
              }),
              const SizedBox(height: 8),
              Obx(() => Text('المقرر: ${c.courseName.value}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: AppTheme.textSecondary, fontWeight: FontWeight.w700))),
            ],
          ),
        ),
        bottomNavigationBar: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.danger,
                      foregroundColor: Colors.white,
                      shape: const StadiumBorder(),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    onPressed: () async {
                      await c.stop();
                      Get.off(() => const AttendeesPage());
                    },
                    icon: const Icon(Icons.stop_circle_outlined),
                    label: const Text('إنهاء الجلسة'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppTheme.primary,
                      side: const BorderSide(color: AppTheme.border),
                      shape: const StadiumBorder(),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    onPressed: c.rotateNow,
                    icon: const Icon(Icons.refresh_rounded),
                    label: const Text('تبديل الرمز الآن'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}