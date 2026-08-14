import 'package:flutter/foundation.dart';

import '../models/antibiotic_category_model.dart';
import '../models/antibiotic_detail_model.dart';
import '../models/antibiotic_model.dart';
import '../services/antibiotic_service.dart';

class AntibioticProvider extends ChangeNotifier {
  final AntibioticService service;

  AntibioticProvider({required this.service});

  List<AntibioticCategoryModel> _categories = [];

  List<AntibioticCategoryModel> get categories => _categories;

  bool _isLoadingCategories = false;

  bool get isLoadingCategories => _isLoadingCategories;

  String? _categoryError;

  String? get categoryError => _categoryError;

  List<AntibioticModel> _antibiotics = [];

  List<AntibioticModel> get antibiotics => _antibiotics;

  bool _isLoadingAntibiotics = false;

  bool get isLoadingAntibiotics => _isLoadingAntibiotics;

  String? _antibioticError;

  String? get antibioticError => _antibioticError;

  List<AntibioticCategoryModel> _searchResults = [];

  List<AntibioticCategoryModel> get searchResults => _searchResults;

  bool _isSearching = false;

  bool get isSearching => _isSearching;

  String? _searchError;

  String? get searchError => _searchError;

  AntibioticDetailModel? _detail;

  AntibioticDetailModel? get detail => _detail;

  bool _isLoadingDetail = false;

  bool get isLoadingDetail => _isLoadingDetail;

  String? _detailError;

  String? get detailError => _detailError;

  Future<void> loadCategories() async {
    _isLoadingCategories = true;
    _categoryError = null;

    notifyListeners();

    try {
      _categories = await service.getCategories();
    } catch (e) {
      _categoryError = e.toString();
    } finally {
      _isLoadingCategories = false;
      notifyListeners();
    }
  }

  Future<void> loadAntibiotics(int categoryId) async {
    _isLoadingAntibiotics = true;
    _antibioticError = null;

    notifyListeners();

    try {
      _antibiotics = await service.getAntibioticsByCategory(categoryId);
    } catch (e) {
      _antibioticError = e.toString();
    } finally {
      _isLoadingAntibiotics = false;
      notifyListeners();
    }
  }

  Future<void> searchCategories(String keyword) async {
    final query = keyword.trim();

    if (query.isEmpty) {
      _searchResults = [];
      _isSearching = false;
      notifyListeners();
      return;
    }

    _isSearching = true;
    _searchError = null;

    notifyListeners();

    try {
      _searchResults = await service.searchCategories(query);
    } catch (e) {
      _searchError = e.toString();
      _searchResults = [];
    } finally {
      _isSearching = false;
      notifyListeners();
    }
  }

  Future<void> loadDetail({
    required int categoryId,
    required int antibioticId,
  }) async {
    _isLoadingDetail = true;
    _detailError = null;
    _detail = null;

    notifyListeners();

    try {
      _detail = await service.getAntibioticDetail(
        categoryId: categoryId,
        antibioticId: antibioticId,
      );
    } catch (e) {
      _detailError = e.toString();
    } finally {
      _isLoadingDetail = false;
      notifyListeners();
    }
  }

  void clearSearch() {
    _searchResults = [];
    notifyListeners();
  }
}
