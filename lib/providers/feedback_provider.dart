import 'package:flutter/foundation.dart';

import '../core/error/api_exception.dart';
import '../models/feedback_model.dart';
import '../services/feedback_service.dart';

class FeedbackProvider extends ChangeNotifier {
  final FeedbackService feedbackService;

  FeedbackProvider({required this.feedbackService});

  List<FeedbackModel> _feedbacks = [];

  bool _isLoading = false;
  bool _isSubmitting = false;
  int? _deletingId;

  String? _errorMessage;

  List<FeedbackModel> get feedbacks => _feedbacks;

  bool get isLoading => _isLoading;

  bool get isSubmitting => _isSubmitting;

  int? get deletingId => _deletingId;

  String? get errorMessage => _errorMessage;

  Future<void> fetchFeedbacks() async {
    if (_isLoading) return;

    _isLoading = true;
    _errorMessage = null;

    notifyListeners();

    try {
      _feedbacks = await feedbackService.getFeedbacks();
    } on ApiException catch (e) {
      _errorMessage = e.message;
    } catch (e) {
      _errorMessage = 'Gagal mengambil komentar dan masukan.';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> submitFeedback(String message) async {
    if (_isSubmitting) return false;

    final trimmedMessage = message.trim();

    if (trimmedMessage.isEmpty) {
      _errorMessage = 'Komentar atau masukan tidak boleh kosong.';
      notifyListeners();
      return false;
    }

    _isSubmitting = true;
    _errorMessage = null;

    notifyListeners();

    try {
      await feedbackService.createFeedback(trimmedMessage);
      await _reloadFeedbacks();

      return true;
    } on ApiException catch (e) {
      _errorMessage = e.message;
      return false;
    } catch (e) {
      _errorMessage = 'Gagal mengirim komentar atau masukan.';
      return false;
    } finally {
      _isSubmitting = false;
      notifyListeners();
    }
  }

  Future<bool> deleteFeedback(int feedbackId) async {
    if (_deletingId != null) return false;

    _deletingId = feedbackId;
    _errorMessage = null;

    notifyListeners();

    try {
      await feedbackService.deleteFeedback(feedbackId);

      _feedbacks.removeWhere((feedback) => feedback.id == feedbackId);

      return true;
    } on ApiException catch (e) {
      _errorMessage = e.message;
      return false;
    } catch (e) {
      _errorMessage = 'Gagal menghapus komentar.';
      return false;
    } finally {
      _deletingId = null;
      notifyListeners();
    }
  }

  Future<void> refresh() async {
    await _reloadFeedbacks();
  }

  Future<void> _reloadFeedbacks() async {
    try {
      _feedbacks = await feedbackService.getFeedbacks();
      _errorMessage = null;
    } on ApiException catch (e) {
      _errorMessage = e.message;
    } catch (e) {
      _errorMessage = 'Gagal memperbarui komentar.';
    }
  }

  String get userName {
    if (feedbacks.isNotEmpty) {
      return feedbacks.first.name;
    }

    return '';
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
