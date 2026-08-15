import 'package:flutter/foundation.dart';

import '../models/chat_message_model.dart';
import '../services/chatbot_service.dart';
import '../services/local_storage_service.dart';

class ChatbotProvider extends ChangeNotifier {
  final ChatbotService service;
  final LocalStorageService localStorage;

  ChatbotProvider({required this.service, required this.localStorage});

  final List<ChatMessageModel> _messages = [];

  bool _isLoading = true;
  bool _isSending = false;
  String? _errorMessage;

  List<ChatMessageModel> get messages => List.unmodifiable(_messages);

  bool get isLoading => _isLoading;

  bool get isSending => _isSending;

  String? get errorMessage => _errorMessage;

  String get _userUuid {
    return localStorage.getUserUuid() ?? '';
  }

  Future<void> fetchSession() async {
    await Future.delayed(const Duration(milliseconds: 600));

    _isLoading = true;
    _errorMessage = null;

    notifyListeners();

    try {
      final userUuid = _userUuid;

      if (userUuid.isEmpty) {
        throw Exception('User UUID tidak ditemukan.');
      }

      final session = await service.getSession(userUuid);

      _messages
        ..clear()
        ..addAll(session.messages);

      if (_messages.isEmpty) {
        _messages.add(
          ChatMessageModel(
            id: 0,
            sessionId: session.id,
            sender: 'assistant',
            message: '',
            createdAt: DateTime.now(),
          ),
        );
      }
    } catch (e) {
      _errorMessage = e.toString();

      _messages
        ..clear()
        ..add(
          ChatMessageModel(
            id: 0,
            sessionId: 0,
            sender: 'assistant',
            message: '',
            createdAt: DateTime.now(),
          ),
        );
    } finally {
      _isLoading = false;

      notifyListeners();
    }
  }

  Future<void> sendMessage(String message) async {
    final text = message.trim();

    if (text.isEmpty || _isSending) {
      return;
    }

    final userUuid = _userUuid;

    if (userUuid.isEmpty) {
      _errorMessage = 'User UUID tidak ditemukan.';
      notifyListeners();
      return;
    }

    _isSending = true;
    _errorMessage = null;

    _messages.add(
      ChatMessageModel(
        id: 0,
        sessionId: 0,
        sender: 'user',
        message: text,
        createdAt: DateTime.now(),
      ),
    );

    notifyListeners();

    try {
      final assistantMessage = await service.sendMessage(
        userUuid: userUuid,
        message: text,
      );

      _messages.add(assistantMessage);
    } catch (e) {
      _errorMessage = e.toString();

      _messages.add(
        ChatMessageModel(
          id: 0,
          sessionId: 0,
          sender: 'assistant',
          message: 'Maaf, Sherly sedang mengalami gangguan. Silakan coba lagi.',
          createdAt: DateTime.now(),
        ),
      );
    } finally {
      _isSending = false;

      notifyListeners();
    }
  }

  Future<void> deleteChat() async {
    _errorMessage = null;

    try {
      final userUuid = _userUuid;

      if (userUuid.isEmpty) {
        throw Exception('User UUID tidak ditemukan.');
      }

      await service.deleteSession(userUuid);

      await fetchSession();
    } catch (e) {
      _errorMessage = e.toString();

      notifyListeners();

      rethrow;
    }
  }

  void clearLocalMessages() {
    _messages.clear();

    _messages.add(
      ChatMessageModel(
        id: 0,
        sessionId: 0,
        sender: 'assistant',
        message: '',
        createdAt: DateTime.now(),
      ),
    );

    notifyListeners();
  }
}
