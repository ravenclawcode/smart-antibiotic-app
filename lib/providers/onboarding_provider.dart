import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';

import '../core/error/api_exception.dart';
import '../models/onboarding_model.dart';
import '../services/user_service.dart';

class OnboardingProvider extends ChangeNotifier {
  final UserService userService;

  OnboardingProvider({required this.userService});

  bool _isLoading = false;
  String? _errorMessage;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<bool> submitOnboarding({
    required String name,
    required String reminderType,
    required String reminderSound,
  }) async {
    if (_isLoading) {
      return false;
    }

    _isLoading = true;
    _errorMessage = null;

    notifyListeners();

    try {
      final uuid = const Uuid().v4();

      final onboarding = OnboardingModel(
        uuid: uuid,
        name: name.trim(),
        reminderType: reminderType,
        reminderSound: reminderSound,
        timezone: 'Asia/Jakarta',
      );

      await userService.onboarding(onboarding);

      return true;
    } on ApiException catch (e) {
      _errorMessage = e.message;
      return false;
    } catch (e) {
      _errorMessage = 'Gagal menyimpan data onboarding.';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> checkRegistration() async {
    final uuid = userService.getUserUuid();

    if (uuid == null || uuid.trim().isEmpty) {
      return false;
    }

    try {
      final isRegistered = await userService.checkRegistration(uuid);

      if (!isRegistered) {
        await userService.clearUserUuid();
      }

      return isRegistered;
    } on ApiException catch (e) {
      _errorMessage = e.message;
      return false;
    } catch (e) {
      _errorMessage = 'Tidak dapat memeriksa status registrasi.';
      return false;
    }
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
