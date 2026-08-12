import 'package:flutter/foundation.dart';

import '../core/error/api_exception.dart';
import '../models/preference_model.dart';
import '../models/profile_model.dart';
import '../services/user_service.dart';

class SettingsProvider extends ChangeNotifier {
  final UserService userService;

  SettingsProvider({required this.userService});

  bool _isLoading = false;
  bool _isSaving = false;

  String? _errorMessage;

  ProfileModel? _profile;
  PreferenceModel? _preferences;

  bool get isLoading => _isLoading;

  bool get isSaving => _isSaving;

  String? get errorMessage => _errorMessage;

  ProfileModel? get profile => _profile;

  PreferenceModel? get preferences => _preferences;

  Future<bool> loadProfile() async {
    final uuid = userService.getUserUuid();

    if (uuid == null || uuid.trim().isEmpty) {
      _errorMessage = 'UUID pengguna tidak ditemukan.';

      return false;
    }

    _isLoading = true;
    _errorMessage = null;

    notifyListeners();

    try {
      _profile = await userService.getProfile(uuid);

      return true;
    } on ApiException catch (e) {
      _errorMessage = e.message;

      return false;
    } catch (e) {
      _errorMessage = 'Gagal mengambil data profil.';

      return false;
    } finally {
      _isLoading = false;

      notifyListeners();
    }
  }

  Future<bool> updateProfile({
    required String name,
    required String age,
    required String gender,
  }) async {
    final uuid = userService.getUserUuid();

    if (uuid == null || uuid.trim().isEmpty) {
      _errorMessage = 'UUID pengguna tidak ditemukan.';

      return false;
    }

    _isSaving = true;
    _errorMessage = null;

    notifyListeners();

    try {
      final profile = ProfileModel(
        uuid: uuid,
        name: name.trim(),
        age: int.tryParse(age.trim()),
        gender: gender.trim().isEmpty ? null : gender.trim(),
      );

      final updatedProfile = await userService.updateProfile(profile);

      _profile = updatedProfile;

      return true;
    } on ApiException catch (e) {
      _errorMessage = e.message;

      return false;
    } catch (e) {
      _errorMessage = 'Gagal menyimpan perubahan profil.';

      return false;
    } finally {
      _isSaving = false;

      notifyListeners();
    }
  }

  Future<bool> loadPreferences() async {
    final uuid = userService.getUserUuid();

    if (uuid == null || uuid.trim().isEmpty) {
      _errorMessage = 'UUID pengguna tidak ditemukan.';

      return false;
    }

    _isLoading = true;
    _errorMessage = null;

    notifyListeners();

    try {
      _preferences = await userService.getPreferences(uuid);

      return true;
    } on ApiException catch (e) {
      _errorMessage = e.message;

      return false;
    } catch (e) {
      _errorMessage = 'Gagal mengambil data preferensi.';

      return false;
    } finally {
      _isLoading = false;

      notifyListeners();
    }
  }

  Future<bool> updatePreferences({
    required String reminderType,
    required String reminderSound,
  }) async {
    final uuid = userService.getUserUuid();

    if (uuid == null || uuid.trim().isEmpty) {
      _errorMessage = 'UUID pengguna tidak ditemukan.';

      return false;
    }

    if (reminderType.trim().isEmpty) {
      _errorMessage = 'Jenis pengingat harus dipilih.';

      notifyListeners();

      return false;
    }

    _isSaving = true;
    _errorMessage = null;

    notifyListeners();

    try {
      final preference = PreferenceModel(
        reminderType: reminderType,
        reminderSound: reminderSound,
        timezone: _preferences?.timezone ?? 'Asia/Jakarta',
      );

      final updatedPreference = await userService.updatePreferences(
        uuid: uuid,
        preference: preference,
      );

      _preferences = updatedPreference;

      return true;
    } on ApiException catch (e) {
      _errorMessage = e.message;

      return false;
    } catch (e) {
      _errorMessage = 'Gagal menyimpan perubahan preferensi.';

      return false;
    } finally {
      _isSaving = false;

      notifyListeners();
    }
  }

  void clearError() {
    if (_errorMessage == null) {
      return;
    }

    _errorMessage = null;

    notifyListeners();
  }
}
