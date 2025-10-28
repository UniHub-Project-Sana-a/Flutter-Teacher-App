// lib/services/endpoints.dart
import 'package:flutter/foundation.dart';

class Endpoints {
  // عدّل القواعد حسب بيئتك
  static const String baseUrlMobile = 'http://10.0.2.2:8000/api'; // Android Emulator
  static const String baseUrlWeb    = 'http://localhost:8000/api';

  static String get baseUrl => kIsWeb ? baseUrlWeb : baseUrlMobile;

  static const String login = '/auth/login';
  static String schedule(String dateIso) => '/lecturer/schedule?date=$dateIso';

  static const String startSession = '/sessions/start';
  static String rotate(String sid) => '/sessions/$sid/rotate';
  static String stop(String sid) => '/sessions/$sid/stop';

  static String attendees(String sid) => '/sessions/$sid/attendees';
  static String addManual(String sid) => '/sessions/$sid/attendees/add';
  static String removeAttendee(String sid, String attendanceId) =>
      '/sessions/$sid/attendees/$attendanceId';
}