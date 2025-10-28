// lib/controllers/home_controller.dart
import 'package:get/get.dart';
import '../models/lecture.dart';
import '../repositories/attendance_repository.dart';

class HomeController extends GetxController {
  final _repo = AttendanceRepository();

  final isLoading = false.obs;
  final lectures = <Lecture>[].obs;

  Future<void> loadForDate(DateTime d) async {
    isLoading.value = true;
    try {
      final dateIso = d.toIso8601String().split('T').first; // YYYY-MM-DD
      final list = await _repo.fetchSchedule(dateIso);
      lectures.assignAll(list);
    } catch (_) {
      lectures.clear();
    } finally {
      isLoading.value = false;
    }
  }
}