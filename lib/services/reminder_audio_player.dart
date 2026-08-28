import 'package:audioplayers/audioplayers.dart';

import '../services/local_storage_service.dart';

class ReminderAudioPlayer {
  ReminderAudioPlayer._();

  static final ReminderAudioPlayer instance = ReminderAudioPlayer._();

  final AudioPlayer _player = AudioPlayer();

  LocalStorageService? _localStorage;

  bool _initialized = false;
  bool _isMuted = false;

  static const Map<String, String> _soundResources = {
    'Nada Standar': 'y_que_fue',
    'Melodi Lembut': 'cartel',
    'Suara Alam': 'barudak_phonk',
  };

  static const String _defaultSoundResource = 'y_que_fue';

  void setLocalStorage(LocalStorageService localStorage) {
    _localStorage = localStorage;
  }

  Future<void> initialize() async {
    if (_initialized) {
      return;
    }

    await _player.setReleaseMode(ReleaseMode.loop);
    await _player.setVolume(1.0);

    _initialized = true;
  }

  String _getSoundResourceName() {
    final savedSound = _localStorage?.getReminderSound();

    if (savedSound == null || savedSound.trim().isEmpty) {
      return _defaultSoundResource;
    }

    return _soundResources[savedSound] ?? _defaultSoundResource;
  }

  Future<void> play() async {
    await initialize();

    if (_isMuted) {
      return;
    }

    final soundResource = _getSoundResourceName();

    await _player.stop();

    await _player.play(AssetSource('sounds/$soundResource.mp3'));
  }

  Future<void> stop() async {
    await _player.stop();
  }

  Future<void> mute() async {
    _isMuted = true;
    await _player.pause();
  }

  Future<void> unmute() async {
    _isMuted = false;
    await _player.resume();
  }

  bool get isMuted => _isMuted;

  Future<void> dispose() async {
    await _player.dispose();
    _initialized = false;
  }
}
