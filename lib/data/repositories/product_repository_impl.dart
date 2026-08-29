import '../../domain/entities/product_entity.dart';
import '../../domain/repositories/product_repository.dart';
import '../datasources/mock_product_datasource.dart';

class ProductRepositoryImpl implements ProductRepository {
  final MockProductDataSource dataSource;

  ProductRepositoryImpl({required this.dataSource});

  @override
  Future<List<ProductEntity>> getProducts() async {
    return await dataSource.fetchProducts();
  }

  @override
  Future<List<ProductEntity>> getProductsByCategory(String category) async {
    final products = await dataSource.fetchProducts();
    if (category == 'All') return products;
    return products
        .where((p) => p.category.toLowerCase() == category.toLowerCase())
        .toList();
  }

  @override
  Future<ProductEntity?> getProductById(String id) async {
    final products = await dataSource.fetchProducts();
    try {
      return products.firstWhere((p) => p.id == id);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<List<ProductEntity>> searchProducts(String query) async {
    final products = await dataSource.fetchProducts();
    if (query.isEmpty) return products;
    final q = query.toLowerCase();
    return products
        .where((p) =>
            p.name.toLowerCase().contains(q) ||
            p.description.toLowerCase().contains(q) ||
            p.category.toLowerCase().contains(q))
        .toList();
  }
}
