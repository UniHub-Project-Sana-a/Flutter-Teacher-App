// lib/views/session/attendees_page.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../models/attendee.dart' as a_model;

import '../../controllers/attendance_controller.dart';
import '../../theme.dart';
import '../../widgets/attendee_tile.dart';

class AttendeesPage extends StatefulWidget {
  const AttendeesPage({super.key});

  @override
  State<AttendeesPage> createState() => _AttendeesPageState();
}

class _AttendeesPageState extends State<AttendeesPage> {
  final TextEditingController _addCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    Get.find<AttendanceController>().loadAttendees();
  }

  @override
  void dispose() {
    _addCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final c = Get.find<AttendanceController>();

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('الحاضرون'),
          toolbarHeight: 64,
          actions: [
            Padding(
              padding: const EdgeInsetsDirectional.only(end: 8),
              child: TextButton.icon(
                style: TextButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: AppTheme.accent,
                  shape: const StadiumBorder(),
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  textStyle: const TextStyle(fontWeight: FontWeight.w800),
                ),
                onPressed: () => Get.offAllNamed('/'), // حفظ تم على السيرفر ضمنيًا
                icon: const Icon(Icons.save_alt_rounded, size: 18),
                label: const Text('حفظ والخروج'),
              ),
            ),
          ],
        ),
        body: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        decoration: const InputDecoration(
                          hintText: 'إضافة طالب يدويًا...',
                          prefixIcon: Icon(Icons.person_add_alt_1_rounded, color: AppTheme.textSecondary),
                        ),
                        controller: _addCtrl,
                        onSubmitted: (v) async {
                          await c.addManual(v);
                          _addCtrl.clear();
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    FilledButton.icon(
                      style: FilledButton.styleFrom(
                        backgroundColor: AppTheme.accent,
                        foregroundColor: Colors.white,
                        shape: const StadiumBorder(),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                        textStyle: const TextStyle(fontWeight: FontWeight.w800),
                      ),
                      onPressed: () async {
                        await c.addManual(_addCtrl.text);
                        _addCtrl.clear();
                      },
                      icon: const Icon(Icons.add_rounded),
                      label: const Text('إضافة'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 4),
              Expanded(
                child: Obx(() {
                  final list = c.records;
                  if (list.isEmpty) {
                    return const Center(
                      child: Text('لا توجد أسماء حاليًا',
                          style: TextStyle(
                              color: AppTheme.textSecondary,
                              fontWeight: FontWeight.w700)),
                    );
                  }
                  return ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                    itemCount: list.length,
                    itemBuilder: (_, i) => AttendeeTile(
                      attendee: // نحول AttendanceRecord إلى الشكل المعروض
                      // لديك AttendeeTile يتطلب Attendee، يمكنك استخدام اسم فقط
                      // إذا أردت صورة، استخدم NetworkImage داخل AttendeeTile عندك.
                      // هنا سنمرر اسم فقط عبر Adapter بسيط:
                      _AttendeeAdapter(name: list[i].name, id: list[i].id, avatar: list[i].avatar).toModel(),
                      onDelete: () => c.removeRecord(list[i].id),
                    ),
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// محول بسيط إلى نموذج Attendee الذي تستخدمه بطاقة AttendeeTile
class _AttendeeAdapter {
  final String id;
  final String name;
  final String? avatar;
  _AttendeeAdapter({required this.id, required this.name, this.avatar});
  a_model.Attendee toModel() =>
      a_model.Attendee(id: id, name: name, avatar: avatar ?? '', late: false);
}