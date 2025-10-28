// lib/pages/prep_settings_modern.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../theme.dart';
import '../controllers/attendance_controller.dart';
import '../views/session/attendance_session_page.dart';

class PrepSettingsModern extends StatefulWidget {
  final String initialCourse;
  const PrepSettingsModern({super.key, required this.initialCourse});

  @override
  State<PrepSettingsModern> createState() => _PrepSettingsModernState();
}

class _PrepSettingsModernState extends State<PrepSettingsModern> {
  int sessionMinutes = 10; // 1–15
  int codeInterval = 5;    // 1–60
  bool unlimited = true;
  int maxStudents = 30;

  final int minMin = 1, maxMin = 15;
  final int minSec = 1, maxSec = 60;

  final TextEditingController _maxCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _maxCtrl.text = maxStudents.toString();
  }

  @override
  void dispose() {
    _maxCtrl.dispose();
    super.dispose();
  }

  bool get valid =>
      sessionMinutes >= minMin &&
          sessionMinutes <= maxMin &&
          codeInterval >= minSec &&
          codeInterval <= maxSec &&
          (unlimited || maxStudents > 0);

  @override
  Widget build(BuildContext context) {
    final c = Get.isRegistered<AttendanceController>()
        ? Get.find<AttendanceController>()
        : Get.put(AttendanceController());

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppTheme.bg,
        body: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(child: _Header(course: widget.initialCourse)),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 120),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  _SettingsCard(
                    badgeText: 'النطاق $minMin–$maxMin دقيقة',
                    title: 'مدة الجلسة',
                    subtitle: 'اختر الإعدادات المناسبة',
                    icon: Icons.timer_rounded,
                    iconBg: const Color(0xFFE7F7EE),
                    valueText: '$sessionMinutes دقيقة',
                    child: Column(
                      children: [
                        _StepperRow(
                          value: sessionMinutes,
                          onMinus: sessionMinutes > minMin ? () => setState(() => sessionMinutes--) : null,
                          onPlus: sessionMinutes < maxMin ? () => setState(() => sessionMinutes++) : null,
                        ),
                        const SizedBox(height: 10),
                        Slider(
                          value: sessionMinutes.toDouble(),
                          min: minMin.toDouble(),
                          max: maxMin.toDouble(),
                          divisions: maxMin - minMin,
                          label: '$sessionMinutes',
                          onChanged: (v) => setState(() => sessionMinutes = v.round()),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: const [
                            Text('1 دقيقة', style: TextStyle(color: AppTheme.textSecondary)),
                            Text('15 دقيقة', style: TextStyle(color: AppTheme.textSecondary)),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  _SettingsCard(
                    badgeText: 'كل $codeInterval ثانية',
                    title: 'تكرار تغيير الرمز',
                    subtitle: 'اختر الإعدادات المناسبة',
                    icon: Icons.qr_code_2_rounded,
                    iconBg: const Color(0xFFE9F1FF),
                    valueText: 'كل $codeInterval ثانية',
                    child: Column(
                      children: [
                        _StepperRow(
                          value: codeInterval,
                          onMinus: codeInterval > minSec ? () => setState(() => codeInterval--) : null,
                          onPlus: codeInterval < maxSec ? () => setState(() => codeInterval++) : null,
                        ),
                        const SizedBox(height: 10),
                        Slider(
                          value: codeInterval.toDouble(),
                          min: minSec.toDouble(),
                          max: maxSec.toDouble(),
                          divisions: maxSec - minSec,
                          label: '$codeInterval',
                          onChanged: (v) => setState(() => codeInterval = v.round()),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: const [
                            Text('1 ث', style: TextStyle(color: AppTheme.textSecondary)),
                            Text('60 ث', style: TextStyle(color: AppTheme.textSecondary)),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  _SettingsCard(
                    badgeText: unlimited ? 'غير محدود' : 'حد: $maxStudents',
                    title: 'عدد الطلاب',
                    subtitle: 'اختر غير محدود أو حد أقصى',
                    icon: Icons.group_rounded,
                    iconBg: const Color(0xFFFFF5E7),
                    valueText: unlimited ? 'غير محدود' : '$maxStudents',
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: _ChoicePill(
                                text: 'غير محدود',
                                selected: unlimited,
                                onTap: () => setState(() => unlimited = true),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _ChoicePill(
                                text: 'تحديد عدد',
                                selected: !unlimited,
                                onTap: () => setState(() => unlimited = false),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        if (!unlimited)
                          Row(
                            children: [
                              _StepBtn(
                                icon: Icons.remove_rounded,
                                onTap: maxStudents > 1 ? () {
                                  setState(() {
                                    maxStudents--;
                                    _maxCtrl.text = maxStudents.toString();
                                  });
                                } : null,
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: TextField(
                                  controller: _maxCtrl,
                                  textAlign: TextAlign.center,
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                  decoration: const InputDecoration(
                                    hintText: 'أدخل العدد',
                                    fillColor: Color(0xFFF3F4F6),
                                  ),
                                  onChanged: (v) {
                                    final n = int.tryParse(v) ?? 0;
                                    setState(() => maxStudents = n);
                                  },
                                ),
                              ),
                              const SizedBox(width: 10),
                              _StepBtn(
                                icon: Icons.add_rounded,
                                onTap: maxStudents < 500 ? () {
                                  setState(() {
                                    maxStudents++;
                                    _maxCtrl.text = maxStudents.toString();
                                  });
                                } : null,
                              ),
                            ],
                          ),
                      ],
                    ),
                  ),
                ]),
              ),
            ),
          ],
        ),

        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: SizedBox(
            height: 56,
            width: double.infinity,
            child: FilledButton.icon(
              style: FilledButton.styleFrom(
                backgroundColor: valid ? AppTheme.accent : AppTheme.border,
                foregroundColor: Colors.white,
                shape: const StadiumBorder(),
                textStyle: const TextStyle(fontWeight: FontWeight.w800),
              ),
              onPressed: valid ? () async {
                final ok = await c.startSession(
                  lecture: widget.initialCourse,
                  lectureIdParam: 'LECTURE_ID_FROM_SCHEDULE', // مرّر الـ ID الحقيقي عند الجلب
                  minutes: sessionMinutes,
                  rotation: codeInterval,
                  isUnlimited: unlimited,
                  limit: maxStudents,
                );
                if (ok && mounted) {
                  Get.to(() => AttendanceSessionPage(
                    minutes: sessionMinutes,
                    rotation: codeInterval,
                    unlimited: unlimited,
                    limit: maxStudents,
                    course: widget.initialCourse,
                  ));
                }
              } : null,
              icon: const Icon(Icons.play_arrow_rounded),
              label: const Text('بدء جلسة التحضير'),
            ),
          ),
        ),
      ),
    );
  }
}

/* ============== Header & building blocks (كما لديك) ============== */

class _Header extends StatelessWidget {
  final String course;
  const _Header({required this.course});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(8, 24, 8, 20),
      decoration: const BoxDecoration(
        color: AppTheme.primary,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(28)),
      ),
      child: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                IconButton(
                  onPressed: () => Get.back(),
                  icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 18),
                ),
                const Spacer(),
                const Text('إعدادات تحضير',
                    style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w800)),
                const SizedBox(width: 8),
              ],
            ),
            const SizedBox(height: 6),
            Text(course, textDirection: TextDirection.ltr, textAlign: TextAlign.right,
                style: const TextStyle(color: Colors.white70, fontSize: 13, fontWeight: FontWeight.w700)),
          ],
        ),
      ),
    );
  }
}

class _SettingsCard extends StatelessWidget {
  final String badgeText, title, subtitle, valueText;
  final IconData icon; final Color iconBg; final Widget child;
  const _SettingsCard({required this.badgeText, required this.title, required this.subtitle,
    required this.icon, required this.iconBg, required this.valueText, required this.child});
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          Row(children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(color: const Color(0xFFF1F5F9), borderRadius: BorderRadius.circular(999)),
              child: Text(badgeText, style: const TextStyle(color: AppTheme.textSecondary, fontWeight: FontWeight.w800)),
            ),
            const Spacer(),
            Row(children: [
              Container(width: 36, height: 36, alignment: Alignment.center,
                decoration: BoxDecoration(color: iconBg, borderRadius: BorderRadius.circular(12)),
                child: Icon(icon, color: AppTheme.primary, size: 20),
              ),
              const SizedBox(width: 10),
              Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 18, color: AppTheme.text)),
                const SizedBox(height: 4),
                Text(subtitle, style: const TextStyle(color: AppTheme.textSecondary, fontWeight: FontWeight.w700, fontSize: 12)),
              ]),
            ]),
          ]),
          const SizedBox(height: 14),
          child,
        ]),
      ),
    );
  }
}

class _StepperRow extends StatelessWidget {
  final int value; final VoidCallback? onMinus; final VoidCallback? onPlus;
  const _StepperRow({required this.value, required this.onMinus, required this.onPlus});
  @override
  Widget build(BuildContext context) {
    return Row(children: [
      _StepBtn(icon: Icons.remove_rounded, onTap: onMinus),
      Expanded(child: Container(
        height: 48, margin: const EdgeInsets.symmetric(horizontal: 12),
        alignment: Alignment.center,
        decoration: BoxDecoration(color: const Color(0xFFF3F4F6), borderRadius: BorderRadius.circular(12)),
        child: Text('$value', style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 18, color: AppTheme.text)),
      )),
      _StepBtn(icon: Icons.add_rounded, onTap: onPlus),
    ]);
  }
}

class _StepBtn extends StatelessWidget {
  final IconData icon; final VoidCallback? onTap;
  const _StepBtn({required this.icon, required this.onTap});
  @override
  Widget build(BuildContext context) {
    final enabled = onTap != null;
    return InkWell(
      onTap: onTap, borderRadius: BorderRadius.circular(12),
      child: Ink(width: 48, height: 48,
        decoration: BoxDecoration(color: enabled ? const Color(0xFFEFF3FE) : const Color(0xFFF1F5F9),
            borderRadius: BorderRadius.circular(12)),
        child: Icon(icon, color: enabled ? AppTheme.primary : AppTheme.textSecondary),
      ),
    );
  }
}

class _ChoicePill extends StatelessWidget {
  final String text; final bool selected; final VoidCallback onTap;
  const _ChoicePill({required this.text, required this.selected, required this.onTap});
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap, borderRadius: BorderRadius.circular(24),
      child: Ink(height: 44,
        decoration: BoxDecoration(color: selected ? AppTheme.accent : const Color(0xFFF3F4F6),
            borderRadius: BorderRadius.circular(24),
            boxShadow: selected ? const [BoxShadow(color: Color(0x22000000), blurRadius: 10, offset: Offset(0, 6))] : null),
        child: Center(child: Text(text,
          style: TextStyle(color: selected ? Colors.white : AppTheme.textSecondary, fontWeight: FontWeight.w800),
        )),
      ),
    );
  }
}