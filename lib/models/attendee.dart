class Attendee {
  final String id;
  final String name;
  final String? avatar;
  final bool late;

  Attendee({
    required this.id,
    required this.name,
    this.avatar,
    this.late = false,
  });
}