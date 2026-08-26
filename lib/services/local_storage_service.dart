import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageService {
  static const String _userUuidKey = 'user_uuid';
  static const String _userTimezoneKey = 'user_timezone';
  static const String _reminderTypeKey = 'reminder_type';
  static const String _reminderSoundKey = 'reminder_sound';

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

  Future<void> saveUserTimezone(String timezone) async {
    await preferences.setString(_userTimezoneKey, timezone);
  }

  String? getUserTimezone() {
    return preferences.getString(_userTimezoneKey);
  }

  Future<void> removeUserTimezone() async {
    await preferences.remove(_userTimezoneKey);
  }

  bool get hasUserTimezone {
    return preferences.containsKey(_userTimezoneKey);
  }

  Future<void> saveReminderType(String type) async {
    await preferences.setString(_reminderTypeKey, type);
  }

  String? getReminderType() {
    return preferences.getString(_reminderTypeKey);
  }

  Future<void> saveReminderSound(String sound) async {
    await preferences.setString(_reminderSoundKey, sound);
  }

  String? getReminderSound() {
    return preferences.getString(_reminderSoundKey);
  }

  Future<void> removeReminderPreferences() async {
    await preferences.remove(_reminderTypeKey);
    await preferences.remove(_reminderSoundKey);
  }

  Future<void> clearUserData() async {
    await preferences.remove(_userUuidKey);
    await preferences.remove(_userTimezoneKey);
    await preferences.remove(_reminderTypeKey);
    await preferences.remove(_reminderSoundKey);
  }
}
