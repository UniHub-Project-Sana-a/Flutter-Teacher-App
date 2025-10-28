// lib/services/storage_service.dart
import 'package:get_storage/get_storage.dart';

class StorageService {
  StorageService._();
  static final StorageService instance = StorageService._();

  final _box = GetStorage();

  static const _kToken = 'token';
  static const _kName  = 'display_name';

  String? get token => _box.read<String?>(_kToken);
  Future<void> setToken(String? v) async => _box.write(_kToken, v);

  String? get displayName => _box.read<String?>(_kName);
  Future<void> setDisplayName(String? v) async => _box.write(_kName, v);

  Future<void> clear() async => _box.erase();
}