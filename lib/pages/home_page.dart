import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../controllers/attendance_controller.dart';
import '../../theme.dart';

class AttendanceSessionPage extends StatelessWidget {
  const AttendanceSessionPage({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.put(AttendanceController());


    return Scaffold(
      appBar: AppBar(title: const Text('الحضور')),
      body: SafeArea(
        child: Center(
          child: Obx(() {
            final data = c.qrData.value;
            if (data.isEmpty) {
              return const Padding(
                padding: EdgeInsets.all(16),
                child: Text(
                  'جاري توليد رمز QR...',
                  style: TextStyle(color: AppTheme.text, fontWeight: FontWeight.w700),
                ),
              );
            }
            return Card(
              elevation: 6,
              shadowColor: const Color(0x22000000),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(18.0),
                child: QrImageView(
                  data: data,
                  version: QrVersions.auto,
                  size: 280,
                  gapless: true,
                  eyeStyle: const QrEyeStyle(eyeShape: QrEyeShape.square, color: Colors.black),
                  dataModuleStyle: const QrDataModuleStyle(
                    dataModuleShape: QrDataModuleShape.square,
                    color: Colors.black,
                  ),
                ),
              ),
            );
          }),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          child: Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  icon: const Icon(Icons.refresh_rounded),
                  label: const Text('تبديل الرمز الآن'),
                  onPressed: c.rotateNow,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.danger,
                    foregroundColor: Colors.white,
                  ),
                  icon: const Icon(Icons.stop_circle_outlined),
                  label: const Text('إنهاء الجلسة'),
                  onPressed: c.stop,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}