// lib/models/lecture.dart
class Lecture {
  final String id;
  final String title;
  final String location;
  final String period; // صباحي/مسائي
  final String time;   // مثل: 9:00 ص - 10:30 ص

  Lecture({
    required this.id,
    required this.title,
    required this.location,
    required this.period,
    required this.time,
  });

  factory Lecture.fromJson(Map<String, dynamic> j) => Lecture(
    id: j['id'].toString(),
    title: j['title'] ?? '',
    location: j['location'] ?? '',
    period: j['period'] ?? '',
    time: j['time'] ?? '',
  );
}