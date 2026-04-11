import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService {
  SecureStorageService({FlutterSecureStorage? storage})
      : _storage = storage ?? const FlutterSecureStorage();

  final FlutterSecureStorage _storage;

  static const String _societyIdKey = 'society_id';
  static const String _userRoleKey = 'user_role';

  Future<void> write({required String key, required String value}) async {
    await _storage.write(key: key, value: value);
  }

  Future<String?> read({required String key}) async {
    return _storage.read(key: key);
  }

  Future<void> delete({required String key}) async {
    await _storage.delete(key: key);
  }

  Future<void> clearAll() async {
    await _storage.deleteAll();
  }

  Future<void> saveSocietyId(String societyId) async {
    await write(key: _societyIdKey, value: societyId);
  }

  Future<String?> getSocietyId() async {
    return read(key: _societyIdKey);
  }

  Future<void> saveUserRole(String role) async {
    await write(key: _userRoleKey, value: role);
  }

  Future<String?> getUserRole() async {
    return read(key: _userRoleKey);
  }
}
