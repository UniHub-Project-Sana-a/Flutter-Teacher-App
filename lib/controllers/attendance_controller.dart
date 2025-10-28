// lib/controllers/attendance_controller.dart
import 'dart:async';
import 'dart:convert';

import 'package:get/get.dart';

import '../models/attendance_record.dart';
import '../repositories/attendance_repository.dart';
import '../services/location_service.dart';

class AttendanceController extends GetxController {
  final _repo = AttendanceRepository();

  // إعدادات
  final RxInt sessionMinutes = 10.obs;
  final RxInt rotationSeconds = 5.obs;
  final RxBool unlimited = true.obs;
  final RxInt maxStudents = 0.obs; // 0 = غير محدود
  final RxString courseName = ''.obs;
  final RxString lectureId = ''.obs;

  // حالة الجلسة
  final RxBool isActive = false.obs;
  final RxInt remainingSeconds = 0.obs;
  final RxInt countdown = 0.obs;
  final RxString sessionId = ''.obs;
  final RxString qrData = ''.obs;         // نص الـ QR (Base64-URL JSON أو كما يعيده السيرفر)
  final RxList<AttendanceRecord> records = <AttendanceRecord>[].obs;

  Timer? _ticker;

  @override
  void onClose() {
    _ticker?.cancel();
    super.onClose();
  }

  Future<bool> startSession({
    required String lecture,
    required String lectureIdParam,
    required int minutes,
    required int rotation,
    required bool isUnlimited,
    required int limit,
  }) async {
    // 1) احفظ الإعدادات
    courseName.value = lecture;
    lectureId.value = lectureIdParam;
    sessionMinutes.value = minutes;
    rotationSeconds.value = rotation;
    unlimited.value = isUnlimited;
    maxStudents.value = isUnlimited ? 0 : limit;

    // 2) تحقق من الإذن وموقع المحاضر
    final okPerm = await LocationService.ensureServiceAndPermission();
    if (!okPerm) {
      Get.snackbar('الموقع غير مفعّل', 'رجاءً فعّل خدمة الموقع ومنح الإذن.');
      return false;
    }
    final pos = await LocationService.current();

    // 3) اطلب من السيرفر بدء الجلسة (السيرفر يتحقق من موقع القاعة)
    try {
      final res = await _repo.startSession(
        lectureId: lectureId.value,
        minutes: minutes,
        rotation: rotation,
        limit: maxStudents.value == 0 ? null : maxStudents.value,
        teacherLat: pos.latitude,
        teacherLng: pos.longitude,
      );

      if (!res.approved) {
        Get.snackbar('رفض البدء', res.message ?? 'خارج نطاق القاعة');
        return false;
      }

      sessionId.value = res.sessionId ?? '';
      isActive.value = true;
      remainingSeconds.value = minutes * 60;
      countdown.value = rotation;

      // أول تدوير من السيرفر للحصول على QR
      await rotateNow();

      // مؤقتات العد
      _ticker?.cancel();
      _ticker = Timer.periodic(const Duration(seconds: 1), (_) async {
        if (!isActive.value) return;

        if (remainingSeconds.value > 0) {
          remainingSeconds.value--;
        } else {
          await stop();
          return;
        }

        if (countdown.value > 0) {
          countdown.value--;
        } else {
          await rotateNow();
        }
      });

      return true;
    } catch (_) {
      Get.snackbar('خطأ', 'تعذّر بدء الجلسة، تحقق من الاتصال');
      return false;
    }
  }

  Future<void> rotateNow() async {
    try {
      final data = await _repo.rotate(sessionId.value);
      // إذا أعاد السيرفر qr_data جاهزة:
      if (data['qr'] is String) {
        qrData.value = data['qr'] as String;
      } else {
        // أو إذا أعاد tok + exp: نبني payload
        final tok = data['tok']?.toString();
        final exp = data['exp'];
        final payload = {
          'v': 1,
          'sid': sessionId.value,
          'tok': tok,
          'exp': exp,
          'crs': courseName.value,
        };
        qrData.value = base64UrlEncode(utf8.encode(jsonEncode(payload)));
      }
      countdown.value = rotationSeconds.value;
    } catch (_) {
      Get.snackbar('تنبيه', 'تعذّر تدوير الرمز');
      countdown.value = rotationSeconds.value; // لا تتوقف المؤقتات
    }
  }

  Future<void> stop() async {
    isActive.value = false;
    _ticker?.cancel();
    try {
      await _repo.stop(sessionId.value);
    } catch (_) {/* تجاهل مؤقتًا */}
  }

  Future<void> loadAttendees() async {
    try {
      final list = await _repo.attendees(sessionId.value);
      records.assignAll(list);
    } catch (_) {
      records.clear();
    }
  }

  Future<void> addManual(String name) async {
    await _repo.addManual(sessionId.value, name);
    await loadAttendees();
  }

  Future<void> removeRecord(String attendanceId) async {
    await _repo.removeAttendee(sessionId.value, attendanceId);
    records.removeWhere((e) => e.id == attendanceId);
  }
}