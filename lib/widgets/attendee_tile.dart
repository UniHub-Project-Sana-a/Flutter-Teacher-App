import 'package:flutter/material.dart';
import '../models/attendee.dart';
import '../theme.dart';

class AttendeeTile extends StatelessWidget {
  final Attendee attendee;
  final VoidCallback onDelete;
  const AttendeeTile({super.key, required this.attendee, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [BoxShadow(color: Color(0x11000000), blurRadius: 10, offset: Offset(0, 6))],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: Row(
          children: [
            IconButton(
              onPressed: onDelete,
              icon: const Icon(Icons.delete_outline_rounded),
              color: AppTheme.danger,
              tooltip: 'حذف',
            ),
            const SizedBox(width: 6),
            Expanded(
              child: Text(attendee.name,
                  textAlign: TextAlign.right,
                  style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16, color: AppTheme.text)),
            ),
            const SizedBox(width: 10),
            Stack(
              alignment: Alignment.center,
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: const Color(0xFFE9EDF3),
                  backgroundImage: (attendee.avatar != null && attendee.avatar!.isNotEmpty)
                      ? NetworkImage(attendee.avatar!) as ImageProvider
                      : null,
                  child: (attendee.avatar == null || attendee.avatar!.isEmpty)
                      ? const Icon(Icons.person, color: AppTheme.textSecondary)
                      : null,
                ),
                if (attendee.late)
                  Positioned(
                    left: -2,
                    child: Container(
                      width: 22,
                      height: 22,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF6F1E6),
                        borderRadius: BorderRadius.circular(11),
                        border: Border.all(color: const Color(0xFFE8D7BD)),
                      ),
                      child: const Icon(Icons.water_drop_rounded, size: 14, color: Color(0xFFC49A4A)),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}