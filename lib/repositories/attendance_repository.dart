// lib/repositories/attendance_repository.dart
import '../models/attendance_record.dart';
import '../models/lecture.dart';
import '../services/api_client.dart';
import '../services/endpoints.dart';

class AttendanceRepository {
  final _dio = ApiClient.instance.dio;

  Future<List<Lecture>> fetchSchedule(String dateIso) async {
    final res = await _dio.get(Endpoints.schedule(dateIso));
    final list = (res.data as List).cast<Map<String, dynamic>>();
    return list.map(Lecture.fromJson).toList();
  }

  // يبدأ الجلسة مع التحقق من الموقع عند السيرفر
  Future<({bool approved, String? sessionId, String? message})> startSession({
    required String lectureId,
    required int minutes,
    required int rotation,
    int? limit,
    required double teacherLat,
    required double teacherLng,
  }) async {
    final res = await _dio.post(Endpoints.startSession, data: {
      'lecture_id': lectureId,
      'minutes': minutes,
      'rotation': rotation,
      'limit': limit,
      'teacher_lat': teacherLat,
      'teacher_lng': teacherLng,
    });
    final data = res.data as Map<String, dynamic>;
    return (approved: data['approved'] == true,
    sessionId: data['session_id']?.toString(),
    message: data['message']?.toString());
  }

  // تدوير الرمز: نفضّل أن يعيد السيرفر qr_data الجاهزة (base64-url) أو tok+exp
  Future<Map<String, dynamic>> rotate(String sessionId) async {
    final res = await _dio.post(Endpoints.rotate(sessionId));
    return (res.data as Map<String, dynamic>);
  }

  Future<void> stop(String sessionId) async {
    await _dio.post(Endpoints.stop(sessionId));
  }

  Future<List<AttendanceRecord>> attendees(String sessionId) async {
    final res = await _dio.get(Endpoints.attendees(sessionId));
    final list = (res.data as List).cast<Map<String, dynamic>>();
    return list.map(AttendanceRecord.fromJson).toList();
  }

  Future<void> addManual(String sessionId, String name) async {
    await _dio.post(Endpoints.addManual(sessionId), data: {'name': name});
  }

  Future<void> removeAttendee(String sessionId, String attendanceId) async {
    await _dio.delete(Endpoints.removeAttendee(sessionId, attendanceId));
  }
}