import 'dart:async';

import 'package:flutter/foundation.dart';

import '../core/error/api_exception.dart';
import '../models/medicine_catalog_model.dart';
import '../services/medicine_catalog_service.dart';

class MedicineCatalogProvider extends ChangeNotifier {
  final MedicineCatalogService medicineCatalogService;

  MedicineCatalogProvider({required this.medicineCatalogService});

  bool _isLoading = false;

  String? _errorMessage;

  List<MedicineCatalogModel> _catalogs = [];

  Timer? _debounce;

  bool get isLoading => _isLoading;

  String? get errorMessage => _errorMessage;

  List<MedicineCatalogModel> get catalogs => _catalogs;

  Future<void> searchCatalogs(String keyword) async {
    _debounce?.cancel();

    final query = keyword.trim();

    if (query.isEmpty) {
      _catalogs = [];
      _errorMessage = null;
      _isLoading = false;
      notifyListeners();
      return;
    }

    _debounce = Timer(const Duration(milliseconds: 350), () async {
      await _performSearch(query);
    });
  }

  Future<void> _performSearch(String query) async {
    _isLoading = true;
    _errorMessage = null;

    notifyListeners();

    try {
      _catalogs = await medicineCatalogService.searchCatalogs(search: query);
    } on ApiException catch (e) {
      _catalogs = [];
      _errorMessage = e.message;
    } catch (e) {
      _catalogs = [];
      _errorMessage = 'Gagal mencari katalog obat.';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearResults() {
    _debounce?.cancel();

    _catalogs = [];
    _errorMessage = null;
    _isLoading = false;

    notifyListeners();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }
}
