import 'package:flutter/foundation.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
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
  String? get userTimezone => userService.getUserTimezone();

  Future<String> _getDeviceTimezone() async {
    try {
      final timezone = await FlutterTimezone.getLocalTimezone();

      return timezone.identifier;
    } catch (e) {
      return 'UTC';
    }
  }

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

      final timezone = await _getDeviceTimezone();

      final formattedName = name
          .trim()
          .split(RegExp(r'\s+'))
          .where((word) => word.isNotEmpty)
          .map((word) => '${word[0].toUpperCase()}${word.substring(1)}')
          .join(' ');

      final onboarding = OnboardingModel(
        uuid: uuid,
        name: formattedName,
        reminderType: reminderType,
        reminderSound: reminderSound,
        timezone: timezone,
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
