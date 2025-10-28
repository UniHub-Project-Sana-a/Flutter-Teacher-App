// lib/main.dart
import 'dart:async';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'theme.dart';
import 'views/home/home_page.dart';
import 'views/session/attendance_session_page.dart';
import 'views/session/attendees_page.dart';
import 'views/auth/login_view.dart';
import 'views/settings/settings_view.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.presentError(details);
  };

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Lecturers Attendance',

      locale: const Locale('ar'),
      supportedLocales: const [Locale('ar'), Locale('en')],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],

      theme: AppTheme.light,

      // ابدأ من صفحة تسجيل الدخول
      initialRoute: '/login',

      getPages: [
        GetPage(name: '/login', page: () => const LoginView(successRoute: '/')),
        GetPage(name: '/', page: () => const HomePage()),
        GetPage(
          name: '/session',
          page: () {
            final args = (Get.arguments as Map?) ?? const {};
            return AttendanceSessionPage(
              minutes: args['minutes'] ?? 10,
              rotation: args['rotation'] ?? 5,
              unlimited: args['unlimited'] ?? true,
              limit: args['limit'] ?? 0,
              course: args['course'] ?? 'غير محدد',
            );
          },
        ),
        GetPage(name: '/attendees', page: () => const AttendeesPage()),
        GetPage(name: '/settings', page: () => const SettingsView(loginRoute: '/login')),
      ],
      defaultTransition: Transition.cupertino,

      builder: (context, child) {
        ErrorWidget.builder = (details) {
          return Directionality(
            textDirection: TextDirection.rtl,
            child: Scaffold(
              backgroundColor: Colors.white,
              body: Center(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.error_outline, size: 48, color: AppTheme.danger),
                      const SizedBox(height: 12),
                      const Text(
                        'حدث خطأ غير متوقع',
                        style: TextStyle(
                          fontFamily: 'Cairo',
                          fontWeight: FontWeight.w800,
                          fontSize: 18,
                          color: AppTheme.text,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        details.exceptionAsString(),
                        style: const TextStyle(
                          fontFamily: 'Cairo',
                          fontSize: 12,
                          color: AppTheme.textSecondary,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        };

        final media = MediaQuery.of(context);
        final fixedTextScale = media.textScaler.clamp(minScaleFactor: 1.0, maxScaleFactor: 1.0);

        return Directionality(
          textDirection: TextDirection.rtl,
          child: ScrollConfiguration(
            behavior: const AppScrollBehavior(),
            child: MediaQuery(
              data: media.copyWith(textScaler: fixedTextScale),
              child: child!,
            ),
          ),
        );
      },
    );
  }
}

class AppScrollBehavior extends MaterialScrollBehavior {
  const AppScrollBehavior();
  @override
  Set<PointerDeviceKind> get dragDevices => {
    PointerDeviceKind.touch,
    PointerDeviceKind.mouse,
    PointerDeviceKind.trackpad,
    PointerDeviceKind.stylus,
    PointerDeviceKind.unknown,
  };
}