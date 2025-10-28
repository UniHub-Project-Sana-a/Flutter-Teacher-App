// lib/models/attendance_record.dart
class AttendanceRecord {
  final String id; // attendance_id
  final String name;
  final String? avatar;
  final DateTime at;

  AttendanceRecord({
    required this.id,
    required this.name,
    required this.at,
    this.avatar,
  });

  factory AttendanceRecord.fromJson(Map<String, dynamic> j) => AttendanceRecord(
    id: j['id'].toString(),
    name: j['student']?['name'] ?? j['name'] ?? '',
    avatar: j['student']?['avatar'],
    at: DateTime.parse(j['created_at']),
  );
}