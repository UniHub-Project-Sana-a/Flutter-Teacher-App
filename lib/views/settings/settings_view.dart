// lib/views/settings/settings_view.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/auth_controller.dart';
import '../../theme.dart';

class SettingsView extends StatelessWidget {
  final String loginRoute;
  const SettingsView({super.key, this.loginRoute = '/login'});

  @override
  Widget build(BuildContext context) {
    final auth = Get.put(AuthController(), permanent: true);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xFFF7F8FA),
        appBar: AppBar(
          backgroundColor: AppTheme.primary,
          foregroundColor: Colors.white,
          title: const Text('الإعدادات'),
          centerTitle: true,
        ),
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // بطاقة المستخدم
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.06),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  )
                ],
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 28,
                    backgroundColor: AppTheme.primary,
                    child: Obx(() {
                      final n = auth.displayName.value.trim();
                      final letter =
                      n.isEmpty ? 'م' : n.characters.first.toUpperCase();
                      return Text(
                        letter,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                          fontSize: 20,
                        ),
                      );
                    }),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Obx(
                          () => Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            auth.displayName.value.isEmpty
                                ? 'مستخدم'
                                : auth.displayName.value,
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w700),
                          ),
                          const SizedBox(height: 4),
                          const Text('حساب مفعّل',
                              style: TextStyle(color: AppTheme.textSecondary)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            ListTile(
              leading: const Icon(Icons.person_outline),
              title: const Text('البيانات الشخصية'),
              subtitle: const Text('الاسم، البريد، ...'),
              onTap: () {},
            ),
            const Divider(height: 0),
            ListTile(
              leading: const Icon(Icons.lock_outline),
              title: const Text('الأمان'),
              subtitle: const Text('تغيير كلمة المرور'),
              onTap: () {},
            ),
            const Divider(height: 0),

            const SizedBox(height: 16),

            SizedBox(
              height: 52,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFEF4444),
                  foregroundColor: Colors.white,
                  shape:
                  RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
                icon: const Icon(Icons.logout),
                label: const Text('تسجيل الخروج',
                    style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.w800)),
                onPressed: () {
                  auth.logout();
                  Get.offAllNamed(loginRoute);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}