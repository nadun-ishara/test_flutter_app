import 'package:flutter/material.dart';
import '../../domain/entities/product_entity.dart';
import '../../domain/usecases/get_products_usecase.dart';

class CatalogController extends ChangeNotifier {
  final GetProductsUseCase getProductsUseCase;

  List<ProductEntity> _products = [];
  bool _isLoading = false;
  String _selectedCategory = 'All';
  String _searchQuery = '';
  String _sortBy = 'Popular';

  CatalogController({required this.getProductsUseCase});

  List<ProductEntity> get products => _products;
  bool get isLoading => _isLoading;
  String get selectedCategory => _selectedCategory;
  String get searchQuery => _searchQuery;
  String get sortBy => _sortBy;

  List<String> get categories => ['All', 'Electronics', 'Fashion', 'Home'];

  Future<void> loadProducts() async {
    _isLoading = true;
    notifyListeners();

    _products = await getProductsUseCase.execute(
      category: _selectedCategory,
      searchQuery: _searchQuery,
      sortBy: _sortBy,
    );

    _isLoading = false;
    notifyListeners();
  }

  void selectCategory(String category) {
    if (_selectedCategory == category) return;
    _selectedCategory = category;
    loadProducts();
  }

  void updateSearchQuery(String query) {
    _searchQuery = query;
    loadProducts();
  }

  void updateSortBy(String sortBy) {
    if (_sortBy == sortBy) return;
    _sortBy = sortBy;
    loadProducts();
  }

  void clearFilters() {
    _selectedCategory = 'All';
    _searchQuery = '';
    _sortBy = 'Popular';
    loadProducts();
  }
}
