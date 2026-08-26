import '../core/constants/api_constants.dart';
import '../core/network/api_client.dart';
import '../models/onboarding_model.dart';
import '../models/profile_model.dart';
import '../models/preference_model.dart';
import 'local_storage_service.dart';

class UserService {
  final ApiClient apiClient;
  final LocalStorageService localStorage;

  UserService({required this.apiClient, required this.localStorage});

  Future<void> onboarding(OnboardingModel onboarding) async {
    final response = await apiClient.post(
      ApiConstants.onboarding,
      body: onboarding.toJson(),
    );

    if (response is! Map) {
      throw Exception('Response onboarding tidak valid.');
    }

    if (response['success'] != true) {
      throw Exception(response['message'] ?? 'Onboarding gagal.');
    }

    await localStorage.saveUserUuid(onboarding.uuid);

    await localStorage.saveUserTimezone(onboarding.timezone);

    await localStorage.saveReminderType(onboarding.reminderType);

    await localStorage.saveReminderSound(onboarding.reminderSound);
  }

  Future<bool> checkRegistration(String uuid) async {
    final response = await apiClient.get('${ApiConstants.splash}/$uuid');

    if (response is! Map) {
      throw Exception('Response pengecekan registrasi tidak valid.');
    }

    return response['is_registered'] == true;
  }

  Future<ProfileModel> getProfile(String uuid) async {
    final response = await apiClient.get(
      ApiConstants.profile,
      headers: {'X-User-UUID': uuid},
    );

    if (response is! Map) {
      throw Exception('Response profile tidak valid.');
    }

    final data = response['data'];

    if (data is! Map) {
      throw Exception('Data profile tidak valid.');
    }

    return ProfileModel.fromJson(Map<String, dynamic>.from(data));
  }

  Future<ProfileModel> updateProfile(ProfileModel profile) async {
    final response = await apiClient.put(
      ApiConstants.profile,
      headers: {'X-User-UUID': profile.uuid},
      body: {
        'name': profile.name,
        'age': profile.age,
        'gender': profile.gender,
      },
    );

    if (response is! Map) {
      throw Exception('Response update profile tidak valid.');
    }

    if (response['success'] != true) {
      throw Exception(response['message'] ?? 'Gagal memperbarui profile.');
    }

    final data = response['data'];

    if (data is! Map) {
      throw Exception('Data update profile tidak valid.');
    }

    return ProfileModel.fromJson(Map<String, dynamic>.from(data));
  }

  Future<PreferenceModel> getPreferences(String uuid) async {
    final response = await apiClient.get(
      ApiConstants.preferences,
      headers: {'X-User-UUID': uuid},
    );

    if (response is! Map) {
      throw Exception('Response preferences tidak valid.');
    }

    final data = response['data'];

    if (data is! Map) {
      throw Exception('Data preferences tidak valid.');
    }

    return PreferenceModel.fromJson(Map<String, dynamic>.from(data));
  }

  Future<PreferenceModel> updatePreferences({
    required String uuid,
    required PreferenceModel preference,
  }) async {
    final response = await apiClient.put(
      ApiConstants.preferences,
      headers: {'X-User-UUID': uuid},
      body: {
        'reminder_type': preference.reminderType,
        'reminder_sound': preference.reminderSound,
      },
    );

    if (response is! Map) {
      throw Exception('Response update preferences tidak valid.');
    }

    if (response['success'] != true) {
      throw Exception(response['message'] ?? 'Gagal memperbarui preferensi.');
    }

    final data = response['data'];

    if (data is! Map) {
      throw Exception('Data update preferences tidak valid.');
    }

    final updatedPreference = PreferenceModel.fromJson(
      Map<String, dynamic>.from(data),
    );

    await localStorage.saveReminderType(updatedPreference.reminderType);

    await localStorage.saveReminderSound(updatedPreference.reminderSound);

    return updatedPreference;
  }

  String? getUserUuid() {
    return localStorage.getUserUuid();
  }

  String? getUserTimezone() {
    return localStorage.getUserTimezone();
  }

  Future<void> clearUserUuid() async {
    await localStorage.removeUserUuid();
  }

  Future<void> clearUserTimezone() async {
    await localStorage.removeUserTimezone();
  }
}
