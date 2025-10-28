// lib/views/auth/login_view.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/auth_controller.dart';
import '../../theme.dart';

class LoginView extends StatefulWidget {
  final String successRoute;
  const LoginView({super.key, this.successRoute = '/'});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _auth = Get.put(AuthController(), permanent: true);
  final _userC = TextEditingController();
  final _passC = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _hide = true.obs;

  @override
  void dispose() {
    _userC.dispose();
    _passC.dispose();
    super.dispose();
  }

  InputDecoration _deco(String hint) => InputDecoration(
    hintText: hint,
    filled: true,
    fillColor: Colors.white,
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: const BorderSide(color: AppTheme.border),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: const BorderSide(color: AppTheme.border),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: const BorderSide(color: AppTheme.primary, width: 2),
    ),
    hintStyle: const TextStyle(
      color: AppTheme.textSecondary,
      fontWeight: FontWeight.w700,
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xFFF8FAFC),
        appBar: AppBar(
          backgroundColor: AppTheme.primary,
          foregroundColor: Colors.white,
          title: const Text('تسجيل الدخول'),
          centerTitle: true,
        ),
        body: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              const SizedBox(height: 30),
              const Text(
                'مرحبًا بك 👋',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: AppTheme.text,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'الرجاء تسجيل الدخول للمتابعة',
                textAlign: TextAlign.center,
                style: TextStyle(color: AppTheme.textSecondary),
              ),
              const SizedBox(height: 24),

              const Text('اسم المستخدم أو الإيميل',
                  style: TextStyle(fontWeight: FontWeight.w700)),
              const SizedBox(height: 8),
              TextFormField(
                controller: _userC,
                textAlign: TextAlign.right,
                validator: (v) =>
                (v == null || v.trim().isEmpty) ? 'هذا الحقل مطلوب' : null,
                decoration: _deco('أدخل اسم المستخدم أو البريد الإلكتروني'),
              ),

              const SizedBox(height: 14),

              const Text('كلمة المرور',
                  style: TextStyle(fontWeight: FontWeight.w700)),
              const SizedBox(height: 8),
              Obx(
                    () => TextFormField(
                  controller: _passC,
                  textAlign: TextAlign.right,
                  obscureText: _hide.value,
                  validator: (v) =>
                  (v == null || v.trim().isEmpty) ? 'هذا الحقل مطلوب' : null,
                  decoration: _deco('••••••••').copyWith(
                    suffixIcon: IconButton(
                      icon: Icon(
                        _hide.value ? Icons.visibility_off : Icons.visibility,
                        color: AppTheme.textSecondary,
                      ),
                      onPressed: () => _hide.value = !_hide.value,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              SizedBox(
                height: 52,
                child: Obx(
                      () => ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14)),
                    ),
                    onPressed: _auth.isLoading.value
                        ? null
                        : () async {
                      if (_formKey.currentState?.validate() ?? false) {
                        final ok =
                        await _auth.login(_userC.text, _passC.text);
                        if (ok) Get.offAllNamed(widget.successRoute);
                      }
                    },
                    child: _auth.isLoading.value
                        ? const SizedBox(
                      height: 22,
                      width: 22,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.2,
                        valueColor:
                        AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                        : const Text('دخول',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w800)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}