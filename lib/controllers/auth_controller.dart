// lib/controllers/auth_controller.dart
import 'package:get/get.dart';
import '../repositories/auth_repository.dart';
import '../services/storage_service.dart';

class AuthController extends GetxController {
  final isLoggedIn = false.obs;
  final displayName = ''.obs;
  final isLoading = false.obs;

  final _repo = AuthRepository();

  Future<bool> login(String userOrEmail, String password) async {
    isLoading.value = true;
    try {
      final (token, name) =
      await _repo.login(userOrEmail: userOrEmail, password: password);
      await StorageService.instance.setToken(token);
      await StorageService.instance.setDisplayName(name);
      displayName.value = name;
      isLoggedIn.value = true;
      return true;
    } catch (_) {
      Get.snackbar('فشل الدخول', 'تحقق من البيانات أو الاتصال');
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> logout() async {
    await StorageService.instance.clear();
    isLoggedIn.value = false;
    displayName.value = '';
  }
}