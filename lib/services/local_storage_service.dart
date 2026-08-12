import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageService {
  static const String _userUuidKey = 'user_uuid';

  final SharedPreferences preferences;

  LocalStorageService(this.preferences);

  Future<void> saveUserUuid(String uuid) async {
    await preferences.setString(_userUuidKey, uuid);
  }

  String? getUserUuid() {
    return preferences.getString(_userUuidKey);
  }

  Future<void> removeUserUuid() async {
    await preferences.remove(_userUuidKey);
  }

  bool get hasUserUuid {
    return preferences.containsKey(_userUuidKey);
  }
}
