// lib/views/home/home_page.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../theme.dart';
import '../../widgets/header_welcome.dart';
import '../../widgets/day_strip.dart';
import '../../widgets/session_card.dart';
import '../../controllers/home_controller.dart';
import '../../pages/prep_settings_modern.dart';
import '../../models/lecture.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DateTime selected = DateTime.now();
  int _currentIndex = 0;
  final hc = Get.put(HomeController());

  @override
  void initState() {
    super.initState();
    hc.loadForDate(selected);
  }

  void _goToday() {
    setState(() => selected = DateTime.now());
    hc.loadForDate(selected);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            HeaderWelcome(name: 'أستاذ محمد', onTodayTap: _goToday),
            const SizedBox(height: 10),
            DayStrip(
              selected: selected,
              onChanged: (d) {
                setState(() => selected = d);
                hc.loadForDate(d);
              },
            ),
            const SizedBox(height: 16),
            Obx(() {
              if (hc.isLoading.value) {
                return const Center(child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: CircularProgressIndicator(),
                ));
              }
              if (hc.lectures.isEmpty) {
                return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(20.0),
                      child: Text('لا توجد محاضرات لهذا اليوم',
                          style: TextStyle(
                              color: AppTheme.textSecondary,
                              fontWeight: FontWeight.w700)),
                    ));
              }
              return Column(
                children: hc.lectures
                    .map((Lecture lec) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: SessionCard(
                    periodChip: lec.period,
                    time: lec.time,
                    title: lec.title,
                    subtitle: lec.location,
                    onQrTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => PrepSettingsModern(
                            initialCourse: lec.title, // العنوان
                          ),
                        ),
                      );
                      // ملاحظة: lectureId سيُمرر لاحقًا من صفحة الإعدادات للكنترولر عند البدء
                      // أو يمكنك تعديل PrepSettingsModern لقبول lectureId وتمريره هناك
                    },
                  ),
                ))
                    .toList(),
              );
            }),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (i) {
          setState(() => _currentIndex = i);
          if (i == 3) Get.toNamed('/settings');
          else if (i != 0) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('القسم "${_labels[i]}" غير مفعّل بعد')),
            );
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.event_note_rounded), label: 'الجدول'),
          BottomNavigationBarItem(icon: Icon(Icons.menu_book_rounded), label: 'المواد'),
          BottomNavigationBarItem(icon: Icon(Icons.receipt_long_rounded), label: 'المستحقات'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline_rounded), label: 'حسابي'),
        ],
      ),
    );
  }
}

const _labels = ['الجدول', 'المواد', 'المستحقات', 'حسابي'];